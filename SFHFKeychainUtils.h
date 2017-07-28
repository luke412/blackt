//
//  SFHFKeychainUtils.h
//  YiHuo
//
//  Created by luke on 16/8/25.
//  Copyright © 2016年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SFHFKeychainUtils : NSObject {
    
}
/**
 *  获得密码
 *
 *  @param username    用户名
 *  @param serviceName 服务名
 *  @param error       错误信息
 *
 *  @return 得到的密码
 */
+ (NSString *) getPasswordForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error;

/**
 *  写入密码
 *
 */
+ (BOOL) storeUsername: (NSString *) username andPassword: (NSString *) password forServiceName: (NSString *) serviceName updateExisting: (BOOL) updateExisting error: (NSError **) error;

/**
 *  删除密码
 *
 */
+ (BOOL) deleteItemForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error;

@end