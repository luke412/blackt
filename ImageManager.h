//
//  ImageManager.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/25.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageManager : NSObject
-(UIImage *)circularCut_radius:(CGFloat)radius image:(UIImage *)image;

///截取部分图像
-(UIImage*)getSubImage:(CGRect)rect image:(UIImage *)image;
//圆形裁剪
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat)inset;
//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
