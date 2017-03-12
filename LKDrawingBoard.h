//
//  LKDrawingBoard.h
//  动态画图
//
//  Created by 鲁柯 on 2017/1/20.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>
#define  DrawingBoardHeight   72   //画板高度
#define  DrawingLineMaxHeight 72
#define  ZoomRatioPointY      0.9  //纵坐标的缩放比
#define  PointHorizontalSpacing         60   //两个温度画点的水平间距
@interface LKDrawingBoard : UIScrollView

@property(nonatomic,strong)NSMutableArray <NSNumber *> *TemperatureValueArr;     //存放温度值的数组
@property(nonatomic ,strong)NSArray *pointXArr;                        //存放横坐标的数组
@property(nonatomic,assign)CGFloat intervalWidth;                   //间隔宽度
-(void)drawLinesWithTemperatureValueArr:(NSArray <NSNumber *>*)newTemperatureValueArr;
@end
