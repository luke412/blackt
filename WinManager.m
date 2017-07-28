//
//  WinManager.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/8.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "WinManager.h"
#import "ZiZhuShowInfoWindow.h"
#import "LiLiaoEndWindow.h"
#import "TuiChuWindow.h"
#import "MapWindow.h"
#import "BlueiTiShiView.h"
#import "WeiZhiTiShiView.h"
#import "LKLoadingView.h"
#import "QIDongYeView.h"
#import "NSTimer+Convenience.h"
#import "MapTongYiWindow.h"

@interface WinManager()
@property(nonatomic,strong)LKLoadingView *LoadingView;
@property(nonatomic,strong)LKButton  *loadMengBan;
@end

@implementation WinManager
-(void)showLoading_showText:(NSString *)text{
    if (!_loadMengBan) {
        _loadMengBan = [[LKButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH_lk, HEIGHT_lk)];
    }
    
    _loadMengBan.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [_loadMengBan lk_addActionforControlEvents:UIControlEventTouchUpInside ActionBlock:^{
        [_loadMengBan removeFromSuperview];
    }];
    [[[ UIApplication  sharedApplication ]  keyWindow ] addSubview:_loadMengBan];
    
    if (!_LoadingView) {
         _LoadingView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"LKLoadingView" owner:self options:nil] lastObject];
    }
    WeakObj(_loadMengBan)
    _LoadingView.closeBtnBlock = ^{
        [_loadMengBanWeak removeFromSuperview];
    };
    _LoadingView.timeOutBlock = ^{
        [_loadMengBanWeak removeFromSuperview];
    };
    [_LoadingView showMessage:text andDuration:RequestTimeOut];
    [_loadMengBan addSubview:_LoadingView];
    _LoadingView.center = CGPointMake(WIDTH_lk/2, HEIGHT_lk/2);
}
-(void)removeLoading{
    
    [_loadMengBan removeFromSuperview];
}
//好友请求同意弹窗
-(void)friendTongYiWindow_text:(NSString *)text
                     lookBlock:(void(^)())lookBlock{
    LKButton *mengBan = [[LKButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH_lk, HEIGHT_lk)];
    mengBan.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [mengBan lk_addActionforControlEvents:UIControlEventTouchUpInside ActionBlock:^{
        [mengBan removeFromSuperview];
    }];
    [[[ UIApplication  sharedApplication ]  keyWindow ] addSubview:mengBan];
    
    MapTongYiWindow  *winView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"MapTongYiWindow" owner:self options:nil] lastObject];
    winView.lookBlock = ^{
        if (lookBlock) {
            lookBlock();
        }
        [mengBan removeFromSuperview];
    };

    [winView showText:text];
    [mengBan addSubview:winView];
    winView.center = CGPointMake(WIDTH_lk/2, HEIGHT_lk/2);
}

#pragma mark - 地图（好友请求）
-(void)showFriendRequestWindow_text:(NSString *)text
                             TongYi:(void(^)())tongYi
                           ZaiXiang:(void(^)())zaiXiang{
    LKButton *mengBan = [[LKButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH_lk, HEIGHT_lk)];
    mengBan.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [mengBan lk_addActionforControlEvents:UIControlEventTouchUpInside ActionBlock:^{
        [mengBan removeFromSuperview];
    }];
    [[[ UIApplication  sharedApplication ]  keyWindow ] addSubview:mengBan];

     MapWindow  *winView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"MapWindow" owner:self options:nil] lastObject];
    winView.tongYiBlock = ^{
        if (tongYi) {
            tongYi();
             [mengBan removeFromSuperview];
        }
        [mengBan removeFromSuperview];
    };
    winView.zaiXiangBlock = ^{
        if (zaiXiang) {
            zaiXiang();
             [mengBan removeFromSuperview];
        }
        [mengBan removeFromSuperview];
    };
    [winView showText:text];
    [mengBan addSubview:winView];
    winView.center = CGPointMake(WIDTH_lk/2, HEIGHT_lk/2);
}

#pragma mark - 理疗完成
-(void)showLiliaoEndWindow_planName:(NSString *)name
                            queDing:(void(^)())queDing{
    LKButton *mengBan = [[LKButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH_lk, HEIGHT_lk)];
    mengBan.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [mengBan lk_addActionforControlEvents:UIControlEventTouchUpInside ActionBlock:^{
        [mengBan removeFromSuperview];
    }];
    [[[ UIApplication  sharedApplication ]  keyWindow ] addSubview:mengBan];
    
    LiLiaoEndWindow  *winView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"LiLiaoEndWindow" owner:self options:nil] lastObject];
    winView.queDingBlock = ^{
        if (queDing) {
            queDing();
        }
        [mengBan removeFromSuperview];
    };
    [winView showPlanName:name];
    [mengBan addSubview:winView];
    winView.center = CGPointMake(WIDTH_lk/2, HEIGHT_lk/2);
}

#pragma mark - 退出弹窗
-(void)showTuiChuWindiw_name:(NSString *)name
                        queDing:(void(^)())queDing
                         quXiao:(void(^)())quXiao{

    LKButton *mengBan = [[LKButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH_lk, HEIGHT_lk)];
    mengBan.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [mengBan lk_addActionforControlEvents:UIControlEventTouchUpInside ActionBlock:^{
        [mengBan removeFromSuperview];
    }];
    [[[ UIApplication  sharedApplication ]  keyWindow ] addSubview:mengBan];
    
    TuiChuWindow  *winView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"TuiChuWindow" owner:self options:nil] lastObject];
    winView.queDingBlock = ^{
        if (queDing) {
            queDing();
        }
         [mengBan removeFromSuperview];
    };
    
    winView.quXiao = ^{
        if (quXiao) {
            quXiao();
        }
         [mengBan removeFromSuperview];
    };
    [winView showText:name];
    [mengBan addSubview:winView];
    winView.center = CGPointMake(WIDTH_lk/2, HEIGHT_lk/2);
}

#pragma mark - 蓝牙未开
-(void)showWin_bluePoweredOff{
    LKAlertController *alertVc = [LKAlertController alertControllerWithTitle: @"手机蓝牙未打开" message:LK(@"手机蓝牙未打开") preferredStyle:UIAlertControllerStyleAlert];
        alertVc.message = @"请在iOS“设置”-“蓝牙”中打开蓝牙";
            LKAlertAction *queDing = [LKAlertAction actionWithTitle:LK(@"知道了") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                        }];
            [alertVc addAction:queDing];
             [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVc animated:YES completion:^{
                }];
}

-(void)stopHeat_Stop:(void(^)())stopBlack JiXu:(void(^)())JiXuBlock{
    LKAlertController *alertVc = [LKAlertController alertControllerWithTitle: @"停止连接？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            LKAlertAction *queDing = [LKAlertAction actionWithTitle:LK(@"停止") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (stopBlack) {
            stopBlack();
        }
                        }];
    LKAlertAction *cancal = [LKAlertAction actionWithTitle:LK(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (JiXuBlock) {
            JiXuBlock();
        }
                        }];
    [alertVc addAction:cancal];
            [alertVc addAction:queDing];
             [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVc animated:YES completion:^{
                }];
}

-(void)showZiZhuCowWindow_TempStr:(NSString *)TempStr tempStateStr:(NSString *)tempStateStr planName:(NSString *)planNname{
    
    
    LKButton *mengBan = [[LKButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH_lk, HEIGHT_lk)];
    mengBan.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [mengBan lk_addActionforControlEvents:UIControlEventTouchUpInside ActionBlock:^{
        [mengBan removeFromSuperview];
    }];
    [[[ UIApplication  sharedApplication ]  keyWindow ] addSubview:mengBan];
    ZiZhuShowInfoWindow  *winView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ZiZhuShowInfoWindow" owner:self options:nil] lastObject];
    
    winView.heatStateStr = tempStateStr;
    winView.wenDuValueStr = TempStr;
    [winView showInfo];
    
    //圆角
    winView.layer.masksToBounds = YES;
    winView.layer.cornerRadius  = 5;
    [mengBan addSubview:winView];
    winView.center = CGPointMake(WIDTH_lk/2, HEIGHT_lk/2);
}

-(void)showlogOutWindow_logOut:(void(^)())logOutBlock cancal:(void(^)())cancalBlock{
    LKAlertController *alertVc = [LKAlertController alertControllerWithTitle:@"确认" message:LK(@"确定要退出登录吗") preferredStyle:UIAlertControllerStyleAlert];
        alertVc.message = @"确定要退出登录吗";
         LKAlertAction *queDing = [LKAlertAction actionWithTitle:LK(@"确定") style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            if (logOutBlock) {
                                                                logOutBlock();
                                                            }
             
                                                        }];
     LKAlertAction *cancal = [LKAlertAction actionWithTitle:LK(@"取消") style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         if (cancalBlock) {
                                                             cancalBlock();
                                                         }
                                                     }];
     [alertVc addAction:cancal];
     [alertVc addAction:queDing];
     [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVc animated:YES completion:^{ }];
}

/** 没有绑定设备 */
-(void)MeibangDing_bangDing:(void(^)())bangDingBlock
                     quXiao:(void(^)())quXiaoBlock{
    LKAlertController *alertVc = [LKAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    alertVc.message = @"您还没有绑定设备";
                
     LKAlertAction *bangDing = [LKAlertAction actionWithTitle:LK(@"去绑定") style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action){
                                                        if (bangDingBlock) {
                                                            bangDingBlock();
                                                        }
                                                    }];
    
     LKAlertAction *cancal = [LKAlertAction actionWithTitle:LK(@"取消") style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction * _Nonnull action){
                                                        if (quXiaoBlock) {
                                                            quXiaoBlock();
                                                        }
                                                    }];
    [alertVc addAction:bangDing];
     [alertVc addAction:cancal];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVc animated:YES completion:^{ }];
}

-(void)showWeiZhiWindow_weiZhiYes:(void(^)())weiZhiYes
                         weiZhiNo:(void(^)())weiZhiNo{
    //BlueiTiShiView *tiShiView = [[[NSBundle mainBundle]loadNibNamed:@"BlueiTiShiView" owner:nil options:nil]firstObject];
    WeiZhiTiShiView *tiShiView = [[[NSBundle mainBundle]loadNibNamed:@"WeiZhiTiShiView" owner:nil options:nil]firstObject];
    tiShiView.frame = CGRectMake(0, 0, WIDTH_lk, HEIGHT_lk);
    tiShiView.userInteractionEnabled = YES;
    LKButton *leftBtn = [tiShiView viewWithTag:1];
    LKButton *right   = [tiShiView viewWithTag:2];
    WeakObj(tiShiView);
    [leftBtn lk_addActionforControlEvents:UIControlEventTouchUpInside
                              ActionBlock:^{
                                  if (weiZhiNo) {
                                      weiZhiNo();
                                  }
                                  [tiShiViewWeak removeFromSuperview];
                              }];
    [right lk_addActionforControlEvents:UIControlEventTouchUpInside
                            ActionBlock:^{
                                if (weiZhiYes) {
                                    weiZhiYes();
                                }
                                [tiShiViewWeak removeFromSuperview];
                            }];
    [[UIApplication sharedApplication].keyWindow addSubview:tiShiView];

}

-(void)showBlueWindow_blueYes:(void(^)())blueYes
                             blueNo:(void(^)())blueNo{
    BlueiTiShiView *tiShiView = [[[NSBundle mainBundle]loadNibNamed:@"BlueiTiShiView" owner:nil options:nil]firstObject];
    tiShiView.frame = CGRectMake(0, 0, WIDTH_lk, HEIGHT_lk);
    tiShiView.userInteractionEnabled = YES;
    LKButton *leftBtn = [tiShiView viewWithTag:1];
    LKButton *right   = [tiShiView viewWithTag:2];
    WeakObj(tiShiView);
    [leftBtn lk_addActionforControlEvents:UIControlEventTouchUpInside
                              ActionBlock:^{
                                  if (blueNo) {
                                      blueNo();
                                  }
                                  [tiShiViewWeak removeFromSuperview];
                              }];
    [right lk_addActionforControlEvents:UIControlEventTouchUpInside
                            ActionBlock:^{
                                if (blueYes) {
                                    blueYes();
                                }
                                [tiShiViewWeak removeFromSuperview];
                            }];
    [[UIApplication sharedApplication].keyWindow addSubview:tiShiView];
    
}


-(void)showQiDongYe_imagePath:(NSString *)imagePath
                     duration:(NSInteger)duration
                 TiaoGuoBlock:(void(^)())tiaoGuoBlock
                WanChengBlock:(void(^)())wanChengBlock
                 TimeOutBlock:(void(^)())timeOutBlock
{
    QIDongYeView *qidongyeView          = [[[NSBundle mainBundle]loadNibNamed:@"QIDongYeView" owner:nil options:nil]firstObject];
    qidongyeView.frame                  = CGRectMake(0, 0, WIDTH_lk, HEIGHT_lk);
    qidongyeView.userInteractionEnabled = YES;
    qidongyeView.backImagePath          = imagePath;
    
    
     WeakObj(qidongyeView);
    __block NSInteger seconds = duration;
    NSTimer * _timer = [NSTimer scheduledTimerWithTimeInterval:1
      repeats:YES
      callback:^(NSTimer *timer) {
          if (seconds == 0) {
              if (timer != nil) {
                          //销毁定时器
                          [timer invalidate];
              }

              [UIView animateWithDuration:0.5
                               animations:^{
                                   qidongyeViewWeak.alpha = 0;
                               } completion:^(BOOL finished) {
                                   [qidongyeViewWeak removeFromSuperview];
                                   //展示时间到
                                   if (wanChengBlock) {
                                       wanChengBlock();
                                   }

                               }];
              
                   }

          qidongyeViewWeak.labelText = [NSString stringWithFormat:@"%ld",seconds];
          seconds -=1;
          
      }];

    //滚动条不受影响
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

    //跳过
    qidongyeView.tiaoGuoBlock = ^{
        if (_timer != nil) {
                    //销毁定时器
                    [_timer invalidate];
        }

        
        //移除自身
        [UIView animateWithDuration:0.5
                         animations:^{
                             qidongyeViewWeak.alpha = 0;
                         } completion:^(BOOL finished) {
                             if (tiaoGuoBlock) {
                                 tiaoGuoBlock();
                             }
                             [qidongyeViewWeak removeFromSuperview];
                         }];
    };
    //超时
    qidongyeView.timeOutBlock = ^{
        if (_timer != nil) {
                    //销毁定时器
                    [_timer invalidate];
        }

        [UIView animateWithDuration:0.5
                         animations:^{
                             qidongyeViewWeak.alpha = 0;
                         } completion:^(BOOL finished) {
                             [qidongyeViewWeak removeFromSuperview];
                             if (timeOutBlock) {
                                 timeOutBlock();
                             }
                             
                         }];

        };
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:qidongyeView];
}

@end
