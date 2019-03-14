//
//  TooBox.m
//  TextOne
//
//  Created by Mac on 16/6/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "TooBox.h"

@implementation TooBox


+ (void)call:(NSString *)phoneNum {
    if (phoneNum && ![phoneNum isEqualToString:@""]) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNum]]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNum]] options:@{} completionHandler:nil];
        }else {
//            [ITTMessageView showMessage:@"电话号码错误" disappearAfterTime:1];
        }
    }else {
//        [ITTMessageView showMessage:@"电话号码为空!" disappearAfterTime:1];
    }
}

//+ (MAMapView *)shareMapView {
//    static MAMapView *mapView = nil;
//    if (!mapView) {
//        mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
//    }
//    return mapView;
//}
//
//+ (AMapSearchAPI *)shareSearchApi {
//    static AMapSearchAPI *searchApi = nil;
//    if (!searchApi) {
//        searchApi = [[AMapSearchAPI alloc]init];
//    }
//    return searchApi;
//}

+ (NSString *)jointStringWithArr:(NSArray *)arr {
    NSString *string = @"";
    for (int i = 0; i<arr.count; i++) {
        if (![arr[i] isEqualToString:@""]) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@,",arr[i]]];
        }
    }
    return string;
}

+ (NSArray *)arrWithSting:(NSString *)string {
    if (!string || ![string isKindOfClass:[NSString class]]) {
        return @[];
    }
    NSArray *arr = [string componentsSeparatedByString:@","];
    NSMutableArray *resultArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < arr.count; i++) {
        if ([arr[i] isKindOfClass:[NSString class]] && ![arr[i] isEqualToString:@""]) {
            [resultArr addObject:arr[i]];
        }
    }
    return [resultArr copy];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (CGSize)labelAutoCalculateRectWithText:(NSString *)text FontSize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth {
    if (![text isKindOfClass:[NSString class]]) {
        return CGSizeMake(maxWidth, 0);
    }
    if (!text || [text isEqualToString:@""]) {
        return CGSizeMake(maxWidth, 0);
    }
    
    NSMutableParagraphStyle *paragraghStyle = [[NSMutableParagraphStyle alloc] init];
    //    [paragraghStyle setLineSpacing:2];//调整行间距
    //    paragraghStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraghStyle.copy};
    
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attr context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    
    return labelSize;
}
+ (void)alertShowWithViewController:(UIViewController *)vc Title:(NSString *)title message:(NSString *)message handler:(alertControlHandler )handler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler(NO);
        }
    }];
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler(YES);
        }
    }];
    
    [alertController addAction:action];
    [alertController addAction:actionSure];
    
    [vc presentViewController:alertController animated:YES completion:^{
        
    }];
    
}
+ (void)actionSheetShowWithViewController:(UIViewController *)vc Titles:(NSArray *)titlesArr handler:(actionSheetControlHandler)handler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i<titlesArr.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:titlesArr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler(i);
            }
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:action];
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:action];
    [vc presentViewController:alertController animated:YES completion:^{
        
    }];
    
}



+ (UIViewController *)currentViewController {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *view = [[window subviews] firstObject];
    
    id nextResproser = [view nextResponder];
    
    if ([nextResproser isKindOfClass:[UIViewController class]]) {
        if ([nextResproser isKindOfClass:[UINavigationController class]]) {
            return [(UINavigationController *)nextResproser topViewController];
        }else if ([nextResproser isKindOfClass:[UITabBarController class]]) {
            NSArray *arr = [(UITabBarController *)nextResproser viewControllers];
            NSInteger index = [(UITabBarController *)nextResproser selectedIndex];
            id vc = [arr objectAtIndex:index];
            if ([vc isKindOfClass:[UINavigationController class]]) {
                return [(UINavigationController *)vc topViewController];
            }else {
                return vc;
            }
        }else {
            return nextResproser;
        }
        return nextResproser;
    }else {
        return window.rootViewController;
    }
    
}

+ (void)alertShowWithTitle:(NSString *)title message:(NSString *)message handler:(alertControlHandler)handler{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler(NO);
        }
    }];
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler(YES);
        }
    }];
    
    [alertController addAction:action];
    [alertController addAction:actionSure];
    
    [[TooBox currentViewController] presentViewController:alertController animated:YES completion:^{
        
    }];

}

+ (void)actionSheetShowWithTitles:(NSArray *)titlesArr handler:(actionSheetControlHandler)handler{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i<titlesArr.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:titlesArr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler(i);
            }
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:action];
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:action];
    [[TooBox currentViewController] presentViewController:alertController animated:YES completion:^{

    }];

}

+ (NSString *)transformToPinyin:(NSString *)string {
    NSMutableString *mutableStr = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)mutableStr, NULL, kCFStringTransformToLatin, false);
    mutableStr = [[mutableStr stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]] mutableCopy];
    [mutableStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    mutableStr = [[mutableStr stringByReplacingOccurrencesOfString:@" " withString:@""] mutableCopy];
    return mutableStr;
}
+ (NSString *)apiPathStringWithApi:(NSString *)api {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    return [NSString stringWithFormat:@"%@%@",API,api];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}


+ (id)firstResponder {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow] ;
    return [window performSelector:@selector(firstResponder)];
}

+ (BOOL)resignFirstResponder {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow] ;
    id firstResponser = [window performSelector:@selector(firstResponder)];
    return [firstResponser resignFirstResponder];
}



+ (CGSize)lableSizeWithText:(NSString *)text font:(CGFloat)font size:(CGSize)size widthConstant:(BOOL)widthConstant{    
    NSInteger textCount = text.length;
    
    CGFloat zeroWidth = textCount * font;
    
    
    CGFloat width = size.width,height = size.height;
    if (widthConstant) {
        //宽度固定
        height = (zeroWidth/width + 1) * (font + 1)  ;
    }else {
        //高度固定
        width = zeroWidth/height * font;
    }
    return CGSizeMake(width, height);
}

//+ (NSInteger)integerValueWithFloat:(CGFloat)floatValue {
//floatValue

//}

+(NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (UIView *)lineViewWithFrame:(CGRect)frame backGroundColor:(UIColor *)color {
    UIView *lineView = [[UIView alloc]initWithFrame:frame];
    lineView.backgroundColor = color;
    return lineView;
}

+ (UIView *)starViewWithFrame:(CGRect)frame Count:(NSInteger)starCount {
    UIView *starView = [[UIView alloc]initWithFrame:frame];
    starView.backgroundColor = [UIColor whiteColor];
    CGFloat width = frame.size.height;
    for (int i = 0; i < 5; i++) {
        UIImageView *starImageView = [[UIImageView alloc]initWithFrame:CGRectMake((width+3)*i, 0, width, width)];
        if (i <= starCount-1) {
            [starImageView setImage:[UIImage imageNamed:@"comment_rating_selected"]];
        }else {
            [starImageView setImage:[UIImage imageNamed:@"comment_rating_unselected"]];
        }
        [starView addSubview:starImageView];
    }
    return starView;
}


//+ (BOOL)isApperWithViewController:(UIViewController *)vc {
//    BOOL appear = YES;
//    UIViewController *tempVC = [TooBox currentViewController];
//    if (vc == tempVC) {
//        appear = YES;
//    }else {
//        appear = NO;
//    }
//    return appear;
//}
+ (BOOL)isApperWithViewController:(UIViewController *)vc {
    BOOL appear = YES;
    
    if (!vc.isViewLoaded) {
        appear = NO;
    }
    if (!vc.view.window) {
        appear = NO;
    }
    for (UIView *subView in vc.view.subviews) {
        if (!subView.window) {
            appear = NO;
        }
    }
    UIView *subView;
    while (subView!=nil) {
        
    }
    return appear;
}


+ (NSArray *)arrWithStingAboutEmpity:(NSString *)string {
    if (![string isKindOfClass:[NSString class]] || [string isEqualToString:@""]) {
        return @[@""];
    }
    NSArray *arr = [string componentsSeparatedByString:@","];
    NSMutableArray *resultArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < arr.count; i++) {
        if ([arr[i] isKindOfClass:[NSString class]]) {
            [resultArr addObject:arr[i]];
        }
    }
    return [resultArr copy];
    
}
@end
