//
//  GuangGaoURL_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/20.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "GuangGaoURL_ViewController.h"

@interface GuangGaoURL_ViewController ()<UIWebViewDelegate>
{
    UIWebView *webView;
}
@end

@implementation GuangGaoURL_ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    self.tabBarController.tabBar.hidden = YES;

    LKShow(@"正在加载...");
    NSURL* url = [NSURL URLWithString:self.url];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self panDuanWangLuo];
    [self setTittleWithText:@"新品上市"];
    
    
    webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, HEIGHT_lk-64)];
    webView.scalesPageToFit     = YES;
    webView.detectsPhoneNumbers = YES;
    webView.delegate = self;
    [self.view addSubview:webView];
}
-(void)panDuanWangLuo{
        //获取通知中心
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
        [manger startMonitoring];
        //2.监听改变
        [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown) {//未知
            
        }else if(status == AFNetworkReachabilityStatusNotReachable){//没有网络
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:LK(@"网络未连接")];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
                label.center = webView.center;
                label.textColor = [UIColor grayColor];
                label.textAlignment =NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:17];
                label.text =LK(@"没有网络连接");
                [webView addSubview:label];
            });
        }else if(status == AFNetworkReachabilityStatusReachableViaWWAN){//3G|4G
            
        }else if(status == AFNetworkReachabilityStatusReachableViaWiFi){//wifi
            
        }
        
    }];
    
    
}
#pragma mark web相关
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    dispatch_async(dispatch_get_main_queue(), ^{
        LKRemove;
        [MBProgressHUD showSuccess:@"加载成功"];
    });
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    LKLog(@"%@",error.localizedDescription);
    LKLog(@"%ld",[error code]);
    if([error code] == NSURLErrorCancelled)     {
        dispatch_async(dispatch_get_main_queue(), ^{
             LKRemove;
            [MBProgressHUD showError:@"加载失败"];
        });
        return;
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
             LKRemove;
        });
        //尝试浏览器打开
        NSString *url = self.url;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
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
