//
//  LKButton.m
//  sss
//
//  Created by 鲁柯 on 2017/4/2.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "LKButton.h"
@interface LKButton ()
@property(nonatomic,copy)actionBlock myBlock;
@end

@implementation LKButton
-(void)lk_addActionforControlEvents:(UIControlEvents)controlEvents  ActionBlock:(actionBlock)block{
    [self addTarget:self action:@selector(click) forControlEvents:controlEvents];
    self.myBlock = block;
}
-(void)click{
    if (self.myBlock) {
        self.myBlock();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
