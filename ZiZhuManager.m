//
//  ZiZhuManager.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/7.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  自助调温管理者

#import "ZiZhuManager.h"

@interface ZiZhuManager ()
/**自助调温定时开始的秒数*/
@property(nonatomic,assign)NSInteger seconds;

/**自助调温的总定时*/
@property(nonatomic,assign)NSInteger sumSeconds;

@property(nonatomic,strong)NSTimer  *timer;
@end

@implementation ZiZhuManager
-(void)everyTime{
    _seconds += MIAO_SHU;
    
    if (_seconds >= _sumSeconds) {
        [self finish];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(ZhiZhuHeartRefresh:)]) {
        [_delegate ZhiZhuHeartRefresh:_sumSeconds - _seconds];
    }
}
-(void)run_dingShiSeconds:(NSInteger)seconds{
    if (!_timer) {
         [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(everyTime)
                                                userInfo:nil
                                                 repeats:YES];
        //滚动条不受影响
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    
    [_timer setFireDate:[NSDate date]];
    _seconds = 0;
    _sumSeconds = seconds;
    App_Manager.heatState = Zizhu_heat;
    if (_delegate && [_delegate respondsToSelector:@selector(ZhiZhuStart_wenDu:andSeconds:)]) {
        [_delegate ZhiZhuStart_wenDu:50 andSeconds:seconds];
    }
}
-(void)finish{
    [_timer setFireDate:[NSDate distantFuture]];
    App_Manager.heatState = WuCaoZuo_heat;
    if (_delegate && [_delegate respondsToSelector:@selector(ZhiZhuFinish)]) {
        [_delegate ZhiZhuFinish];
    }
    //弹窗
    [Win_Manager showLiliaoEndWindow_planName:@"自助调温" queDing:^{
        
    }];
}
-(void)end{
    [_timer setFireDate:[NSDate distantFuture]];
    App_Manager.heatState = WuCaoZuo_heat;
    if (_delegate && [_delegate respondsToSelector:@selector(ZhiZhuEnd)]) {
        [_delegate ZhiZhuEnd];
    }
}
@end
