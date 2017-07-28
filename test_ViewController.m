//
//  test_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/14.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  测试界面

#import "test_ViewController.h"

@interface test_ViewController ()
@property (strong, nonatomic) UILabel *view1;
@end

@implementation test_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _view1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 230, 20)];
    _view1.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_view1];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[LKTool from_16To_Color:tableViewCellTextColor].CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.locations  = @[@0.3,@1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint   = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, 230, 20);
    [_view1.layer addSublayer:gradientLayer];
    
    _view1.layer.masksToBounds = YES;
    _view1.layer.cornerRadius  = 10;
    
    
    UILabel *view2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 230, 20)];
    view2.text = @"dfdasfdsfdsf";
    view2.textColor = [UIColor yellowColor];
    [_view1 addSubview:view2];
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
