//
//  DingShiView.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/5/15.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  DingShiViewDelegate <NSObject>

@required
-(void)dingClick;
@end



@interface DingShiView : UIView
@property (strong, nonatomic)  UIView *bottomLine;
@property (nonatomic,weak)  id <DingShiViewDelegate> delegate;

/** 显示倒计时时间 00：00：00 */
-(void)showRestTime_seconds:(NSInteger)seconds;


@end
