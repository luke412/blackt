//
//  LKPopupWindowManager.h
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/30.
//  Copyright © 2016年 鲁柯. All rights reserved.

#import "DOSingleton.h"
@interface LKPopupWindowManager : DOSingleton
@property (nonatomic,strong)NSMutableDictionary *nameDictionary;
@property (nonatomic,strong)NSMutableDictionary *setTempDictionary;  //存放设定温度


/*
 *  向同步名称字典添加值
 *  返回值：无
 */
-(void)addDeviceToNameDictionaryWithMac:(NSString *)mac andName:(NSString *)name;
/*
 *  从同步名称字典添加值
 *  返回值：无
 */
-(void)deleteDeviceForNameDictionaryWithMac:(NSString *)mac;
/*
 *  同步设备的名称缓存字典
 *  返回值：无
 */
-(void)synchronousNameDictionary;


/*
 *  衣物已经存在
 *  应用场景:绑定衣物的时候，衣物已经在之前绑定过，在数据库中已经存在
 */
-(void)showPopupWindow_clothesIsHasBeen_WithVC:(UIViewController *)target;

/*
 *  绑定衣物失败，原因未知
 *  errorCode:  错误码，用户反馈时，提供错误码便于定位错误
 *  应用场景:绑定衣物的时候，衣物已经在之前绑定过，在数据库中已经存在
 */
-(void)showPopupWindow_Error_WithVC:(UIViewController *)target andError:(NSString *)errorCode;
-(void)showPopupWindow_withMessage:(UIViewController *)target andMessage:(NSString *)Message;
@end
