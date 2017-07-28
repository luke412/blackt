//
//  LKLoadingView.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/26.
//  Copyright © 2017年 鲁柯. All rights reserved.
//
typedef void(^CloseBtnBlock)();
typedef void(^TimeOutBlock)();


#import <UIKit/UIKit.h>

@interface LKLoadingView : UIView
@property(nonatomic,copy)CloseBtnBlock closeBtnBlock;
@property(nonatomic,copy)TimeOutBlock  timeOutBlock;

-(void)showMessage:(NSString *)message andDuration:(NSTimeInterval)duration;
@end
