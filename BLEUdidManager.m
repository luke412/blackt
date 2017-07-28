//
//  BLEUdidManager.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/7.
//  Copyright © 2017年 鲁柯. All rights reserved.
//
#import "BLEUdidManager.h"
@interface BLEUdidManager ()
@property(nonatomic,strong)FMDatabase     *fmdb;
@end

@implementation BLEUdidManager

/**存入uuid到数据库*/
//TODO 记录蓝牙缓存
-(BOOL)saveUUIDToDataBase_mac:(NSString *)mac andUUID:(NSUUID *)uuid{
    NSString *uuidStr = [uuid UUIDString];
    NSString * sql = @"insert into BLEUdidTable(deviceMac,BLEUdid) values (?,?)";
    
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/BlackT.db"];
        NSLog(@"数据库地址:%@",path);
        self.fmdb = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk=[self.fmdb open];
    if (!isOpenOk) {
        NSLog(@"数据库打开失败了！！！");
    }
    BOOL isSuccess = [self.fmdb executeUpdate:sql,mac,uuidStr];
        if(isSuccess)
            {
                    NSLog(@"数据插入成功");
            
        }
        else
            {
                    NSLog(@"数据插入失败%@",self.fmdb.lastErrorMessage);
            
            
        }
    
    return isSuccess;
}

/**从数据库中取uuid*/
-(NSUUID *)getUUIDFromDataBase_mac:(NSString *)mac{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/BlackT.db"];
    NSLog(@"数据库地址:%@",path);
    self.fmdb      = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk=[self.fmdb open];
    if (!isOpenOk) {
        NSLog(@"展示uuid信息---数据库打开失败了！！！");
    }
    
    NSString    * sql    = @"select * from BLEUdidTable where deviceMac = ?";
    FMResultSet * result = [self.fmdb executeQuery:sql,mac];
    NSString    * uuidStr;
    NSUUID      *uuid;
        if([result next])
            {
            uuidStr      = [result stringForColumn:@"BLEUdid"];
            uuid = [[NSUUID alloc]initWithUUIDString:uuidStr];
            
                }
    
    
    BOOL iscloseOk=[self.fmdb close];
    if (!iscloseOk) {
        NSLog(@"关闭数据库失败");
    }
    return uuid;
}

//-(void)clearUdid_mac:(NSString *)
@end

