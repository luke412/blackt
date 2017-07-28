//
//  DingShiScrollow.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/4/2.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "showTimeLabel.h"

typedef void(^queDingBlock)(NSString *timeStr);

@interface DingShiScrollow : UIView
@property(nonatomic,strong)showTimeLabel *selectedLabel;
@property(nonatomic,copy)queDingBlock  myQueDingBlock;
@end
