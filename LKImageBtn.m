//
//  LKImageBtn.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/21.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  鲁柯图文按钮

#import "LKImageBtn.h"
@interface LKImageBtn ()
{
    CGFloat selfWidth;
    CGFloat selfHeight;
    CGFloat imageY;
    CGFloat labelY;
    
    UILabel *myLabel;
    UIImageView *myImageVC;
}
@property(nonatomic,strong)UIImageView *ingImage;
@end

@implementation LKImageBtn
-(instancetype)initWithFrame:(CGRect)frame
                    andTitle:(NSString *)title
                    andImage:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self){
        selfWidth  = frame.size.width;
        selfHeight = frame.size.height;
        
        //设置
        myLabel.textAlignment  = NSTextAlignmentCenter;
        myLabel.font           = [UIFont systemFontOfSize:15.0];
        myLabel.textColor      = [UIColor blackColor];
        self.layer.borderColor = [UIColor colorWithRed:219.0/255.0 green:237.0/255.0 blue:248.0/255.0 alpha:1.0].CGColor;
        
        
        
        //label
        CGFloat x      = 0.0f;
        CGFloat y      = selfHeight - 35;
        CGFloat width  = selfWidth;
        CGFloat height = 30;
        labelY = y;
        myLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, width, height)];
        myLabel.text = title;
        myLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:myLabel];
        
        //image

        
        CGFloat width1  = selfWidth  *0.50;
        CGFloat height1 = selfHeight *0.50;
        CGFloat x1      = selfWidth/2-width1/2;
        CGFloat y1      = 20.0f;
        imageY = 20.0f;
        
        myImageVC = [[UIImageView alloc]initWithFrame:CGRectMake(x1, y1, width1, height1)];
        myImageVC.image = image;
        [self addSubview:myImageVC];
        
        
    }
    return self;
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
    CGFloat imageHeight1 = myImageVC.frame.size.height;
    
    //image
    [LKTool setView_Y: (selfHeight - weiYi - imageHeight1)/2  andView:myImageVC]; //shangYi
    
    //label
    [LKTool setView_Y:labelY - weiYi andView:myLabel];
    
    //self
    [LKTool setView_Height:selfHeight - weiYi andView:self];
   
    myLabel.alpha =  1-shangYi /( _maxWeiYi/2);
    LKLog(@"alpa:%f",1-shangYi / _maxWeiYi);
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
