//
//  yuefunextViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/4/2.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "yuefunextViewController.h"

@interface yuefunextViewController ()

@end

@implementation yuefunextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackColor;
    [self createui];
    // Do any additional setup after loading the view.
}
- (void)createui
{
//    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, Main_width, Main_Height-(RECTSTATUS.size.height+44))];
//    [self.view addSubview:scrollview];
//
//    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[_content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    NSLog(@"%@--%@",attributedString,_content);
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_width, 0)];
//    label.numberOfLines = 0;
//    label.attributedText = attributedString;
//    //label.text = _content;
//    CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
//    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, size.width,  size.height);
//    [label setFont:font15];
//    [scrollview addSubview:label];
//

    
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height)];
    [webview loadHTMLString:_content baseURL:nil];
    [self.view addSubview:webview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
