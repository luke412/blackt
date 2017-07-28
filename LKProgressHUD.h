//
//  LKProgressHUD.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/3/15.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#define    showLKProgressHUD(time)     [[LKProgressHUD sharedInstance] showLKMessage:@"" andDuration:(time)]

#import <UIKit/UIKit.h>
@interface LKProgressHUD : DOSingleton
/*
 *  指定时长显示某个信息提示
 *  message： 要展示的信息
 *  duration：持续时间
 */
-(void)showLKMessage:(NSString *)message andDuration:(NSTimeInterval)duration;
-(void)removeLKMengBan;

-(void)showLKMessage:(NSString *)message;


@end
