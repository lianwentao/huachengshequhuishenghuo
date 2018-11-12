//
//  DWQShopModel.m
//  DWQCartViewController
//
//  Created by 杜文全 on 16/2/13.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved.
//  https://github.com/DevelopmentEngineer-DWQ/DWQShoppingCart
//  http://www.jianshu.com/u/725459648801
//

#import "DWQShopModel.h"
#import "DWQGoodsModel.h"
#import "UIImageView+WebCache.h"



@implementation DWQShopModel

- (void)configGoodsArrayWithArray:(NSArray*)array; {
    if (array.count > 0) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in array) {
            DWQGoodsModel *model = [[DWQGoodsModel alloc]init];
            model.count = [[dic objectForKey:@"number"] integerValue];
            model.number = [dic objectForKey:@"number"];
            model.goodsID = [dic objectForKey:@"p_id"];
            model.goodsName = [dic objectForKey:@"title"];
            model.price = [dic objectForKey:@"price"];
            model.tagid = [dic objectForKey:@"tagid"];
            model.titleimg = [dic objectForKey:@"title_img"];
            int limit = [[dic objectForKey:@"limit"] intValue];
            if (limit==0) {
                model.limit = 9999;
            }else{
                model.limit = limit - [[dic objectForKey:@"order_num"] intValue];
            }
            
            NSString *strurl = [API_img stringByAppendingString:[dic objectForKey:@"title_img"]];
            UIImageView *imageview = [[UIImageView alloc] init];
            [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
            model.image=imageview.image;
            
            
            [dataArray addObject:model];
        }
        
        _goodsArray = [dataArray mutableCopy];
    }
}
@end
