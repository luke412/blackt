//
//  Help_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/2/4.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  帮助界面

#import "Help_ViewController.h"
#import "Webpdf_ViewController.h"
@interface Help_ViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *blackTimage;
@property (weak, nonatomic) IBOutlet UIImageView *herHuimage;

@end

@implementation Help_ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"帮 助";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.navigationItem.titleView = title;
 
    //加边框
    [_blackTimage.layer setBorderColor:[UIColor whiteColor].CGColor];
        [_blackTimage.layer setBorderWidth:1];
        [_blackTimage.layer setMasksToBounds:YES];
    
    [_herHuimage.layer setBorderColor:[UIColor whiteColor].CGColor];
        [_herHuimage.layer setBorderWidth:1];
        [_herHuimage.layer setMasksToBounds:YES];

    //手势
    _blackTimage.userInteractionEnabled=YES;
    _herHuimage.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickblackT:)];
    tap.delegate=self;
    [_blackTimage addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickherHu:)];
    tap.delegate=self;
    [_herHuimage addGestureRecognizer:tap2];

    
    
}

-(void)clickblackT:(UITapGestureRecognizer *)tap{
    Webpdf_ViewController *web=[[Webpdf_ViewController alloc]init];
    web.pdfName=@"BlackT";
    [self.navigationController pushViewController:web animated:NO];
}

-(void)clickherHu:(UITapGestureRecognizer *)tap{
    Webpdf_ViewController *web=[[Webpdf_ViewController alloc]init];
    web.pdfName=@"呵护";
    [self.navigationController pushViewController:web animated:NO];
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
