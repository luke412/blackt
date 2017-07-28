//
//  QIDongYeView.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/26.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "QIDongYeView.h"
@interface QIDongYeView ()
@property (weak, nonatomic) IBOutlet UIButton *tiaoGuoBtn;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tiaoGuoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger seconds;
@end


@implementation QIDongYeView
-(void)setBackImagePath:(NSString *)backImagePath{
     _seconds = 0;
    if (!_timer) {
         _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(everyTime) userInfo:nil repeats:YES];
         [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
   
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:backImagePath]
                             completed:^(UIImage *image,
                                         NSError *error,
                                         SDImageCacheType cacheType,
                                         NSURL *imageURL) {
                                 _seconds = 0 ;
    }];
}
-(void)everyTime{
    if (_seconds >= QiDingYeTimeOut) {
        if (_timer != nil){
            //销毁定时器_seconds
            [_timer invalidate];
         }
        //超时
        if (_timeOutBlock) {
            _timeOutBlock();
        }
    }
}

-(void)setLabelText:(NSString *)labelText{
    _secondsLabel.text = labelText;
}
- (IBAction)tiaoGuoClick:(id)sender{
    if (_tiaoGuoBlock){
        _tiaoGuoBlock();
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
