//
//  LKDaTouZhen.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/27.
//  Copyright © 2017年 鲁柯. All rights reserved.
//
typedef void(^clickBlock)();

#import <UIKit/UIKit.h>

@interface LKDaTouZhen : UIView
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *touXiangImage;

@property(nonatomic,copy)clickBlock myclickBlock;
@end
