//
//  NSMutableDictionary+KVO.h
//  容器类监听
//
//  Created by 鲁柯 on 2017/3/27.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSMutableDictionary (KVO)

/*
 *  添加
 */
-(void)lk_setObject:(id)anObject forKey:(NSString *)key;

/*
 *  删除
 */
-(void)lk_removeObjectForKey:(NSString *)key;

/*
 * 清空
 */
-(void)lk_removeAllObjects;
@end
