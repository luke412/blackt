//
//  showTimeLabel.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/4/5.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "showTimeLabel.h"

@interface showTimeLabel ()
@property(nonatomic,assign)float labelZoom;    //label的缩放比 0 - 1

@end


@implementation showTimeLabel
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = self.frame.size.width/2;
        self.layer.masksToBounds =YES;
        //缩放比例
        self.labelZoom = 0.25;
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y+30,
                                label_WIDTH *self.labelZoom,
                                label_WIDTH *self.labelZoom);
    }
    return self;
}


-(void)changeLabelSizeWithDistance:(CGFloat)distance{
    self.labelZoom = 1 - 0.75*(distance/(WIDTH_lk/2));
    CGPoint center = CGPointMake(self.center.x, self.center.y);
    
    
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            label_WIDTH *self.labelZoom,
                            label_WIDTH *self.labelZoom);
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.masksToBounds =YES;
    self.adjustsFontSizeToFitWidth = YES;
    self.alpha = self.labelZoom;
    if (self.labelZoom > 0.9){
        self.backgroundColor = [LKTool from_16To_Color:dingShiShen];
    }else{
        self.backgroundColor = [LKTool from_16To_Color:dingShiShen];
    }
    self.center = CGPointMake(center.x, center.y);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
