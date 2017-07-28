//
//  DataBaseManager.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/6.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "DOSingleton.h"

@class DeviceModel;
@interface DataBaseManager : DOSingleton

/**
 *  创建数据库，并且创建表
 *  返回值：操作是否成功
 */
-(BOOL)createDataBaseAndCreateTable;


#pragma mark - 设备相关
/** 是否有已绑定设备 */
-(BOOL)isHaveBoundDevice;

/**
 *  获取所有已绑定设备
 */
-(NSArray <DeviceModel *> *)getAllBoundDevice;


/**数据库是否存在缓存*/
-(NSArray <DeviceModel *>*)isExistInTheTable:(NSString *)macAddress;

/**数据库添加设备*/
-(BOOL)addDeviceTodataBase_mac:(NSString *)mac andName:(NSString *)name andType:(NSString *)type;


/**  从绑定表中删除               （删除绑定衣物）
 *   返回值：是否删除成功
 */
-(BOOL)DeletedFromTheTable:(NSString *)macAddress;


/**修改名称*/
-(BOOL)XiuGai_mac:(NSString *)mac name:(NSString *)name;

/**清空表*/
-(BOOL)clearTheTableWithName:(NSString *)tableName;



#pragma mark - 消息
-(NSArray <MessageModel *>*)loadAllMessage;
-(BOOL)lk_saveMessageToDataBase:(MessageModel *)message;
-(BOOL)lk_xiuGaiReadStateWithMessage:(MessageModel *)message;




#pragma mark - 用户行为记录入库
//存入
-(BOOL)saveXinWei_UserBehaviorModel:(XingWeiModel *)model;
-(BOOL)clearnXinWeiTable;
/**获取所有用户行为缓存*/
-(NSArray <XingWeiModel *>*)loadAllUserBehavior;
@end
