//
//  LKAlertAction.m
//  test
//
//  Created by 鲁柯 on 2017/5/26.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "LKAlertAction.h"
#import "LKTool.h"
@implementation LKAlertAction
+ (instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction * _Nonnull))handler{
    LKAlertAction  *temp =  [super actionWithTitle:title style:style handler:handler];
    if ([UIDevice currentDevice].systemVersion.floatValue < 9.0f) {
        return (LKAlertAction *)temp;
    }
    
    @try {
        if (style == UIAlertActionStyleDefault) {  //默认按钮
            [temp setValue:[LKTool from_16To_Color:@"fee050"] forKey:@"_titleTextColor"];
        }
        if (style == UIAlertActionStyleCancel) {  //取消按钮
            [temp setValue:[LKTool from_16To_Color:@"d6d6d6"] forKey:@"_titleTextColor"];
        }
    }
    @catch (NSException *exception) {
        LKLog(@"拉倒");
    }
    @finally {
        //
        NSLog(@"tryTwo - 我一定会执行");
    }
    
    return (LKAlertAction *)temp;
}
@end
