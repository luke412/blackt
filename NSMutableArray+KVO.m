//
//  NSMutableArray+KVO.m
//  容器类监听
//
//  Created by 鲁柯 on 2017/3/27.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "NSMutableArray+KVO.h"

@implementation NSMutableArray (KVO)

/*
 *  添加元素
 */
-(void)lk_addObject:(id)anObject{
    ObjectChangeNotifyModel *model = [[ObjectChangeNotifyModel alloc]init];
    model.OldObject = [self copy];
    [self addObject:anObject];
    model.NewObject = [self copy];
    model.className = [NSString stringWithUTF8String:object_getClassName(self)];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSNotification *notify = [[NSNotification alloc]initWithName:NSMutableArrayAdd object:model userInfo:nil];
    [nc postNotification:notify];
}
@end
