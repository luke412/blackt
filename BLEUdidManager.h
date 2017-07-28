//
//  BLEUdidManager.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/7.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEUdidManager : NSObject

/**存入uuid到数据库*/
-(BOOL)saveUUIDToDataBase_mac:(NSString *)mac andUUID:(NSUUID *)uuid;


/**从数据库中取uuid*/
-(NSUUID *)getUUIDFromDataBase_mac:(NSString *)mac;
@end
