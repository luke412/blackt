
//
//  LKDataBaseTool.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/26.
//  Copyright © 2016年 鲁柯. All rights reserved.
//

#import "LKDataBaseTool.h"
#import "ClothesModel.h"
@implementation LKDataBaseTool
-(BOOL)createDataBaseAndCreateTable{
    self.macArray       = [[NSMutableArray      alloc]init];
    
    NSLog(@"mac数组初始化成功");
    
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/ClothesDB.db"];
        NSLog(@"数据库地址:%@",path);
        self.fmdb = [[FMDatabase alloc]initWithPath:path];
        BOOL isOpen = [self.fmdb open];
        if(isOpen)
            {
                    NSLog(@"数据库打开成功");
                    NSString * sql = @"create table if not exists MyClothes(MacAddress varchar(256) primary key,clothName varchar(256),clothStyle varchar(256))";//mac地址  衣服名字
                    BOOL isSuccess = [self.fmdb executeUpdate:sql];
                    if(isSuccess)
                        {
                                NSLog(@"表格创建成功");
                        }
                    else
                        {
                                NSLog(@"表格创建失败%@",self.fmdb.lastErrorMessage);
                        }
                    
             }
        else
            {
                    NSLog(@"数据库打开失败%@",self.fmdb.lastErrorMessage);
        }
    [self.fmdb close];//关闭数据库
    return NO;
}

-(NSArray *)isExistInTheTable:(NSString *)macAddress{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/ClothesDB.db"];
    NSLog(@"数据库地址:%@",path);
    self.fmdb = [[FMDatabase alloc]initWithPath:path];
   BOOL isOpenOk=[self.fmdb open];
    if (!isOpenOk) {
        NSLog(@"数据库打开失败了！！！");
    }
    NSString * sql = @"select * from MyClothes where MacAddress = ?";
    FMResultSet * result = [self.fmdb executeQuery:sql,macAddress];
    NSMutableArray *clothesArr=[[NSMutableArray alloc]init];
    while([result next])
        {
            ClothesModel *clothesModel=[[ClothesModel alloc]init];
            clothesModel.clothesName = [result stringForColumn:@"clothName"];
            clothesModel.clothesMac  =[result  stringForColumn:@"MacAddress"];
            clothesModel.clothesStyle  =[result  stringForColumn:@"clothStyle"];
            [clothesArr addObject:clothesModel];
        }
    
    return clothesArr;
}

-(NSString *)InsertedIntoTheTableWithMacAddress:(NSString *)macAddress andName:(NSString *)clothName andStyle:(NSString *)clothStyle{
        NSString *returnText;
        NSString * sql = @"insert into MyClothes(MacAddress,clothName,clothStyle) values (?,?,?)";
    
        NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/ClothesDB.db"];
        NSLog(@"数据库地址:%@",path);
        self.fmdb = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk=[self.fmdb open];
    if (!isOpenOk) {
        NSLog(@"数据库打开失败了！！！");
    }
    
    
        BOOL isSuccess = [self.fmdb executeUpdate:sql,macAddress,clothName,clothStyle];
        if(isSuccess)
            {
                    NSLog(@"数据插入成功");
                    returnText=@"成功";
                    //向名字记录字典中添加项目   同步数据到名称字典
                    [[LKPopupWindowManager sharedInstance] addDeviceToNameDictionaryWithMac:macAddress andName:clothName];
            
            
            }
        else
            {
                    NSLog(@"数据插入失败%@",self.fmdb.lastErrorMessage);
                    returnText=self.fmdb.lastErrorMessage;
            }
    
    return returnText;
}
-(BOOL)DeletedFromTheTable:(NSString *)macAddress{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/ClothesDB.db"];
    NSLog(@"数据库地址:%@",path);
    self.fmdb = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk=[self.fmdb open];
    if (!isOpenOk) {
        NSLog(@"数据库打开失败了！！！");
    }
    
    NSString * sql = @"delete from MyClothes where MacAddress = ?";
        BOOL isSuccess = [self.fmdb executeUpdate:sql,macAddress];
        if(isSuccess)
            {
                    NSLog(@"删除成功");
                    [[LKPopupWindowManager sharedInstance] deleteDeviceForNameDictionaryWithMac:macAddress];
            }
        else
        {
                    NSLog(@"删除失败%@",self.fmdb.lastErrorMessage);
        }
    return isSuccess;
}

-(NSArray <ClothesModel *>*)showAllDataFromTable:(NSString *)tableName{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/ClothesDB.db"];
    NSLog(@"数据库地址:%@",path);
    self.fmdb = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk=[self.fmdb open];
    if (!isOpenOk) {
        NSLog(@"展示数据库信息---数据库打开失败了！！！");
        
    }

        NSString * sql = @"select * from MyClothes";
        FMResultSet * result = [self.fmdb executeQuery:sql];
    
        NSMutableArray *clothesArr=[[NSMutableArray alloc]init];
        while([result next])
            {
                ClothesModel *tempModel=[[ClothesModel alloc]init];
                tempModel.clothesName=[result stringForColumn:@"clothName"];
                tempModel.clothesMac =[result stringForColumn:@"MacAddress"];
                tempModel.clothesStyle =[result stringForColumn:@"clothStyle"];
                [clothesArr addObject:tempModel];
        
            }
    
    BOOL iscloseOk=[self.fmdb close];
    if (!iscloseOk) {
        NSLog(@"关闭数据库失败");
    }
    return clothesArr;
}

-(BOOL)DeletedMultipleFromTheTable:(NSArray *)macAddressArr{
    BOOL isAllSuccess=NO;
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/ClothesDB.db"];
    NSLog(@"数据库地址:%@",path);
    self.fmdb = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk=[self.fmdb open];
    if (!isOpenOk) {
        NSLog(@"展示数据库信息---数据库打开失败了！！！");
    }
    //事务
     [self.fmdb beginTransaction];  //开启事务
            BOOL isRollBack = NO;
            @try {
                    for (int i = 0; i<macAddressArr.count; i++) {
                       NSString * sql = @"delete from MyClothes where MacAddress = ?";
                       BOOL isSuccess = [self.fmdb executeUpdate:sql,macAddressArr[i]];
                                if(isSuccess)
                                    {
                                            NSLog(@"删除成功");
                                                                               }
                                else{
                                            NSLog(@"删除失败%@",self.fmdb.lastErrorMessage);
                                    }
                        }
                }
            @catch (NSException *exception) {
                    isRollBack = YES;       //遇到异常
                    [self.fmdb rollback];  //回滚
                    NSLog(@"数据回滚");
                }
            @finally {  
                    if (!isRollBack) {  
                            [self.fmdb commit];   //提交事务
                            isAllSuccess=YES;
                     }
                }  
    BOOL iscloseOk=[self.fmdb close];
    if (!iscloseOk) {
        NSLog(@"关闭数据库失败");
    }

    if (isAllSuccess == YES) {
            [[LKPopupWindowManager sharedInstance].nameDictionary removeObjectsForKeys:macAddressArr];

    }
    return isAllSuccess;
}

-(BOOL)ModifytheNameFromTheTableWithMac:(NSString *)macAddress andNewName:(NSString *)newName andStyle:(NSString *)newStyle{
    BOOL isAllSuccess=NO;
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/ClothesDB.db"];
    NSLog(@"数据库地址:%@",path);
    self.fmdb = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk=[self.fmdb open];
    if (!isOpenOk) {
        NSLog(@"展示数据库信息---数据库打开失败了！！！");
    }
    
    NSString * sql = @"update MyClothes set clothName = ?,clothStyle = ? where MacAddress = ?";
        isAllSuccess = [self.fmdb executeUpdate:sql,newName,newStyle,macAddress];
        if(isAllSuccess)
            {
                    NSLog(@"修改成功");
                    [[LKPopupWindowManager sharedInstance] deleteDeviceForNameDictionaryWithMac:macAddress];
                    [[LKPopupWindowManager sharedInstance] addDeviceToNameDictionaryWithMac:macAddress andName:newName];
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

-(BOOL)DeleteTheTableWithName:(NSString *)tableName{
    BOOL isOK=NO;
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/ClothesDB.db"];
    NSLog(@"数据库地址:%@",path);
    self.fmdb = [[FMDatabase alloc]initWithPath:path];
    BOOL isOpenOk=[self.fmdb open];
    if (isOpenOk) {
        NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
        if ([self.fmdb executeUpdate:sqlstr])
        {
            NSLog(@"销毁原数据表失败");
            isOK=YES;
        }
        
    }
    BOOL iscloseOk=[self.fmdb close];
    if (!iscloseOk) {
        NSLog(@"关闭数据库失败");
    }

    return isOK;


}

-(NSString *)parsingQRcodeReturnMacWithQRStr:(NSString *)qrStr{
    NSArray *strArr=[qrStr componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"?&"]];
    NSString *mac;
    if (strArr.count<=1) {
        if ([qrStr hasPrefix:@"http://www."]) {
            NSLog(@"这是旧码，是链接:%@",qrStr);
        }else if(qrStr.length==12){
            NSLog(@"这是旧码，是mac:%@",qrStr);
            mac=qrStr;
        }
    }else if(strArr.count>1){
        NSLog(@"这是新码，它所包含的信息为：");
        for (int i=0;i<strArr.count; i++) {
            NSString *indexStr=strArr[i];
            if ([indexStr hasPrefix:@"mac="]){
                NSArray *arr=[indexStr componentsSeparatedByString:@"mac="];
                NSString *strlastObject=[arr lastObject];
                NSLog(@"mac:%@",strlastObject);
                mac=strlastObject;
            }
            if ([indexStr hasPrefix:@"tag="]){
                NSArray *arr=[indexStr componentsSeparatedByString:@"tag="];
                NSString *strlastObject=[arr lastObject];
                NSLog(@"tag:%@",strlastObject);
            }
            if ([indexStr hasPrefix:@"http"]){
                NSLog(@"链接:%@",indexStr);
            }
            
        }
        
    }else{
        NSLog(@"扫码出错");
    }

    return mac;
}
@end
