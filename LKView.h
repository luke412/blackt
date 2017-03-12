//
//  LKView.h
//  圆形进度条
//
//  Created by 鲁柯 on 2017/2/15.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKView : UIImageView
@property (nonatomic ,assign) CGFloat  lineWidth;
@property (nonatomic ,assign) CGFloat  radius;
@property (nonatomic ,assign) CGFloat  progress;

@property (nonatomic ,assign) CGPoint  circleCenterPosition;    //圆心位置
@property (nonatomic ,assign) CGPoint  handlePosition;          //手柄位置

@property(nonatomic,assign) ConnectionStatus isOnline;   //是否是已连接状态

-(void)refreshHandleWithWenDu:(float)wenDu;
@end
