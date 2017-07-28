//
//  LKSwitch.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/5/26.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "LKSwitch.h"

@implementation LKSwitch

-(instancetype)initWithFrame:(CGRect)frame andName:(NSString *)name{
    self = [super initWithFrame:frame];
    if (self) {
        self.name = name;
    }
    return  self;
}
-(void)setOn:(BOOL)on{
    [super setOn:on];
    if ([self.name isEqualToString:@"温暖界面开关"]) {
        if (self.isOn == YES) {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                NSNotification *notify = [[NSNotification alloc]initWithName:@"UISwithChange" object:@"ON" userInfo:nil];
                [nc postNotification:notify];

        }else{
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                NSNotification *notify = [[NSNotification alloc]initWithName:@"UISwithChange" object:@"DOWN" userInfo:nil];
                [nc postNotification:notify];

        }
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
