//
//  Webpdf_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/1/14.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "Webpdf_ViewController.h"

@interface Webpdf_ViewController ()<UIWebViewDelegate>
{
    UIWebView *webView;
}

@end
@implementation Webpdf_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"说明书";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.navigationItem.titleView = title;
    
    webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, HEIGHT_lk-64)];
    webView.delegate=self;
    if([self.pdfName isEqualToString:@"呵护"]){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"石墨烯智能护腰说明书" ofType:@"pdf"];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        
    }
    else if([self.pdfName isEqualToString:@"BlackT"]){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"BlackT说明书" ofType:@"pdf"];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    }

        [self.view addSubview:webView];
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
