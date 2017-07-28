//
//  NSMutableDictionary+KVO.m
//  容器类监听
//
//  Created by 鲁柯 on 2017/3/27.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "NSMutableDictionary+KVO.h"

@implementation NSMutableDictionary (KVO)
/*
 *  添加元素
 */

-(void)lk_setObject:(id)anObject forKey:(NSString *)key{
    ObjectChangeNotifyModel *model = [[ObjectChangeNotifyModel alloc]init];
    model.OldObject = [self copy];
    [self setObject:anObject forKey:key];
    model.NewObject = [self copy];
    model.mac = key;
    model.className = [NSString stringWithUTF8String:object_getClassName(self)];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSNotification *notify = [[NSNotification alloc]initWithName:NSMutableDictionarySet object:model userInfo:nil];
    [nc postNotification:notify];
}

-(void)lk_removeObjectForKey:(NSString *)key{
    ObjectChangeNotifyModel *model = [[ObjectChangeNotifyModel alloc]init];
    model.OldObject = [self copy];
    [self removeObjectForKey:key];
    model.NewObject = [self copy];
    model.className = [NSString stringWithUTF8String:object_getClassName(self)];
    model.mac = key;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSNotification *notify = [[NSNotification alloc]initWithName:NSMutableDictionaryRmove  object:model userInfo:nil];
    [nc postNotification:notify];
    
}

-(void)lk_removeAllObjects{
    ObjectChangeNotifyModel *model = [[ObjectChangeNotifyModel alloc]init];
    model.OldObject = [self copy];
    [self removeAllObjects];
    model.NewObject = [self copy];
    model.className = [NSString stringWithUTF8String:object_getClassName(self)];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSNotification *notify = [[NSNotification alloc]initWithName:NSMutableDictionaryRmoveAll  object:model userInfo:nil];
    [nc postNotification:notify];
}
@end
