//
//  TuiChuWindow.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/22.
//  Copyright © 2017年 鲁柯. All rights reserved.
//
typedef void(^QueDingBlock)();
typedef void(^QuXiao)();


#import <UIKit/UIKit.h>

@interface TuiChuWindow : UIView
@property(nonatomic,copy)QueDingBlock queDingBlock;
@property(nonatomic,copy)QuXiao   quXiao;

//展示信息
-(void)showText:(NSString *)planName;
@end
