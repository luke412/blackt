//
//  LKButton.h
//  sss
//
//  Created by 鲁柯 on 2017/4/2.
//  Copyright © 2017年 鲁柯. All rights reserved.
//
typedef void(^actionBlock)();
#import <UIKit/UIKit.h>

@interface LKButton : UIButton
@property (nonatomic,assign)BOOL isOn;
-(void)lk_addActionforControlEvents:(UIControlEvents)controlEvents  ActionBlock:(actionBlock)block;
@end
