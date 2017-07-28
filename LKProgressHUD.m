//
//  LKProgressHUD.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/3/15.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "LKProgressHUD.h"
@interface LKProgressHUD ()
@property(nonatomic,strong)UIView *mengBan;   //蒙版
@property(nonatomic,strong)UILabel *showView;  //展示的view
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UIActivityIndicatorView *testActivityIndicator;

//图片
@property(nonatomic,strong)UIImageView *loadImageView;

@end
@implementation LKProgressHUD
-(void)showLKMessage:(NSString *)message andDuration:(NSTimeInterval)duration{
    //蒙版
    self.mengBan = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_lk, HEIGHT_lk)];
    self.mengBan.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:self.mengBan];
    
    //展示view
    CGFloat width = 210;
    CGFloat height = 90;
    self.showView = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH_lk/2-width/2, HEIGHT_lk/2-height/2, width, height)];
    self.showView.backgroundColor = [LKTool from_16To_Color:@"#000000"];
    self.showView.layer.masksToBounds =YES;
    self.showView.layer.cornerRadius =15;
    self.showView.text=@"正在处理...";
    self.showView.textColor = [UIColor whiteColor];
    self.showView.textAlignment = NSTextAlignmentCenter;
    self.showView.alpha = 0.8;
    [self.mengBan addSubview:self.showView];
    
//    self.testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    self.testActivityIndicator.center = CGPointMake(WIDTH_lk/2, HEIGHT_lk/2);//只能设置中心，不能设置大小
//    self.testActivityIndicator.color = [UIColor whiteColor];
//    [self.testActivityIndicator startAnimating];        // 开始旋转
//    [self.testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
//    [self.mengBan addSubview:self.testActivityIndicator];
     _timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(everyTime) userInfo:nil repeats:NO];
}

-(void)showLKMessage:(NSString *)message{
    //蒙版
    self.mengBan = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_lk, HEIGHT_lk)];
    self.mengBan.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:self.mengBan];
    
    //展示view
    CGFloat width = 200;
    CGFloat height =200;
    self.showView                     = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH_lk/2-width/2, HEIGHT_lk/2-height/2, width, height)];
    self.showView.backgroundColor     = [LKTool from_16To_Color:@"#000000"];
    self.showView.layer.masksToBounds = YES;
    self.showView.layer.cornerRadius  = 15;
    self.showView.text                = message;
    self.showView.textColor           = [UIColor whiteColor];
    self.showView.textAlignment       = NSTextAlignmentCenter;
    self.showView.alpha               = 0.8;
    _timer = [NSTimer scheduledTimerWithTimeInterval:RequestTimeOut target:self selector:@selector(everyTime) userInfo:nil repeats:NO];
    
    //添加取消 叉号
    LKButton *btn = [[LKButton alloc]initWithFrame:CGRectMake(180,5, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"MBProgressHUD.bundle/error.png"] forState:UIControlStateNormal];
    [btn lk_addActionforControlEvents:UIControlEventTouchUpInside ActionBlock:^{
        [self removeLKMengBan];
    }];
    
    
    //图片
    CGFloat width2  =100;
    CGFloat height2 =100;
    self.loadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH_lk/2-width2/2, HEIGHT_lk/2-height2/2,width2,height2)];
    self.loadImageView.image = [UIImage imageNamed:@"白色loading"];
    [self.mengBan addSubview:self.loadImageView];
    [self.showView addSubview:btn];
    [self.mengBan addSubview:self.showView];
    [self startAnimation];
}

#pragma mark - 动画
-(void) startAnimation
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    
    rotationAnimation.duration = 0.2;
    
    rotationAnimation.cumulative = YES;
    
    rotationAnimation.repeatCount =ULLONG_MAX;
    
    
    [self.loadImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}



-(void)removeLKMengBan{
    if (_timer != nil) {
        //销毁定时器
        [_timer invalidate];
    }
    [self.testActivityIndicator stopAnimating];  // 结束旋转
    [self.mengBan removeFromSuperview];
}
-(void)everyTime{
    if (self.testActivityIndicator) {
        [self.testActivityIndicator stopAnimating];  // 结束旋转
    }
    
    if (self.mengBan) {
        [self.mengBan removeFromSuperview];
    }
}





-(void)dealloc
{
    if (_timer != nil) {
            //销毁定时器
            [_timer invalidate];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
