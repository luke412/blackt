//
//  UserDefaultsUtils.m
//  ZLYDoc
//
//  Created by Ryan on 14-4-1.
//  Copyright (c) 2014年 ZLY. All rights reserved.
//

#import "UserDefaultsUtils.h"

@implementation UserDefaultsUtils
+(BOOL)iscHanYu{
    NSString *yuYanStr =  [UserDefaultsUtils getUserSystemLanguage];
    if ([yuYanStr hasPrefix:@"zh-Hans"]) {
        return YES;
    }else{
        return  NO;
    }
}
+(NSString *)getUserSystemLanguage{
    //获取当前的系统语言设置
      NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
      NSArray *languages        = [defaults objectForKey:@"AppleLanguages"];
      NSString *currentLanguage = [languages objectAtIndex:0];
    NSLog(@"%@",currentLanguage);
    return currentLanguage;
}
+(NSString *)loadLageuageTextWithKey:(NSString *)key{
   NSString *currentLanguage =  [self getUserSystemLanguage];
    //如果是汉语直接返回
    if ([currentLanguage hasPrefix:@"zh-Hans"]) {
        return key;
    }
    else{
        
        NSString *strTest = NSLocalizedString(key,@"");
        return strTest;
    }
}

#pragma mark - 存取图片
+(UIImage *)getImageWithKey:(NSString *)key{
    NSData *_data = [self getObjectWithKey:key];
    if (!_data) {
        return nil;
    }
    UIImage *_decodedImage      = [UIImage imageWithData:_data];
    return  _decodedImage;
}

+(void)saveImage:(UIImage *)image withKey:(NSString *)key{
    NSData *_data = UIImageJPEGRepresentation(image, 1.0f);
    [self saveValue:_data forKey:key];
}


+(void)saveValue:(id) value forKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

+(id)getObjectWithKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

+(BOOL)boolValueWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}

+(void)saveBoolValue:(BOOL)value withKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}

+(void)print{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    LKLog(@"%@",dic);
}

/**存取用户信息*/
+(void)saveUserInfo_UserModel:(UserInfoModel*)infoModel{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData * data                = [NSKeyedArchiver archivedDataWithRootObject:infoModel];
    [userDefaults setObject:data forKey:@"userInfo"];
    [userDefaults synchronize];
}
+(UserInfoModel *)getCacheUserInfo{
    NSData * data1            = [[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"];
    UserInfoModel * userModel = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    return userModel;
}

+(void)saveUpLoadDate:(NSString *)UpLoadDateStr{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:UpLoadDateStr forKey:@"UpLoadDateStr"];
    [userDefaults synchronize];

}
+(NSString *)getCacheUpLoadDate{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"UpLoadDateStr"];
}

+(void)saveQiDongYe_Model:(QiDongYeModel*)qiDongYeModel{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData * data                = [NSKeyedArchiver archivedDataWithRootObject:qiDongYeModel];
    [userDefaults setObject:data forKey:@"QDY"];
    [userDefaults synchronize];

}
+(QiDongYeModel *)getCacheQiDongYeInfo{
    NSData * data1            = [[NSUserDefaults standardUserDefaults] valueForKey:@"QDY"];
    QiDongYeModel * userModel = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    return userModel;
}
@end
