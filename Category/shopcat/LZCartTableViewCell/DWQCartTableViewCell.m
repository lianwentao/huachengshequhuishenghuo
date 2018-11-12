//
//  DWQCartTableViewCell.m
//  DWQCartViewController
//
//  Created by 杜文全 on 16/2/13.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved.
//  https://github.com/DevelopmentEngineer-DWQ/DWQShoppingCart
//  http://www.jianshu.com/u/725459648801

#import "DWQCartTableViewCell.h"
#import "DWQConfigFile.h"
//#import "DWQCartModel.h"
#import "DWQGoodsModel.h"
#import "MBProgressHUD+TVAssistant.h"


@interface DWQCartTableViewCell ()
{
    DWQNumberChangedBlock numberAddBlock;
    DWQNumberChangedBlock numberCutBlock;
    DWQCellSelectedBlock cellSelectedBlock;
}
//选中按钮
@property (nonatomic,retain) UIButton *selectBtn;
//显示照片
@property (nonatomic,retain) UIImageView *dwqImageView;
//商品名
@property (nonatomic,retain) UILabel *nameLabel;
//尺寸
@property (nonatomic,retain) UILabel *sizeLabel;
//时间
@property (nonatomic,retain) UILabel *dateLabel;
//价格
@property (nonatomic,retain) UILabel *priceLabel;
//数量
@property (nonatomic,retain)UILabel *numberLabel;

@end

@implementation DWQCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = DWQColorFromRGB(245, 246, 248);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupMainView];
    }
    return self;
}
#pragma mark - public method
- (void)reloadDataWithModel:(DWQGoodsModel*)model {
    
    self.dwqImageView.image = model.image;
    self.nameLabel.text = model.goodsName;
    self.priceLabel.text = model.price;
    self.dateLabel.text = [NSString stringWithFormat:@"%d",model.limit];
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)model.count];
//    self.sizeLabel.text = model.sizeStr;
    self.selectBtn.selected = model.select;
    
    NSLog(@"%@-%@-%@-%@",model.goodsID,model.price,model.number,model.goodsName);
}

- (void)numberAddWithBlock:(DWQNumberChangedBlock)block {
    numberAddBlock = block;
}

- (void)numberCutWithBlock:(DWQNumberChangedBlock)block {
    numberCutBlock = block;
}

- (void)cellSelectedWithBlock:(DWQCellSelectedBlock)block {
    cellSelectedBlock = block;
}
#pragma mark - 重写setter方法
- (void)setDwqNumber:(NSInteger)dwqNumber {
    _dwqNumber = dwqNumber;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)dwqNumber];
}

- (void)setDwqSelected:(BOOL)dwqSelected {
    _dwqSelected = dwqSelected;
    self.selectBtn.selected = dwqSelected;
}
#pragma mark - 按钮点击方法
- (void)selectBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    if (cellSelectedBlock) {
        cellSelectedBlock(button.selected);
    }
}

- (void)addBtnClick:(UIButton*)button {
    
    
    NSInteger count = [self.numberLabel.text integerValue];
    int limit = [self.dateLabel.text intValue];
    if (count==limit) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"gouwuchexiangou" object:nil userInfo:nil];
    }else{
        count++;
    }
    
    if (numberAddBlock) {
        numberAddBlock(count);
    }
}

- (void)cutBtnClick:(UIButton*)button {
    NSInteger count = [self.numberLabel.text integerValue];
    count--;
    if(count <= 0){
        return ;
    }
    if (numberCutBlock) {
        numberCutBlock(count);
    }
}
#pragma mark - 布局主视图
-(void)setupMainView {
    //白色背景
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(10, 10, DWQSCREEN_WIDTH - 20, dwq_CartRowHeight - 10);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = DWQColorFromHex(0xEEEEEE).CGColor;
    bgView.layer.borderWidth = 1;
    [self addSubview:bgView];
    
    //选中按钮
    UIButton* selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.center = CGPointMake(20, bgView.height/2.0);
    selectBtn.bounds = CGRectMake(0, 0, 30, 30);
    [selectBtn setImage:[UIImage imageNamed:dwq_Bottom_UnSelectButtonString] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:dwq_Bottom_SelectButtonString] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:selectBtn];
    self.selectBtn = selectBtn;
    
    //照片背景
    UIView *imageBgView = [[UIView alloc]init];
    imageBgView.frame = CGRectMake(selectBtn.right + 5, 5, bgView.height - 10, bgView.height - 10);
    imageBgView.backgroundColor = DWQColorFromHex(0xF3F3F3);
    [bgView addSubview:imageBgView];
    
    //显示照片
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"default_pic_1"];
    imageView.frame = CGRectMake(imageBgView.left + 5, imageBgView.top + 5, imageBgView.width - 10, imageBgView.height - 10);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:imageView];
    self.dwqImageView = imageView;
    
    CGFloat width = (bgView.width - imageBgView.right - 30)/2.0;
    //价格
    UILabel* priceLabel = [[UILabel alloc]init];
    priceLabel.frame = CGRectMake(bgView.width - width - 10, 10, width, 30);
    priceLabel.font = [UIFont boldSystemFontOfSize:16];
    priceLabel.textColor = BASECOLOR_RED;
    priceLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    //商品名
    UILabel* nameLabel = [[UILabel alloc]init];
    nameLabel.frame = CGRectMake(imageBgView.right + 10, 10, width, 75);
    nameLabel.numberOfLines = 3;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //尺寸
    UILabel* sizeLabel = [[UILabel alloc]init];
    sizeLabel.frame = CGRectMake(nameLabel.left, nameLabel.bottom + 5, width, 20);
    sizeLabel.textColor = DWQColorFromRGB(132, 132, 132);
    sizeLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:sizeLabel];
    self.sizeLabel = sizeLabel;
    
    //时间
    UILabel* dateLabel = [[UILabel alloc]init];
    dateLabel.frame = CGRectMake(nameLabel.left, sizeLabel.bottom , width, 20);
    dateLabel.font = [UIFont systemFontOfSize:10];
    dateLabel.textColor = DWQColorFromRGB(132, 132, 132);
    //[bgView addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
    //数量加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(bgView.width - 35, bgView.height - 35, 25, 25);
    [addBtn setImage:[UIImage imageNamed:@"shop_icon_jia_dianjiqian"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"shop_icon_jia_dianjihou"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addBtn];
    
    //数量显示
    UILabel* numberLabel = [[UILabel alloc]init];
    numberLabel.frame = CGRectMake(addBtn.left - 30, addBtn.top, 30, 25);
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.text = @"1";
    numberLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:numberLabel];
    self.numberLabel = numberLabel;
    
    //数量减按钮
    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cutBtn.frame = CGRectMake(numberLabel.left - 25, addBtn.top, 25, 25);
    [cutBtn setImage:[UIImage imageNamed:@"shop_icon_jian_dianjiqian"] forState:UIControlStateNormal];
    [cutBtn setImage:[UIImage imageNamed:@"shop_icon_jian_dianjihou"] forState:UIControlStateHighlighted];
    [cutBtn addTarget:self action:@selector(cutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cutBtn];
}

@end
