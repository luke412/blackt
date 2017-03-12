//
//  LKDrawingBoard.m
//  动态画图
//
//  Created by 鲁柯 on 2017/1/20.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "LKDrawingBoard.h"
@implementation LKDrawingBoard
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self){
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.intervalWidth=10;
    self.TemperatureValueArr=[[NSMutableArray alloc]init];

}
/*
 *  newTemperatureValueArr     存放新的温度值的数组
 *  画线
 *
 */
-(void)drawLinesWithTemperatureValueArr:(NSArray <NSNumber *>*)newTemperatureValueArr{
    self.pointXArr=@[@(2),
                     @(2+PointHorizontalSpacing),
                     @(2+PointHorizontalSpacing*2),
                     @(2+PointHorizontalSpacing*3),
                     @(2+PointHorizontalSpacing*4),
                     @(2+PointHorizontalSpacing*5),
                     @(2+PointHorizontalSpacing*6),
                     @(2+PointHorizontalSpacing*7)];
    [self.TemperatureValueArr removeAllObjects];
    [self.TemperatureValueArr addObjectsFromArray:newTemperatureValueArr];
    [self removePoint];
    [self setNeedsDisplay];
}
-(void)removePoint{
    if (self.TemperatureValueArr.count>7) {
        [self.TemperatureValueArr removeObjectAtIndex:0];
        [self removePoint];
    }

}
- (void)drawRect:(CGRect)rect
{       //画四边形
        //draw4Rect();
        //画三角形
        //drawTriangle();
        //画圆
        //drawCircle();
        //画圆弧
        //drawArc(self.progress,self.color);
        //画直线
    [self drawLineWithPointArr:self.TemperatureValueArr];
}
/*
 *画直线
 */
-(void)drawLineWithPointArr:(NSMutableArray *)temperatureValueArr
{
     [self removePoint];
    if (temperatureValueArr.count>0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(context, -1, DrawingBoardHeight);//先确立一个开始的点
        for (int i=0; i<temperatureValueArr.count;i++) {
            //得到温度值  （Y）
            NSNumber *valueY =temperatureValueArr[i];
            float temperatureFloatY=[valueY floatValue];
            
            //得到X值
            NSNumber *valueX =self.pointXArr[i];
            float temperatureFloatX=[valueX floatValue];
            
            
            CGPoint point2=CGPointMake(temperatureFloatX,(DrawingBoardHeight-temperatureFloatY*ZoomRatioPointY));
            CGContextAddLineToPoint(context,point2.x,point2.y);//设置终点。如果多于两个点时，可以重复调用这个方法，就会有多个折线
            NSLog(@"坐标 %.1f,%.1f",point2.x,point2.y);
            NSString *str=[NSString stringWithFormat:@"%d°",(int)temperatureFloatY];//@"30°";
            [str drawInRect:CGRectMake(point2.x-10, point2.y-15, 30, 5)withFont:[UIFont systemFontOfSize:10] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
            
        }

        CGContextSetLineWidth(context, 1.0);//后面的数值越大，线越粗
        
        //255, 130, 71
        CGFloat components[] = {255.0/255,130.0/255,71.0/255,1.0f};
        
        CGContextSetStrokeColor(context, components);
        CGContextStrokePath(context);

    }
    
}
/**
  *  画四边形
  */
void draw4Rect()
{
        // 1.获得上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        // 2.画矩形
        CGContextAddRect(ctx, CGRectMake(10, 10, 150, 100));
        
        // set : 同时设置为实心和空心颜色
        // setStroke : 设置空心颜色
        // setFill : 设置实心颜色
        [[UIColor whiteColor]set];
        
        //    CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
        
        // 3.绘制图形
        CGContextFillPath(ctx);
}

/**
  *  画三角形
  */
void drawTriangle()
{
        // 1.获得上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        // 2.画三角形
        CGContextMoveToPoint(ctx, 0, 0);
        CGContextAddLineToPoint(ctx, 100, 100);
        CGContextAddLineToPoint(ctx, 150, 80);
        // 关闭路径(连接起点和最后一个点)起点和终点连起来
        CGContextClosePath(ctx);
        
        //
        CGContextSetRGBStrokeColor(ctx, 0, 1, 0, 1);
        
        // 3.绘制图形
        CGContextStrokePath(ctx);
}
/**
  *  画圆
  */
void drawCircle()
{
        // 1.获得上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        // 2.画圆
        CGContextAddEllipseInRect(ctx, CGRectMake(50, 10, 50, 50));//(50, 10,是坐标也就是这个圆的位置   100, 100表示宽高都是100
        
        CGContextSetLineWidth(ctx, 2); //设置线宽画圆环
        // set : 同时设置为实心和空心颜色
        // setStroke : 设置空心颜色
        // setFill : 设置实心颜色
        [[UIColor blueColor] setStroke];
        // 3.显示所绘制的东西
        CGContextStrokePath(ctx);
}
/**
  *  画圆弧
  */
void drawArc(double pprogress,UIColor *color)
{
        // 1.获得上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        // 2.画圆弧
        // x\y : 圆心
        // radius : 半径
        // startAngle : 开始角度
        // endAngle : 结束角度
        // clockwise : 圆弧的伸展方向(0:顺时针, 1:逆时针)
        //    CGContextAddArc(CGContextRef c, <#CGFloat x#>, <#CGFloat y#>, <#CGFloat radius#>, <#CGFloat startAngle#>, <#CGFloat endAngle#>, <#int clockwise#>)
        CGContextAddArc(ctx, 100, 100, 50,-M_PI/2, M_PI_2, 0);
        //    CGContextAddArc(ctx, 100（圆心x）, 100（圆心y), 50, M_PI_2, M_PI, 0);
        //线条宽度
        CGContextSetLineWidth(ctx, 8); //设置线宽画圆环
        // set : 同时设置为实心和空心颜色
        // setStroke : 设置空心颜色
        // setFill : 设置实心颜色
        [color setStroke];
        // 3.显示所绘制的东西
        //CGContextFillPath(ctx); //把绘制的路径用实心显示出来
        CGContextStrokePath(ctx);//画空心
         CGContextAddArc(ctx, 100, 100, 50,M_PI/2, -M_PI/2, 0);
         [[UIColor greenColor] setStroke];
        CGContextStrokePath(ctx);//画空心
}



@end
