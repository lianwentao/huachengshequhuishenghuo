//
//  huoDongDetailViewController.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/17.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "huoDongDetailViewController.h"
#import "WKWebViewJavascriptBridge.h"
@interface huoDongDetailViewController ()<WKUIDelegate,WKNavigationDelegate>
{
    WKWebView *wkwebview;
    
}
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation huoDongDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"租房小贴士";
    wkwebview = [[WKWebView alloc] init];
    wkwebview.frame = CGRectMake(0, RECTSTATUS.size.height+44, Main_width, Main_Height-RECTSTATUS.size.height-44);
    wkwebview.UIDelegate = self;
    wkwebview.navigationDelegate = self;
    [self.view addSubview:wkwebview];
    
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [wkwebview loadRequest:request];
    
    
    //进度条初始化
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, [[UIScreen mainScreen] bounds].size.width, 2)];
    self.progressView.backgroundColor = QIColor;
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    
    [wkwebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    // Do any additional setup after loading the view.
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = wkwebview.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
    
    NSString *path= [webView.URL absoluteString];
    NSString * newPath = [path lowercaseString];
    NSLog(@"%@,%@",path,newPath);
    if ([newPath hasPrefix:@"sms:"] || [newPath hasPrefix:@"tel:"]) {
        
        UIApplication * app = [UIApplication sharedApplication];
        if ([app canOpenURL:[NSURL URLWithString:newPath]]) {
            [app openURL:[NSURL URLWithString:newPath]];
        }
        return;
    }
}
// 处理拨打电话以及Url跳转等等
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //    NSURL *URL = navigationAction.request.URL;
    //    NSString *scheme = [URL scheme];
    //    if ([scheme isEqualToString:@"tel"]) {
    //        NSString *resourceSpecifier = [URL resourceSpecifier];
    //        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
    //        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
    //        dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    //        });
    //    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    //self.progressView.hidden = YES;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    //self.progressView.hidden = YES;
}



@end
