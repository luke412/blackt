//
//  SudokuCustomButton.m
//  tefubao
//
//  Created by hzc on 15/10/28.
//  Copyright © 2015年 hzc. All rights reserved.
//

#import "SudokuCustomButton.h"
#import <objc/runtime.h>
@interface SudokuCustomButton ()
{
    CGFloat imageY;
    CGFloat imageHeight;
}

@property(nonatomic,strong)UIImageView *ingImage;
@end

@implementation SudokuCustomButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font          = [UIFont systemFontOfSize:15.0];
       [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.layer.borderColor        = [UIColor colorWithRed:219.0/255.0 green:237.0/255.0 blue:248.0/255.0 alpha:1.0].CGColor;
        //  self.layer.borderWidth = 0.4f;
        


    }
    return self;
}
//重写此方法，重新布局button的image
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    //对象生命周期内只执行一次
    void (^once)() = ^{
        if (objc_getAssociatedObject(self, _cmd)) return;
        else objc_setAssociatedObject(self, _cmd, @"Launched", OBJC_ASSOCIATION_RETAIN);
        imageY = 20.0f;
        imageHeight = contentRect.size.height*0.50;
    };
    once();
    

    
    CGFloat width  = contentRect.size.width *0.50;
    CGFloat height = imageHeight;
    CGFloat x      = contentRect.size.width/2-width/2;
    CGFloat y      = 20.0f;
   
    
    return CGRectMake(x, y, width, height);
}
//重写此方法，重新布局button的title
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat x      = 0.0f;
    CGFloat y      = contentRect.size.height - 35;
    CGFloat width  = contentRect.size.width;
    CGFloat height = 30;
    return  CGRectMake(x, y, width, height);
}


/**显示在正在运行的样子*/
-(void)showRuningFace{
    if (!_ingImage) {
         _ingImage =  [[UIImageView alloc]initWithFrame:CGRectMake(lkptBiLi(56), lkptBiLi(18), lkptBiLi(26), lkptBiLi(26))];
        self.ingImage.image = [UIImage imageNamed:@"ing"];
        [self addSubview:self.ingImage];
    }
    _ingImage.hidden = NO;
}

/**显示没有使用的样子*/
-(void)showStopFace{
    if (_ingImage) {
        _ingImage.hidden = YES;
    }
}


/**动画 */
-(void)dongHua:(CGFloat)weiYi{
    CGFloat shangYi = weiYi/2;
    [LKTool setView_Y:imageY - shangYi andView:_image];
}

-(void)changeHeight_weiYi:(CGFloat)weiYi{
    


}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
