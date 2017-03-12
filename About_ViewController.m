

//
//  About_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/26.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  官网公众号界面

#import "About_ViewController.h"
#import "TTTAttributeLabelView.h"
#import "NSString+RichText.h"
#import "TTTAttributedLabel.h"

#import "OfficialWebsite_ViewController.h"  //官网

@interface About_ViewController () <TTTAttributeLabelViewDelegate>
@property (nonatomic, strong) TTTAttributeLabelView  *attributeLabelView;
@end

@implementation About_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"官网公众号";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.navigationItem.titleView = title;
    
    
    self.attributeLabelView=[[TTTAttributeLabelView alloc]initWithFrame:CGRectMake(WIDTH_lk/2-150, 120, 300, 354)];
    
    // 创建富文本
    NSString *string =@"公司官网：http://www.aikalife.com \n微信公众号：aikalife";
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing              = 4.f;
    style.paragraphSpacing         = style.lineSpacing * 0;
    style.alignment                = NSTextAlignmentCenter;
    NSAttributedString *attributedString  = \
    [string createAttributedStringAndConfig:@[[ConfigAttributedString foregroundColor:[UIColor whiteColor] range:string.range],
                                              [ConfigAttributedString paragraphStyle:style range:string.range],
                                              [ConfigAttributedString font:[UIFont fontWithName:@"AppleSDGothicNeo-UltraLight" size:18.f] range:string.range]]];
    
    // 初始化对象
    _attributeLabelView.attributedString   = attributedString;
    self.attributeLabelView.delegate           = self;
    self.attributeLabelView.linkColor          = [UIColor cyanColor];
    
    // 添加超链接
    NSRange range1 = [string rangeOfString:@"http://www.aikalife.com"];
    [self.attributeLabelView addLinkStringRange:range1 flag:@"link1"];
    
    // 添加超链接
    NSRange range2 = [string rangeOfString:@"：aikalife"];
    [self.attributeLabelView addLinkStringRange:range2 flag:@"link2"];

    
    // 进行渲染
    [self.attributeLabelView render];
    [self.attributeLabelView resetSize];
    [self.view addSubview:self.attributeLabelView];
}

- (void)TTTAttributeLabelView:(TTTAttributeLabelView *)attributeLabelView linkFlag:(NSString *)flag {
    if ([flag isEqualToString:@"link1"]) {
        //跳转至官网
        OfficialWebsite_ViewController *vc=[[OfficialWebsite_ViewController alloc]init];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:NO];
        self.hidesBottomBarWhenPushed=NO;

    }else if ([flag isEqualToString:@"link2"]){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"aikalife";
        [MBProgressHUD showSuccess:@"已复制到剪切板"];
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
