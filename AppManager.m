//
//  AppManager.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/6.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  app管理者

#import "AppManager.h"
#import "DataBaseManager.h"
#import "SFHFKeychainUtils.h"
#import <sys/utsname.h>


@implementation AppManager
-(void)Initialization{
    //当前设备
    NSArray <DeviceModel *>* devices = [DataBase_Manager getAllBoundDevice];
    if (devices.count >0) {
        self.currDevice = devices[0];
    }
}

-(NSString *)getDeviceId{
    NSString *deviceId = [UserDefaultsUtils getObjectWithKey:@"deviceId"];
    if (!deviceId) {
        deviceId =  [SFHFKeychainUtils getPasswordForUsername:USER_NAME
                                               andServiceName:SERVICE_NAME_deviceId
                                                        error:nil];
    }
    if (deviceId.length<1||deviceId==nil){//如果没取到 创建 我的UUID
        
        //创建 我的UUID
        NSDate * date        = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval time  = [date timeIntervalSince1970]*1000;
        NSString *timeString = [NSString stringWithFormat:@"%f", time];//转为字符型
        
        //拼接随机数，减少重复出现的可能
        int x = arc4random() % 10000;
        NSString *LK_UUID=[NSString stringWithFormat:@"%@LK%d",timeString,x];
        //新“设备号”写入钥匙串
        [SFHFKeychainUtils storeUsername:USER_NAME
                             andPassword:LK_UUID
                          forServiceName:SERVICE_NAME_deviceId
                          updateExisting:YES
                                   error:nil];
        deviceId = [SFHFKeychainUtils getPasswordForUsername:USER_NAME
                                              andServiceName:SERVICE_NAME_deviceId
                                                       error:nil];
    }
    if (deviceId.length>5) {
        LKLog(@"deviceId读取钥匙串成功.");
        [UserDefaultsUtils saveValue:deviceId forKey:@"deviceId"];
    }else{
        LKLog(@"deviceId读取钥匙失败.");
    }
    
    return deviceId;
}

#pragma mark - 存取userid
-(NSString *)getUserId{
    NSString *UserId = [UserDefaultsUtils getObjectWithKey:SERVICE_NAME_userId];
    if (UserId.length>0) {
        LKLog(@"UserId读取钥匙串成功.");
    }else{
        LKLog(@"UserId读取钥匙失败.");
    }
    
    return UserId;
}
-(void)saveUserId_Id:(NSString *)userId{
    //存本地
    [UserDefaultsUtils saveValue:userId forKey:SERVICE_NAME_userId];
}

#pragma mark - 存取token
-(void)saveUserToken_Token:(NSString *)token{
    //token写入钥匙串
    [SFHFKeychainUtils storeUsername:USER_NAME
                         andPassword:token
                      forServiceName:SERVICE_NAME_tokenId
                      updateExisting:YES
                               error:nil];
    
    [UserDefaultsUtils saveValue:token forKey:SERVICE_NAME_tokenId];
}


-(NSString *)getUserToken{
    NSString *Token  = [UserDefaultsUtils getObjectWithKey:SERVICE_NAME_tokenId];
    if (Token.length == 0 ||Token == nil) {
        Token = [SFHFKeychainUtils   getPasswordForUsername:USER_NAME
                                             andServiceName:SERVICE_NAME_tokenId
                                                      error:nil];
        if (Token.length == 0 ||Token == nil) {
            Token = @"";
        }
    }
    if (Token.length>2) {
        LKLog(@"Token读取钥匙串成功.");
        [UserDefaultsUtils saveValue:Token forKey:SERVICE_NAME_tokenId];
    }else{
        LKLog(@"Token读取钥匙失败.");
    }
    return Token;
}





- (NSString *)iphoneType {

    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";

    platform = @"iphone_unknow";
    
    return platform;
    
}


@end
