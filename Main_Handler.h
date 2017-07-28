//
//  Main_Handler.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/8.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Main_Handler : NSObject

/** 连接设备 50度 不限时 */
-(void)FirstConnect_mac:(NSString *)mac
                 Sucess:(void(^)(NSString * mac))sucess
                Failure:(void(^)(NSString *mac))failur
       andIsRunDelegate:(BOOL)isRunDelegate;

/**用户设置定时*/
-(void)userDingShi_timeStr:(NSString *)timerStr complete:(void(^)(int minInt))completeBlock;


@end
