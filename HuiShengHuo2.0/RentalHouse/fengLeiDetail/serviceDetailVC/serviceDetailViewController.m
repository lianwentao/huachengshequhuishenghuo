//
//  serviceDetailViewController.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/24.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "serviceDetailViewController.h"
#import "WRNavigationBar.h"
#import "queRenViewController.h"
#import "businessDetailViewController.h"
#import "pingLunViewController.h"

#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#import "fwDetailModel.h"
#import "tagListModel.h"
#import "scoreInfoModel.h"
#import "imgListModel.h"
#import "insinfoModel.h"
#import "serviceListModel.h"
#import "VOTagList.h"

#import "WXApi.h"
#import "WXApiManager.h"
#import "activitydetailsViewController.h"
#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + NAV_HEIGHT)
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 0
#define SCROLL_DOWN_LIMIT 70
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)
@interface serviceDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataSourceArr;
    NSMutableArray *tagListArr;
    NSMutableArray *scoreInfoArr;
    NSMutableArray *imgListArr;
    NSMutableArray *insinfoArr;
    NSMutableArray *serviceListArr;
    NSMutableArray *labelArr;
    NSMutableArray *titleArr;
    NSMutableArray *titleImgArr;
    NSMutableArray *imgIDArr;
    NSDictionary *dataDic;
    NSMutableDictionary *_DataDic;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic ,strong) UIView *deliverView; //底部View
@property (nonatomic ,strong) UIView *BGView; //遮罩

@end

@implementation serviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _serviceTitle;
    [self getData];
    [self setupNavItems];
//    [self CreateTableview];
    [self loadFunctionView];
    [self wr_setNavBarBarTintColor:BackColor];
    [self wr_setNavBarBackgroundAlpha:0];
    
}

- (void)getData{

    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    dict = @{@"id":_serviceID};
    NSString *strurl = [API_NOAPK stringByAppendingString:@"/service/service/serviceDetails"];
    [manager POST:strurl parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"dataStr = %@",dataStr);
        _DataDic = [[NSMutableDictionary alloc] init];
        _DataDic = [responseObject objectForKey:@"data"];
        NSLog(@"goods--%@",_DataDic);
        dataDic = responseObject[@"data"];
        dataSourceArr = [NSMutableArray array];
        fwDetailModel *model = [[fwDetailModel alloc]initWithDictionary:dataDic error:NULL];
        [dataSourceArr addObject:model];
        tagListArr = [NSMutableArray array];
        for (NSDictionary *tagListDic in model.tag_list) {
            tagListModel *tModel = [[tagListModel alloc]initWithDictionary:tagListDic error:NULL];
            [tagListArr addObject:tModel];
        }
          
        scoreInfoArr = [NSMutableArray array];
        if ([dataDic[@"score_info"] isKindOfClass:[NSNull class]]) {
            NSLog(@"1111111111");
        }else{
            scoreInfoModel *sModel = [[scoreInfoModel alloc]initWithDictionary:dataDic[@"score_info"] error:NULL];
            [scoreInfoArr addObject:sModel];
        }
        
        imgListArr = [NSMutableArray array];
        for (NSDictionary *imgDic in model.img_list) {
            imgListModel *imgModel = [[imgListModel alloc]initWithDictionary:imgDic error:NULL];
            [imgListArr addObject:imgModel.img];
        }
            
        insinfoArr = [NSMutableArray array];
        insinfoModel *iiModel = [[insinfoModel alloc]initWithDictionary:model.ins_info error:NULL];
        [insinfoArr addObject:iiModel];
            
        serviceListArr = [NSMutableArray array];
        for (NSDictionary *serviceListDic in model.ins_info[@"service_list"]) {
            serviceListModel *slModel = [[serviceListModel alloc]initWithDictionary:serviceListDic error:NULL];
            [serviceListArr addObject:slModel];
        }
    
       [self CreateTableview];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < -IMAGE_HEIGHT) {
        [self updateNavBarButtonItemsAlphaAnimated:.0f];
    } else {
        [self updateNavBarButtonItemsAlphaAnimated:1.0f];
    }
    
    if (offsetY > NAVBAR_COLORCHANGE_POINT)
    {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
        [self wr_setNavBarBackgroundAlpha:alpha];
    }
    else
    {
        [self wr_setNavBarBackgroundAlpha:0];
    }
    
    //    //限制下拉的距离
    //    if(offsetY < LIMIT_OFFSET_Y) {
    //        [scrollView setContentOffset:CGPointMake(0, LIMIT_OFFSET_Y)];
    //    }
}

- (void)updateNavBarButtonItemsAlphaAnimated:(CGFloat)alpha
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.navigationController.navigationBar wr_setBarButtonItemsAlpha:alpha hasSystemBackIndicator:NO];
    }];
}
-(void)CreateTableview{
    
    CGRect frame = CGRectMake(0, 0, Main_width, Main_Height-50);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT - [self navBarBottom], 0, 0, 0);
    [self.view addSubview:_tableView];
}

- (int)navBarBottom
{
    if ([WRNavigationBar isIphoneX]) {
        return 88;
    } else {
        return 64;
    }
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 180;
    }else if (indexPath.section == 4){
        if ([dataDic[@"score_info"] isKindOfClass:[NSNull class]]){
            return 0;
        }else{
            return 150;
        }
    }else if (indexPath.section == 5){
        return imgListArr.count*200;
//        CGFloat height = 0;
//        NSMutableArray *heightArr = [NSMutableArray array];
//        for (int i = 0; i < imgListArr.count; i++) {
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[API_img stringByAppendingString:imgListArr[i]]]];
//            UIImage *showimage = [UIImage imageWithData:data];
//
//            height = (Main_width-20)*(showimage.size.height/showimage.size.width);
//
//            NSString *h = [NSString stringWithFormat:@"%lf",height];
//            [heightArr addObject:h];
//            NSLog(@"heightArr = %@",heightArr);
//
//        }
//
//        for (int j = 0; j < heightArr.count; j++) {
//
//            height += [heightArr[j] floatValue];
//        }
//         NSLog(@"h222 = %f",height);
//        return height;
    }else if (indexPath.section == 6){
        return 260;
    }else {
        return 50;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
   
    fwDetailModel *model = dataSourceArr[0];
    if (indexPath.section == 0) {
        
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.frame = CGRectMake(0, 0, Main_width, 180);
        [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:model.title_img]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
        [cell addSubview:imgView];
        
    }else if (indexPath.section == 1){
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.frame = CGRectMake(10, 10, Main_width-20, 30);
        titleLab.text = model.title;
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:titleLab];
        
    }else if (indexPath.section == 2){
        
        tagListModel *model = tagListArr[0];
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.frame = CGRectMake(10, 10, 60, 30);
        titleLab.text = @"价格";
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:titleLab];
        
        UILabel *priceLab = [[UILabel alloc]init];
        priceLab.frame = CGRectMake(CGRectGetMaxX(titleLab.frame), 10, Main_width-20-60, 30);
        priceLab.text = model.price;
        priceLab.textColor = [UIColor redColor];
        priceLab.font = [UIFont systemFontOfSize:15];
        priceLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:priceLab];
        
        
        
    }else if (indexPath.section == 3){
        
        tagListModel *model = tagListArr[0];
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.frame = CGRectMake(10, 10, 60, 30);
        titleLab.text = @"分类";
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:titleLab];
        
        UILabel *flLab = [[UILabel alloc]init];
        flLab.frame = CGRectMake(CGRectGetMaxX(titleLab.frame), 10, Main_width-20-60, 30);
        flLab.layer.cornerRadius = 5;
        flLab.clipsToBounds = YES;
        flLab.adjustsFontSizeToFitWidth = YES;
        flLab.text= model.tagname;
        flLab.textAlignment = NSTextAlignmentCenter;
        [flLab sizeToFit];//使用sizeToFit
        flLab.center = CGPointMake(self.view.bounds.size.width/3, 25) ;
        flLab.textColor=[UIColor whiteColor];
        flLab.backgroundColor=[UIColor redColor];
        [cell addSubview:flLab];
        
    }else if (indexPath.section == 4){
        
        if ([dataDic[@"score_info"] isKindOfClass:[NSNull class]]){}else{
            scoreInfoModel *model = scoreInfoArr[0];
            UIImageView *pjImg = [[UIImageView alloc]init];
            pjImg.frame = CGRectMake(10, 10, 80, 40);
            //        [pjImg sd_setImageWithURL:[NSURL URLWithString:model.avatars] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
            [cell addSubview:pjImg];
            
            UIButton *plBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            plBtn.frame = CGRectMake(Main_width-100-20, 10, 100, 40);
            [plBtn setTitle:[NSString stringWithFormat:@"共%@条评论 >",model.score_num] forState:UIControlStateNormal];
            plBtn.titleLabel.textAlignment = NSTextAlignmentRight;
            plBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [plBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [plBtn addTarget:self action:@selector(plBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:plBtn];
            
            UIImageView *headImg = [[UIImageView alloc]init];
            headImg.frame = CGRectMake(10, CGRectGetMaxY(pjImg.frame)+10, 40, 40);
            headImg.layer.cornerRadius = 20;
            headImg.clipsToBounds = YES;
            [headImg sd_setImageWithURL:[NSURL URLWithString:model.avatars] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
            [cell addSubview:headImg];
            
            UILabel *nameLab = [[UILabel alloc]init];
            nameLab.frame = CGRectMake(CGRectGetMaxX(headImg.frame)+10, CGRectGetMaxY(pjImg.frame)+10, 150, 20);
            nameLab.text = model.nickname;
            nameLab.font = [UIFont systemFontOfSize:15];
            nameLab.textAlignment = NSTextAlignmentLeft;
            nameLab.textColor = [UIColor lightGrayColor];
            [cell addSubview:nameLab];
            
            int i = [model.score intValue];
            for (int j = 0; j<i; j++) {
                UIImageView *starView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImg.frame)+10+j*20, CGRectGetMaxY(nameLab.frame), 20, 20)];
                starView.image = [UIImage imageNamed:@"circle_icon_xingxing_dianjihou"];
                [cell.contentView addSubview:starView];
            }
            
            UILabel *timeLab = [[UILabel alloc]init];
            timeLab.frame = CGRectMake(Main_width-20-100, CGRectGetMaxY(pjImg.frame)+10, 100, 20);
            NSTimeInterval time=[model.evaluatime doubleValue]+28800;
            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            NSLog(@"date:%@",[detaildate description]);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
            timeLab.text = currentDateStr;
            timeLab.font = [UIFont systemFontOfSize:15];
            timeLab.textAlignment = NSTextAlignmentRight;
            timeLab.textColor = [UIColor lightGrayColor];
            [cell addSubview:timeLab];
            
            UILabel *titleLab = [[UILabel alloc]init];
            titleLab.frame = CGRectMake(10, CGRectGetMaxY(headImg.frame)+10, Main_width-20, 20);
            titleLab.text = model.evaluate;
            titleLab.font = [UIFont systemFontOfSize:15];
            titleLab.textAlignment = NSTextAlignmentLeft;
            titleLab.textColor = [UIColor blackColor];
            [cell addSubview:titleLab];
        }
        
        
    }else if (indexPath.section == 5){
        NSMutableArray *imgHArr = [NSMutableArray array];
        for (int i = 0; i < imgListArr.count; i++) {
            UIImageView *imgView = [[UIImageView alloc]init];
           
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:imgListArr[i]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
            imgView.frame = CGRectMake(10, 10+(i*200), Main_width-20, 200);
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[API_img stringByAppendingString:imgListArr[i]]]];
//            UIImage *showimage = [UIImage imageWithData:data];
//            NSLog(@"w1111 = %f,h11111 = %f",showimage.size.width,showimage.size.height);
            
//            imgView.frame = CGRectMake(10, 10+(i*200), Main_width-20, (Main_width-20)*(showimage.size.height/showimage.size.width));
//            CGFloat Y = (Main_width-20)*(showimage.size.height/showimage.size.width);
//            NSString *imgH = [NSString stringWithFormat:@"%lf",Y];
//            [imgHArr addObject:imgH];
//            NSLog(@"imgHArr = %@",imgHArr);
//
//            if (i == 0) {
//
//                imgView.frame = CGRectMake(10,0, Main_width-20, (Main_width-20)*(showimage.size.height/showimage.size.width));
//            }else if (i == 1){
//                NSString *h = imgHArr[i-1];
//                 imgView.frame = CGRectMake(10,[h floatValue], Main_width-20, (Main_width-20)*(showimage.size.height/showimage.size.width));
//            }else{
//                imgView.frame = CGRectMake(10,0, Main_width-20, (Main_width-20)*(showimage.size.height/showimage.size.width));
//            }
//
            
            
            [cell addSubview:imgView];
        }  
    }else{
        
        insinfoModel *iiModel = insinfoArr[0];
        UIImageView *logoImg = [[UIImageView alloc]init];
        logoImg.frame = CGRectMake(10, 10, 50, 50);
        logoImg.layer.cornerRadius = 25;
        logoImg.clipsToBounds = YES;
        [logoImg sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:iiModel.logo]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
        [cell addSubview:logoImg];
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.frame = CGRectMake(CGRectGetMaxX(logoImg.frame)+5, 10, Main_width-20-50+5, 25);
        titleLab.text = iiModel.name;
        titleLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:titleLab];
        
        UILabel *titleLab1 = [[UILabel alloc]init];
        titleLab1.frame = CGRectMake(CGRectGetMaxX(logoImg.frame)+5, CGRectGetMaxY(titleLab.frame), 100, 20);
        titleLab1.font = [UIFont systemFontOfSize:12];
        titleLab1.text = [NSString stringWithFormat:@"共%@个优惠券",iiModel.coupon_num];
        titleLab1.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:titleLab1];
        
        UILabel *titleLab2 = [[UILabel alloc]init];
        titleLab2.frame = CGRectMake(CGRectGetMaxX(titleLab1.frame)+5, CGRectGetMaxY(titleLab.frame), 100, 20);
        titleLab2.font = [UIFont systemFontOfSize:12];
        titleLab2.text = [NSString stringWithFormat:@"共%@个服务项",iiModel.service_num];;
        titleLab2.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:titleLab2];
        
        labelArr = [NSMutableArray array];
        for (int i = 0; i < iiModel.cate_list.count; i++) {
            NSDictionary *dic = iiModel.cate_list[i];
            NSString *labStr = [dic objectForKey:@"category_cn"];
            [labelArr addObject:labStr];
        }
        VOTagList *tagList = [[VOTagList alloc] initWithTags:labelArr];
        tagList.frame = CGRectMake(CGRectGetMaxX(logoImg.frame)+5, CGRectGetMaxY(titleLab2.frame), Main_width-20-5-60, 20);
        tagList.multiLine = YES;
        tagList.multiSelect = YES;
        tagList.allowNoSelection = YES;
        tagList.vertSpacing = 20;
        tagList.horiSpacing = 10;
        tagList.selectedTextColor = [UIColor blackColor];
        tagList.tagBackgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        tagList.selectedTagBackgroundColor = [UIColor redColor];
        tagList.tagCornerRadius = 3;
        tagList.tagEdge = UIEdgeInsetsMake(2, 2, 2, 2);
        [tagList addTarget:self action:@selector(selectedTagsChanged:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:tagList];
        
        titleImgArr = [NSMutableArray array];
        for (int i = 0; i < iiModel.service_list.count; i++) {
            NSDictionary *dic = iiModel.service_list[i];
            NSString *titleImgStr = [dic objectForKey:@"title_img"];
            [titleImgArr addObject:titleImgStr];
        }
        titleArr = [NSMutableArray array];
        for (int i = 0;  i < iiModel.service_list.count; i++) {
            NSDictionary *dic = iiModel.service_list[i];
            NSString *titleStr = [dic objectForKey:@"title"];
            [titleArr addObject:titleStr];
        }
        imgIDArr = [NSMutableArray array];
        for (int i = 0;  i < iiModel.service_list.count; i++) {
            NSDictionary *dic = iiModel.service_list[i];
            NSString *titleStr = [dic objectForKey:@"id"];
            [imgIDArr addObject:titleStr];
        }
        UIScrollView *backscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tagList.frame)+10, Main_width, 180)];
        backscrollview.contentSize = CGSizeMake((Main_width-40)*titleImgArr.count+16*(titleImgArr.count-1), (Main_width-40)/2.5+30);
        backscrollview.showsVerticalScrollIndicator = NO;
        backscrollview.showsHorizontalScrollIndicator = NO;
        [cell addSubview:backscrollview];
        for (int i=0; i<titleImgArr.count; i++) {
            
//            UIImageView *imgView = [[UIImageView alloc]init];
//            imgView.frame = CGRectMake(10+(i*(Main_width-30)),0 , Main_width-40, (Main_width-40)/2.5);
//            [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:titleImgArr[i]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
//            imgView.layer.cornerRadius = 5;
//            [backscrollview addSubview:imgView];
            
            UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            imgBtn.frame = CGRectMake(10+(i*(Main_width-30)),0 , Main_width-40, (Main_width-40)/2.5);
            NSString *imgStr = [API_img stringByAppendingString:titleImgArr[i]];
            [imgBtn xr_setButtonImageWithUrl:imgStr];
            imgBtn.layer.cornerRadius = 5;
            imgBtn.clipsToBounds = YES;
            imgBtn.tag = [imgIDArr[i] integerValue]+100;
            [imgBtn addTarget:self action:@selector(iconImageViewAction:) forControlEvents:UIControlEventTouchUpInside];
            [backscrollview addSubview:imgBtn];
            
            UILabel *titleLab = [[UILabel alloc] init];
            titleLab.frame = CGRectMake(10+(i*(Main_width-30)), CGRectGetMaxY(imgBtn.frame), Main_width-40, 30);
            titleLab.text = titleArr[i];
            titleLab.textAlignment = NSTextAlignmentLeft;
            titleLab.font = [UIFont systemFontOfSize:18];
            [backscrollview addSubview:titleLab];
            
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)setupNavItems
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 44)];
    [self.navigationItem setTitleView:view];
    
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(Main_width-80, 5, 30, 30)];
    [but setImage:[UIImage imageNamed:@"ic_share"] forState:UIControlStateNormal];
    but.backgroundColor = [UIColor redColor];
    [but addTarget:self action:@selector(shareview) forControlEvents:UIControlEventTouchUpInside];
    but.backgroundColor = [UIColor clearColor];
    [view addSubview:but];
}
#pragma mark - 立即预约
- (void)loadFunctionView {
    CGFloat contentY = Main_Height-50;
    UIView *functionView = [[UIView alloc]initWithFrame:CGRectMake(0, contentY, Main_width, 50)];
    functionView.backgroundColor = [UIColor colorWithRed:243/255.0 green:247/255.0 blue:248/255.0 alpha:1];
    
    UIButton *callBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 60, 30)];
    callBtn.backgroundColor = [UIColor colorWithRed:252/255.0 green:88/255.0 blue:48/255.0 alpha:1];
//    [callBtn setTitle:@"立即预约" forState:UIControlStateNormal];
    [callBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [likeButton setTitleColor:Blue_Selected forState:UIControlStateSelected];
    callBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    //    [likeButton setImage:[UIImage imageNamed:@"icon_praise"] forState:UIControlStateNormal];
    //    [likeButton setImage:[UIImage imageNamed:@"icon_praise_tabbar"] forState:UIControlStateSelected];
    [callBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
    callBtn.layer.cornerRadius = 3.0;
    [functionView addSubview:callBtn];
    
    UIButton *shopBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(callBtn.frame)+10, 10, 60, 30)];
    shopBtn.backgroundColor = [UIColor colorWithRed:252/255.0 green:88/255.0 blue:48/255.0 alpha:1];
//    [shopBtn setTitle:@"立即预约" forState:UIControlStateNormal];
    [shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [likeButton setTitleColor:Blue_Selected forState:UIControlStateSelected];
    shopBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    //    [likeButton setImage:[UIImage imageNamed:@"icon_praise"] forState:UIControlStateNormal];
    //    [likeButton setImage:[UIImage imageNamed:@"icon_praise_tabbar"] forState:UIControlStateSelected];
    [shopBtn addTarget:self action:@selector(shopAction:) forControlEvents:UIControlEventTouchUpInside];
    shopBtn.layer.cornerRadius = 3.0;
    [functionView addSubview:shopBtn];
    
    UIButton *yuYueBtn = [[UIButton alloc]initWithFrame:CGRectMake(Main_width-10-100, 10, 100, 30)];
    yuYueBtn.backgroundColor = [UIColor colorWithRed:252/255.0 green:88/255.0 blue:48/255.0 alpha:1];
    [yuYueBtn setTitle:@"立即预约" forState:UIControlStateNormal];
    [yuYueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [likeButton setTitleColor:Blue_Selected forState:UIControlStateSelected];
    yuYueBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    //    [likeButton setImage:[UIImage imageNamed:@"icon_praise"] forState:UIControlStateNormal];
    //    [likeButton setImage:[UIImage imageNamed:@"icon_praise_tabbar"] forState:UIControlStateSelected];
    [yuYueBtn addTarget:self action:@selector(yuYueAction:) forControlEvents:UIControlEventTouchUpInside];
    yuYueBtn.layer.cornerRadius = 3.0;
    [functionView addSubview:yuYueBtn];
    [self.view addSubview:functionView];
    
}
-(void)callAction:(UIButton *)sender{
    
    insinfoModel *iiModel = insinfoArr[0];
    NSString *telStr = iiModel.telphone;
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telStr];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
-(void)shopAction:(UIButton *)sender{
    
    businessDetailViewController *bdVC = [[businessDetailViewController alloc]init];
    [self.navigationController pushViewController:bdVC animated:YES];
    //    NSString *telStr = [NSString stringWithFormat:@"%ld",sender.tag];
    //    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telStr];
    //    UIWebView *callWebview = [[UIWebView alloc] init];
    //    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    //    [self.view addSubview:callWebview];
}
-(void)yuYueAction:(UIButton *)sender{
    fwDetailModel *model = dataSourceArr[0];
    tagListModel *tModel = tagListArr[0];
    queRenViewController *qrVC = [[queRenViewController alloc]init];
    qrVC.serviceStr = model.title;
    qrVC.priceStr = tModel.price;
    qrVC.serviceID = tModel.s_id;
    qrVC.serviceTagID = tModel.id;
    [self.navigationController pushViewController:qrVC animated:YES];
}
-(void)plBtnAction{
    scoreInfoModel *model = scoreInfoArr[0];
    pingLunViewController *plVC = [[pingLunViewController alloc]init];
    plVC.plID = model.s_id;
    [self.navigationController pushViewController:plVC animated:YES];
}
-(void)iconImageViewAction:(UIButton *)sender{
    
    NSInteger index = sender.tag-100;
    serviceDetailViewController *sdVC = [[serviceDetailViewController alloc]init];
    sdVC.serviceID = [NSString stringWithFormat:@"%ld",index];
    [self.navigationController pushViewController:sdVC animated:YES];
}
- (void)shareview{
    // ------全屏遮罩
    self.BGView                 = [[UIView alloc] init];
    self.BGView.frame           = [[UIScreen mainScreen] bounds];
    self.BGView.tag             = 100;
    self.BGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.BGView.opaque = NO;
    
    //--UIWindow的优先级最高，Window包含了所有视图，在这之上添加视图，可以保证添加在最上面
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [appWindow addSubview:self.BGView];
    
    // ------给全屏遮罩添加的点击事件
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitClick)];
    gesture.numberOfTapsRequired = 1;
    gesture.cancelsTouchesInView = NO;
    [self.BGView addGestureRecognizer:gesture];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.BGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        
    }];
    
    // ------底部弹出的View
    self.deliverView                 = [[UIView alloc] init];
    self.deliverView.frame           = CGRectMake(0, Main_Height-120, Main_width, 120);
    self.deliverView.backgroundColor = [UIColor whiteColor];
    [appWindow addSubview:self.deliverView];
    
    NSArray *arr = @[@"shortVideo_share_weixin",@"shortVideo_share_friend"];
    NSArray *labelarr = @[@"微信",@"朋友圈"];
    for (int i=0; i<2; i++) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(22.5+90*i, 15, 45, 45)];
        imageview.image = [UIImage imageNamed:[arr objectAtIndex:i]];
        [self.deliverView addSubview:imageview];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15+90*i, 75, 60, 10)];
        label.font = font15;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [labelarr objectAtIndex:i];
        [self.deliverView addSubview:label];
        
        UIButton *sharebut = [UIButton buttonWithType:UIButtonTypeCustom];
        sharebut.frame = CGRectMake(15+90*i, 15, 90, 90);
        //[sharebut setImage:[UIImage imageNamed:[arr objectAtIndex:i]] forState:UIControlStateNormal];
        sharebut.tag = i;
        [sharebut addTarget:self action:@selector(sharegoods:) forControlEvents:UIControlEventTouchUpInside];
        [self.deliverView addSubview:sharebut];
    }
    
    // ------View出现动画
    self.deliverView.transform = CGAffineTransformMakeTranslation(0.01, Main_width);
    [UIView animateWithDuration:0.3 animations:^{
        
        self.deliverView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
        
    }];
}
- (void)sharegoods:(UIButton *)sender
{
    WXMediaMessage *mediamessage = [WXMediaMessage message];
    mediamessage.title = [_DataDic objectForKey:@"title"];
    mediamessage.description = @"我在社区慧生活发现了一个优质服务，快过来看看吧";
    NSString *urlString = [API_img stringByAppendingString:[_DataDic objectForKey:@"title_img"]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:urlString]];
    UIImage *image = [UIImage imageWithData:data];
    
    [mediamessage setThumbImage:image];
    
    WXWebpageObject *webobj = [WXWebpageObject object];
    webobj.webpageUrl = [NSString stringWithFormat:@"http://test.hui-shenghuo.cn/home/shop/goods_details/id/%@?linkedme=https://lkme.cc/LQD/ONaD0BYuK&from=singlemessage",[_DataDic objectForKey:@"id"]];
    mediamessage.mediaObject =  webobj;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = mediamessage;
    if (sender.tag==0) {
        req.scene = WXSceneSession;
        NSLog(@"0");
    }else{
        NSLog(@"1");
        req.scene = WXSceneTimeline;//朋友圈
    }
    
    [WXApi sendReq:req];
    
}


@end
