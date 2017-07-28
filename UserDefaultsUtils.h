//
//  UserDefaultsUtils.h
//  ZLYDoc
//  键值对操作
//  Created by Ryan on 14-4-1.
//  Copyright (c) 2014年 ZLY. All rights reserved.
//

//多语言常用宏
#define  LK(key)           [UserDefaultsUtils loadLageuageTextWithKey:key]
#define  QI_DONG_YE_imageKey   @"image"
#import <Foundation/Foundation.h>

@class UserInfoModel;
@class QiDongYeModel;


@interface UserDefaultsUtils : NSObject
/**存取图片*/
+(UIImage *)getImageWithKey:(NSString *)key;
+(void)saveImage:(UIImage *)image withKey:(NSString *)key;

/**获取系统语言设置 */
+(NSString *)getUserSystemLanguage;
+(BOOL)iscHanYu;

/**通过key取到相应的字符 （多语言）*/
+(NSString *)loadLageuageTextWithKey:(NSString *)key;

/**存取对象*/
+(void)saveValue:(id) value forKey:(NSString *)key;
+(id)getObjectWithKey:(NSString *)key;
+(BOOL)boolValueWithKey:(NSString *)key;
+(void)saveBoolValue:(BOOL)value withKey:(NSString *)key;
+(void)print;


/**存取用户信息*/
+(void)saveUserInfo_UserModel:(UserInfoModel*)infoModel;
+(UserInfoModel *)getCacheUserInfo;

/**存储上报日期 用来查重*/
+(void)saveUpLoadDate:(NSString *)UpLoadDateStr;
+(NSString *)getCacheUpLoadDate;

/** 存储为启动页信息  */
+(void)saveQiDongYe_Model:(QiDongYeModel*)qiDongYeModel;
+(QiDongYeModel *)getCacheQiDongYeInfo;

@end
