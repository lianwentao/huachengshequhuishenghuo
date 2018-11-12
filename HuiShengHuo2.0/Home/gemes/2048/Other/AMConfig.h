//
//  AMConfig.h
//  ZSAgencyManage
//
//  Created by CSX on 2016/12/20.
//  Copyright © 2016年 宗盛商业. All rights reserved.
//

#ifndef AMConfig_h
#define AMConfig_h


#define W_WIDTH [UIScreen mainScreen].bounds.size.width
#define H_HIGH  [UIScreen mainScreen].bounds.size.height


#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)] //颜色RGBA

#define SCALE [UIScreen mainScreen].bounds.size.width/375

#define FONT_OF_SIZE(size) [UIFont systemFontOfSize:size*SCALE]


#endif /* AMConfig_h */
