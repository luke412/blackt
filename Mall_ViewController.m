//
//  Mall_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/2/4.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  商城界面

#import "Mall_ViewController.h"

@interface Mall_ViewController ()<UIWebViewDelegate>
{
    UIWebView *webView;
}


@end

@implementation Mall_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self panDuanWangLuo];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"商 城";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.navigationItem.titleView = title;
    
    
    webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, HEIGHT_lk-64)];
    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    webView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打
    webView.delegate=self;
    
    NSURL* url = [NSURL URLWithString:@"http://www.aikalife.com/"];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest

    
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"BlackT说明书" ofType:@"pdf"];
//        NSURL *url = [NSURL fileURLWithPath:path];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    
    
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
                [MBProgressHUD showError:@"网络未连接"];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
                label.center = webView.center;
                label.textColor = [UIColor grayColor];
                label.textAlignment =NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:17];
                label.text =@"没有网络连接";
                [webView addSubview:label];
            });
            
            
        }else if(status == AFNetworkReachabilityStatusReachableViaWWAN){//3G|4G
            
        }else if(status == AFNetworkReachabilityStatusReachableViaWiFi){//wifi
            
        }
        
        
        
    }];
    
    
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
