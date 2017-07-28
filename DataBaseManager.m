//
//  DataBaseManager.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/6.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  数据库操作管理者


#import "DataBaseManager.h"
#import "DeviceModel.h"

@interface DataBaseManager ()
@property(nonatomic,strong)FMDatabase     *fmdb;
@end

@implementation DataBaseManager
-(BOOL)createDataBaseAndCreateTable{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/BlackT.db"];
        NSLog(@"数据库地址:%@",path);
        self.fmdb = [[FMDatabase alloc]initWithPath:path];
        BOOL isOpen = [self.fmdb open];
        if(isOpen)
            {
                 NSLog(@"数据库打开成功");
            //建立衣物表
                 NSString * sql = @"create table if not exists LKClothes(MacAddress varchar(256) primary key,clothName varchar(256),deviceType varchar(256))";//mac地址  衣服名字
                    BOOL isSuccess = [self.fmdb executeUpdate:sql];
                    if(isSuccess)
                        {
                                NSLog(@"衣物表格创建成功");
                        }
                    else
                        {
                                NSLog(@"衣物表格创建失败%@",self.fmdb.lastErrorMessage);
                        }
            
            //建立消息表
            NSString * sql2 = @"create table if not exists MyNewMessage(MessageTimeStrId varchar(256) primary key,MessageData blob)";//mac地址  衣服名字
                    BOOL isSuccess2 = [self.fmdb executeUpdate:sql2];
                    if(isSuccess2)
                        {
                                NSLog(@"消息表格创建成功");
                        }
                    else
                        {
                                NSLog(@"消息表格创建失败%@",self.fmdb.lastErrorMessage);
                        }
            
            //建立蓝牙udid缓存表
            NSString * sql3 = @"create table if not exists BLEUdidTable(deviceMac varchar(256) primary key,BLEUdid varchar(256))";//mac地址  蓝牙UDID
                    BOOL isSuccess3 = [self.fmdb executeUpdate:sql3];
                    if(isSuccess3)
                        {
                                NSLog(@"蓝牙udid缓存表格创建成功");
                        }
                    else
                        {
                                NSLog(@"蓝牙udid缓存表格创建失败%@",self.fmdb.lastErrorMessage);
                        }
            
            //用户行为记录表
            NSString * sql4 = @"create table if not exists UserXingWeiTable(xingWeiId INTEGER primary key AUTOINCREMENT ,userModelData blob,date varchar(256))";//主键  行为模型数据 缓存日期
                    BOOL isSuccess4 = [self.fmdb executeUpdate:sql4];
                    if(isSuccess4)
                        {
                                NSLog(@"用户行为记录表创建成功");
                        }
                    else
                        {
                                NSLog(@"用户行为记录表创建失败%@",self.fmdb.lastErrorMessage);
                        }
            
            
             }
        else
            {
                    NSLog(@"数据库打开失败%@",self.fmdb.lastErrorMessage);
        }
    [self.fmdb close];//关闭数据库
    return NO;
}

/** 是否有已绑定设备 */
-(BOOL)isHaveBoundDevice{
    NSArray *arr = [self getAllBoundDevice];
    if (arr.count >0) {
        return YES;
    }else{
        return  NO;
    }
}
#pragma mark - 获取所有已绑设备
-(NSArray <DeviceModel *> *)getAllBoundDevice{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/BlackT.db"];
    NSLog(@"数据库地址:%@",path);
    self.fmdb = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk=[self.fmdb open];
    if (!isOpenOk) {
        NSLog(@"展示数据库信息---数据库打开失败了！！！");
    }
        NSString * sql = @"select * from LKClothes";
        FMResultSet * result = [self.fmdb executeQuery:sql];
    
    NSMutableArray *clothesArr=[[NSMutableArray alloc]init];
        while([result next])
            {
            DeviceModel *tempModel=[[DeviceModel alloc]init];
            tempModel.clothesName  =[result stringForColumn:@"clothName"];
            tempModel.clothesMac   =[result stringForColumn:@"MacAddress"];
            tempModel.deviceType   =[result stringForColumn:@"deviceType"];
            [clothesArr addObject:tempModel];
            
        }
    
    BOOL iscloseOk=[self.fmdb close];
    if (!iscloseOk) {
        NSLog(@"关闭数据库失败");
    }
    return clothesArr;
}

#pragma mark - 查看数据库是否缓存某mac
-(NSArray <DeviceModel *>*)isExistInTheTable:(NSString *)macAddress{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/BlackT.db"];
        NSLog(@"数据库地址:%@",path);
        self.fmdb = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk=[self.fmdb open];
    if (!isOpenOk) {
        NSLog(@"数据库打开失败了！！！");
    }
        NSString * sql       = @"select * from LKClothes where MacAddress = ?";
        FMResultSet * result = [self.fmdb executeQuery:sql,macAddress];
        NSMutableArray *clothesArr=[[NSMutableArray alloc]init];
        while([result next])
            {
            DeviceModel *device  = [[DeviceModel alloc]init];
            device.clothesName   = [result  stringForColumn:@"clothName"];
            device.clothesMac    = [result  stringForColumn:@"MacAddress"];
            device.deviceType    = [result  stringForColumn:@"deviceType"];
            [clothesArr addObject:device];
        }
    return clothesArr;
}

#pragma mark - 数据库添加设备
-(BOOL)addDeviceTodataBase_mac:(NSString *)mac andName:(NSString *)name andType:(NSString *)type{
    NSString * sql = @"insert into LKClothes(MacAddress,clothName,deviceType) values (?,?,?)";
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/BlackT.db"];
    NSLog(@"数据库地址:%@",path);
    self.fmdb = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk=[self.fmdb open];
    if (!isOpenOk) {
         NSLog(@"数据库打开失败了！！！");
    }

    BOOL isSuccess = [self.fmdb executeUpdate:sql,mac,name,type];
        if(isSuccess){
               NSLog(@"数据插入成功");
        }
        else{
              NSLog(@"数据插入失败%@",self.fmdb.lastErrorMessage);
        }
    
    return isSuccess;
}

/**删除设备*/
-(BOOL)DeletedFromTheTable:(NSString *)macAddress{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/BlackT.db"];
    NSLog(@"数据库地址:%@",path);
    self.fmdb = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk=[self.fmdb open];
    if (!isOpenOk) {
        NSLog(@"数据库打开失败了！！！");
    }
    
    NSString * sql = @"delete from LKClothes where MacAddress = ?";
        BOOL isSuccess = [self.fmdb executeUpdate:sql,macAddress];
        if(isSuccess)
            {
                    NSLog(@"删除成功");
            
        }
        else
            {
                    NSLog(@"删除失败%@",self.fmdb.lastErrorMessage);
        }
    return isSuccess;

}

#pragma mark - 修改名称
-(BOOL)XiuGai_mac:(NSString *)mac name:(NSString *)name{
    BOOL isAllSuccess = NO;
    NSString *path    = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/BlackT.db"];
    self.fmdb         = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk     = [self.fmdb open];
    if (!isOpenOk) {
         NSLog(@"展示数据库信息---数据库打开失败了！！！");
    }
    
    NSString * sql = @"update LKClothes set clothName = ? where MacAddress = ?";
        isAllSuccess = [self.fmdb executeUpdate:sql,name,mac];
        if(isAllSuccess)
            {
                    NSLog(@"修改成功");
            }
        else
            {
                    NSLog(@"修改失败%@",self.fmdb.lastErrorMessage);
           }
    BOOL iscloseOk=[self.fmdb close];
    if (!iscloseOk) {
        NSLog(@"关闭数据库失败");
    }
    
    return isAllSuccess;
}


#pragma mark - 消息
-(NSArray <MessageModel *>*)loadAllMessage{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/BlackT.db"];
    self.fmdb      = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk  = [self.fmdb open];
    if (!isOpenOk) {
        NSLog(@"展示数据库信息---数据库打开失败了！！！");
    }
    NSString    * sql          = @"select * from MyNewMessage";
    FMResultSet * result       = [self.fmdb executeQuery:sql];
    NSMutableArray *messageArr = [[NSMutableArray alloc]init];
    while([result next])
    {
        NSData *messageData        = [result dataForColumn:@"MessageData"];
        MessageModel *messageModel = [NSKeyedUnarchiver unarchiveObjectWithData:messageData];
        [messageArr addObject:messageModel];
    }
    
    BOOL iscloseOk=[self.fmdb close];
    if (!iscloseOk) {
        NSLog(@"关闭数据库失败");
    }
    return messageArr;
}

-(BOOL)lk_saveMessageToDataBase:(MessageModel *)message{
    NSString * sql = @"insert into MyNewMessage(MessageTimeStrId,MessageData) values (?,?)";
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/BlackT.db"];
    NSLog(@"数据库地址:%@",path);
    self.fmdb = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk=[self.fmdb open];
    if (!isOpenOk) {
        NSLog(@"数据库打开失败了！！！");
    }
    NSData * MessageData  = [NSKeyedArchiver archivedDataWithRootObject:message];
    BOOL isSuccess        = [self.fmdb executeUpdate:sql,message.idStr,MessageData];
        if(isSuccess)
    {
        NSLog(@"消息数据插入成功");
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        NSNotification *notify = [[NSNotification alloc]initWithName:@"RefreshXiaoXi" object:@"添加" userInfo:nil];
        [nc postNotification:notify];
    }
    else
    {
          NSLog(@"消息数据插入失败%@",self.fmdb.lastErrorMessage);
    }
    return isSuccess;
}


-(BOOL)lk_xiuGaiReadStateWithMessage:(MessageModel *)message{
    BOOL isAllSuccess = NO;
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/BlackT.db"];
    NSLog(@"数据库地址:%@",path);
    self.fmdb = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk=[self.fmdb open];
    if (!isOpenOk) {
        NSLog(@"展示数据库信息---数据库打开失败了！！！");
    }
    
    NSString * sql       = @"update MyNewMessage set MessageData = ? where MessageTimeStrId = ?";
    NSData * MessageData = [NSKeyedArchiver archivedDataWithRootObject:message];
    isAllSuccess         = [self.fmdb executeUpdate:sql,MessageData,message.idStr];
        if(isAllSuccess)
            {
                NSLog(@"修改成功");
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            NSNotification *notify = [[NSNotification alloc]initWithName:@"RefreshXiaoXi" object:@"修改" userInfo:nil];
            [nc postNotification:notify];
            
        }
        else
            {
                    NSLog(@"修改失败%@",self.fmdb.lastErrorMessage);
        }
    BOOL iscloseOk=[self.fmdb close];
    if (!iscloseOk) {
        NSLog(@"关闭数据库失败");
    }
    return isAllSuccess;
}

/**清空表*/
-(BOOL)clearTheTableWithName:(NSString *)tableName{
    BOOL isOK=NO;
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/BlackT.db"];
    NSLog(@"数据库地址:%@",path);
    self.fmdb     = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk = [self.fmdb open];
    if (isOpenOk) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
        if ([self.fmdb executeUpdate:sqlstr])
        {
            NSLog(@"清空原数据表成功");
            isOK=YES;
        }
        
    }
    BOOL iscloseOk=[self.fmdb close];
    if (!iscloseOk) {
        NSLog(@"关闭数据库失败");
    }
    return isOK;
}


#pragma mark - 用户行为记录入库
/**获取所有缓存行为*/
-(NSArray <XingWeiModel *>*)loadAllUserBehavior{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/BlackT.db"];
    NSLog(@"数据库地址:%@",path);
    self.fmdb = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk=[self.fmdb open];
    if (!isOpenOk) {
        NSLog(@"展示用户行为数据库信息---数据库打开失败！！！");
    }
    
        NSString * sql = @"select * from UserXingWeiTable";
        FMResultSet * result = [self.fmdb executeQuery:sql];
    
    NSMutableArray *userBehaviorModelArr=[[NSMutableArray alloc]init];
        while([result next])
            {
            NSData *modelDate = [result dataForColumn:@"userModelData"];
            XingWeiModel *xingWeiModel = [NSKeyedUnarchiver unarchiveObjectWithData:modelDate];
            [userBehaviorModelArr addObject:xingWeiModel];
        }
    
    BOOL iscloseOk=[self.fmdb close];
    if (!iscloseOk) {
        NSLog(@"关闭数据库失败");
    }
    return userBehaviorModelArr;
}
/** 用户行为存入数据 */
-(BOOL)saveXinWei_UserBehaviorModel:(XingWeiModel *)model{
    
    NSString * sql = @"insert into UserXingWeiTable(userModelData,date) values (?,?)";
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/BlackT.db"];
    NSLog(@"数据库地址:%@",path);
    self.fmdb = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk=[self.fmdb open];
    if (!isOpenOk) {
        NSLog(@"数据库打开失败了！！！");
    }
    
    NSData * userModelData  = [NSKeyedArchiver archivedDataWithRootObject:model];
    NSDate *newDate         = [NSDate date];
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr  = [dateFormat stringFromDate:newDate];
    
    BOOL isSuccess        = [self.fmdb executeUpdate:sql,userModelData,currentDateStr];
      if(isSuccess)
    {
        LKLog(@"行为数据插入成功");
        
    }
    else
    {
           LKLog(@"行为数据插入失败%@",self.fmdb.lastErrorMessage);
    }
    return isSuccess;
}
-(BOOL)clearnXinWeiTable{
    BOOL isOK=NO;
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/BlackT.db"];
    self.fmdb = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk=[self.fmdb open];
    if (isOpenOk) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM UserXingWeiTable"];
        if ([self.fmdb executeUpdate:sqlstr])
        {
            NSLog(@"清空行为表成功");
            isOK=YES;
        }
        
    }
    BOOL iscloseOk=[self.fmdb close];
    if (!iscloseOk) {
        NSLog(@"关闭数据库失败");
    }
    
    return isOK;
}

@end
