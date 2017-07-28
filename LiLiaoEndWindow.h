//
//  LiLiaoEndWindow.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/22.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

typedef void(^QueDingBlock)();

#import <UIKit/UIKit.h>

@interface LiLiaoEndWindow : UIView
@property(nonatomic,copy)QueDingBlock queDingBlock;

-(void)showPlanName:(NSString *)planName;
@end
