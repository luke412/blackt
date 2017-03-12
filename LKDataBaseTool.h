//
//  LKDataBaseTool.h
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/26.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  封装数据库操作

#import <Foundation/Foundation.h>
#import "DOSingleton.h"
@interface LKDataBaseTool : DOSingleton
@property(nonatomic,copy)NSString *showMac;
@property(nonatomic,strong)NSMutableArray *macArray;
@property(nonatomic,strong)FMDatabase     *fmdb;

/*
 *  创建数据库，并且创建表
 *  返回值：操作是否成功
 */
-(BOOL)createDataBaseAndCreateTable;
/*
 *  验证某mac地址是否存在于数据库表中   (该衣物是否绑定）
 *  返回值：表中符合条件的对象
 */
-(NSArray *)isExistInTheTable:(NSString *)macAddress;


/*
 *  向绑定表中添加记录               （新增绑定衣物）
 *  返回值：错误信息
 */
-(NSString *)InsertedIntoTheTableWithMacAddress:(NSString *)macAddress andName:(NSString *)clothName andStyle:(NSString *)clothStyle;



/*
 *  从绑定表中删除               （删除绑定衣物）
 *  返回值：是否删除成功
 */
-(BOOL)DeletedFromTheTable:(NSString *)macAddress;


/*
 *  从绑定表中批量删除               （删除绑定衣物）
 *  返回值：是否删除成功
 */
-(BOOL)DeletedMultipleFromTheTable:(NSArray *)macAddressArr;


/*
 *  展示指定表的所有数据
 *  返回值：表中的每行的记录数据
 */
-(NSArray <ClothesModel *> *)showAllDataFromTable:(NSString *)tableName;


/*
 *  修改表中的某条数据
 *  返回值：操作是否成功
 */
-(BOOL)ModifytheNameFromTheTableWithMac:(NSString *)macAddress andNewName:(NSString *)newName andStyle:(NSString *)newStyle;


/*
 *  删除表
 *  返回值：操作是否成功
 */
-(BOOL)DeleteTheTableWithName:(NSString *)tableName;


/*
 *  二维码mac解析判断
 *  返回值：返回mac，如果没有返回nil
 */
-(NSString *)parsingQRcodeReturnMacWithQRStr:(NSString *)qrStr;
@end
