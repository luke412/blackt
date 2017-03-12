//
//  LKDrawingBoard.h
//  动态画图
//
//  Created by 鲁柯 on 2017/1/20.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKDrawingBoard : UIScrollView

@property(nonatomic,strong)NSMutableArray *temperatureLabelArr;     //存放温度标签的数组     （要注意复用）
@property(nonatomic,strong)NSMutableArray <NSString *> *pointArr;     //存放坐标点的数组
@property(nonatomic,assign)CGFloat intervalWidth;                   //间隔宽度

-(void)addNewPoint:(CGPoint)newPoint;
@end
