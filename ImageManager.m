//
//  ImageManager.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/25.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "ImageManager.h"

@implementation ImageManager
-(UIImage *)circularCut_radius:(CGFloat)radius image:(UIImage *)image {
    
        //获取图片尺寸
        CGSize size = image.size;
        
        //开启位图上下文
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        
        //创建圆形路径
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius*2, radius*2)];
        
        //设置为裁剪区域
        [path addClip];
        
        //绘制图片
        [image drawAtPoint:CGPointZero];
        
        //获取裁剪后的图片
        UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
        
        //关闭上下文
        UIGraphicsEndImageContext();
        
        
        
        return image2;
}

///截取部分图像
-(UIImage*)getSubImage:(CGRect)rect image:(UIImage *)image
{
        CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
      //CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
        CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
        
        UIGraphicsBeginImageContext(smallBounds.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, smallBounds, subImageRef);
        UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
        UIGraphicsEndImageContext();
        
        return smallImage;
}

//圆形裁剪
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
        UIGraphicsBeginImageContext(image.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2);
        CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);   //边界颜色
        CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
        CGContextAddEllipseInRect(context, rect);
        CGContextClip(context);
        
        [image drawInRect:rect];
        CGContextAddEllipseInRect(context, rect);
        CGContextStrokePath(context);
        UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newimg;
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
        UIGraphicsBeginImageContext(newSize);
        
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return newImage;
}

@end
