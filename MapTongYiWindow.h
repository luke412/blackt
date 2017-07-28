//
//  MapTongYiWindow.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/27.
//  Copyright © 2017年 鲁柯. All rights reserved.
//
typedef void(^LookBlock)();

#import <UIKit/UIKit.h>

@interface MapTongYiWindow : UIView
@property(nonatomic,copy)LookBlock lookBlock;

//用户的手机号
-(void)showText:(NSString *)text;
@end
