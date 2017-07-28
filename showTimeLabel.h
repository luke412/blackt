//
//  showTimeLabel.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/4/5.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  圆形时间label

#import <UIKit/UIKit.h>

#define label_WIDTH  80

@interface showTimeLabel : UILabel
/*
 *  依据距离屏幕中心的距离，进行缩放
 *  @param distance
 */
-(void)changeLabelSizeWithDistance:(CGFloat)distance;
@end
