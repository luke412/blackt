




//
//  LKLoadingView.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/26.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "LKLoadingView.h"
@interface LKLoadingView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageVC;
@property (weak, nonatomic) IBOutlet UILabel     *label;
@property (weak, nonatomic) IBOutlet UIButton    *closeBtn;

@property(nonatomic,strong)NSTimer *timer;
@end

@implementation LKLoadingView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
}
-(void)showMessage:(NSString *)message andDuration:(NSTimeInterval)duration{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(everyTime) userInfo:nil repeats:NO];
        
        //滚动条不受影响
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    _label.text = message;
    _label.textAlignment = NSTextAlignmentCenter;
    [self startAnimation];
}


-(void)everyTime{
    if (_timeOutBlock) {
        _timeOutBlock();
    }
    if (_timer != nil) {
        //销毁定时器
        [_timer invalidate];
        _timer = nil;
    }
}
- (IBAction)closeBtnClick:(id)sender {
    if (_timer != nil) {
        //销毁定时器
                [_timer invalidate];
        _timer = nil;
    }

    if (_closeBtnBlock) {
        _closeBtnBlock();
    }
}
-(void)dealloc
{
        if (_timer != nil) {
                //销毁定时器
                [_timer invalidate];
            }
}

#pragma mark - 动画
-(void) startAnimation
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue           = [NSNumber numberWithFloat:M_PI * 0.4];
    rotationAnimation.duration          = 0.2;
    rotationAnimation.cumulative        = YES;
    rotationAnimation.repeatCount       = ULLONG_MAX;
    [self.imageVC.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
