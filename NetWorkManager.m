//
//  NetWorkManager.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/6.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "NetWorkManager.h"
#import "BaseNetModel.h"
#import "UserInfoModel.h"
#import "NSObject+YYModel.h"
#import "YiJianPlanListModel.h"
#import "YiJianPlanModel.h"
#import "HeatModel.h"
#import "FriendModel.h"
#import "XingWeiModel.h"
#import "FriendInfoModel.h"
#import "GuangGaoModel.h"
#import "QiDongYeModel.h"

@implementation NetWorkManager
+(instancetype)sharedInstance{
    NetWorkManager *manager = [super sharedInstance];
    static dispatch_once_t hanwanjie;
    dispatch_once(&hanwanjie, ^{
        [manager addNetworkObserver];
    });
    
    return manager;
}
#pragma mark 判断网络状态 - 网络监听
-(void)addNetworkObserver
{
    
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    [manger startMonitoring];
    //2.监听改变
    __weak typeof (self)weakSelf = self;
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown          = -1,
         AFNetworkReachabilityStatusNotReachable     = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        if (status==AFNetworkReachabilityStatusUnknown) {
            NSLog(@"未知");
            weakSelf.netWorkState = UNKNOW;
        }
        else if(status == AFNetworkReachabilityStatusNotReachable){
            NSLog(@"没有网络");
            weakSelf.netWorkState = MEI_WANG;
        }
        else if(status == AFNetworkReachabilityStatusReachableViaWWAN){
            NSLog(@"3G|4G");
            weakSelf.netWorkState = _3G4G;
        }
        else if(status == AFNetworkReachabilityStatusReachableViaWiFi){
            NSLog(@"WiFi");
            weakSelf.netWorkState = WIFI;
        }
        else{
            NSLog(@"网络判断出奇葩");
            weakSelf.netWorkState = QI_PA;
        }
    }];
    
}

#pragma mark - 获取所有题组信息
-(void)getYanZhengMa_userMobile:(NSString *)userMobile
                    smsSendtype:(NSString *)smsSendtype
                       deviceId:(NSString *)deviceId
                     Success:(void(^)(NSString *smsid))success
                    Abnormal:(void(^)(id responseObject))abnormal
                     Failure:(void(^)(NSError *error))failure{
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"userMobile"] = userMobile;
    parameters[@"smsSendtype"] = smsSendtype;
    parameters[@"deviceId"] = deviceId;
    BaseNetModel *model = [[BaseNetModel alloc]init];
    [model baseSendRequestWithDic:parameters andUrl:GetYanZhengMa_URL Success:^(id responseObject) {
        if (success) {
            NSDictionary *dic = responseObject[@"retContent"];
            //短信id
            NSString *smsid = dic[@"smsId"];
            success(smsid);
        }
    }Abnormal:^(id responseObject) {
        if (abnormal) {
            abnormal(responseObject);
        }
    }Failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


-(void)LogOut_userId:(NSString *)userId
           userToken:(NSString *)userToken
            deviceId:(NSString *)deviceId
             Success:(void(^)(id responseObject))success
            Abnormal:(void(^)(id responseObject))abnormal
             Failure:(void(^)(NSError *error))failure{
        NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
        parameters[@"userId"]            = userId;
        parameters[@"userToken"]         = userToken;
        parameters[@"deviceId"]          = deviceId;
        BaseNetModel *model              = [[BaseNetModel alloc]init];
        [model baseSendRequestWithDic:parameters andUrl:LogOut_URL Success:^(id responseObject) {
            if (success) {
                success(responseObject);
            }
        }Abnormal:^(id responseObject) {
            if (abnormal) {
                abnormal(responseObject);
            }
        }Failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
}

//登录
-(void)logIn_userMobile:(NSString *)userMobile
           loginSmsCode:(NSString *)loginSmsCode
                  smsId:(NSString *)smsId
               deviceId:(NSString *)deviceId
             deviceType:(NSString *)deviceType
                Success:(void(^)(NSString* token ,NSString *userId,NSInteger merchantId,NSString *merchantName))success
               Abnormal:(void(^)(id responseObject))abnormal
                Failure:(void(^)(NSError *error))failure{
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"userMobile"]        = userMobile;
    parameters[@"loginSmsCode"]      = loginSmsCode;
    parameters[@"smsId"]             = smsId;
    parameters[@"deviceId"]          = deviceId;
    parameters[@"deviceType"]        = deviceType;
    BaseNetModel *model              = [[BaseNetModel alloc]init];
    [model baseSendRequestWithDic:parameters andUrl:SMSYanZhengMaLog_in_URL Success:^(id responseObject) {
        if (success) {
            NSDictionary *dic      = responseObject[@"retContent"];
            NSString *token        = dic[@"userToken"];
            NSString *userId       = dic[@"userId"];
            NSInteger merchantId   = [dic[@"merchantId"] integerValue];
            NSString *merchantName = dic[@"merchantName"];
            success(token,userId,merchantId,merchantName);

        }
    }Abnormal:^(id responseObject) {
        if (abnormal) {
            abnormal(responseObject);
        }
    }Failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


-(void)getMyUserInfo_userId:(NSString *)userId
                  userToken:(NSString *)userToken
                   deviceId:(NSString *)deviceId
                    Success:(void(^)(UserInfoModel * infoModel))success
                   Abnormal:(void(^)(id responseObject))abnormal
                    Failure:(void(^)(NSError *error))failure{
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"userId"]            = userId;
    parameters[@"userToken"]         = userToken;
    parameters[@"deviceId"]          = deviceId;
    BaseNetModel *model              = [[BaseNetModel alloc]init];
    [model baseSendRequestWithDic:parameters andUrl:GetMyInfo_URL Success:^(id responseObject) {
        if (success) {
            NSDictionary *dic    = responseObject[@"retContent"];
            UserInfoModel *model = [UserInfoModel modelWithDictionary:dic];
            success(model);
        }
    }Abnormal:^(id responseObject) {
        if (abnormal) {
            abnormal(responseObject);
        }
    }Failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


-(void)macBind_userId:(NSString *)userId
            userToken:(NSString *)userToken
             deviceId:(NSString *)deviceId
                macNo:(NSString *)macNo
           bindStatus:(NSString *)bindStatus
              Success:(void(^)(id responseObject))success
             Abnormal:(void(^)(id responseObject))abnormal
              Failure:(void(^)(NSError *error))failure{

    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"userId"]            = userId;
    parameters[@"userToken"]         = userToken;
    parameters[@"deviceId"]          = deviceId;
    parameters[@"macNo"]             = macNo;
    parameters[@"bindStatus"]        = bindStatus;
    BaseNetModel *model              = [[BaseNetModel alloc]init];
    [model baseSendRequestWithDic:parameters andUrl:MacBind_URL  Success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    }Abnormal:^(id responseObject) {
        if (abnormal) {
            abnormal(responseObject);
        }
    }Failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


-(void)loadAllYuZhiPlan_userId:(NSString *)userId
                     userToken:(NSString *)userToken
                      deviceId:(NSString *)deviceId
                       Success:(void(^)(NSArray <YiJianPlanListModel *>* planArr))success
                      Abnormal:(void(^)(id responseObject))abnormal
                       Failure:(void(^)(NSError *error))failure{
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"userId"]            = userId;
    parameters[@"userToken"]         = userToken;
    parameters[@"deviceId"]          = deviceId;
    BaseNetModel *model              = [[BaseNetModel alloc]init];
    [model baseSendRequestWithDic:parameters andUrl:GetAllYuZhiPlan_URL  Success:^(id responseObject) {
        if (success) {
            
            NSDictionary *dic = responseObject[@"retContent"];
            NSArray *arr = dic[@"oneKeySchemeList"];
            NSMutableArray *planArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic1 in arr) {
                YiJianPlanListModel  *model = [YiJianPlanListModel modelWithDictionary:dic1];
                [planArr addObject:model];
            }
            success(planArr);
        }
    }Abnormal:^(id responseObject) {
        if (abnormal) {
            abnormal(responseObject);
        }
    }Failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

-(void)loadYiJianPlan_userId:(NSString *)userId
                   userToken:(NSString *)userToken
                    deviceId:(NSString *)deviceId
                    schemeId:(NSString *)schemeId
                     Success:(void(^)(YiJianPlanModel *model))success
                    Abnormal:(void(^)(id responseObject))abnormal
                     Failure:(void(^)(NSError *error))failure{
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"userId"]            = userId;
    parameters[@"userToken"]         = userToken;
    parameters[@"deviceId"]          = deviceId;
    parameters[@"schemeId"]          = schemeId;
    BaseNetModel *model              = [[BaseNetModel alloc]init];
    [model baseSendRequestWithDic:parameters andUrl:GetPlanXiangQing_URL  Success:^(id responseObject) {
        if (success) {
            NSDictionary *dic = responseObject[@"retContent"];
            YiJianPlanModel *model = [YiJianPlanModel modelWithDictionary:dic];
            NSArray *arr           = dic[@"treatmentTemperatureList"];
            NSMutableArray  *list  = [[NSMutableArray alloc]init];
            for (NSInteger i = 0; i< arr.count; i++) {
                NSDictionary *dic1 = arr[0];
                HeatModel *heatModel =[HeatModel modelWithDictionary:dic1];
                heatModel.index = i;
                [list addObject:heatModel];
            }
            model.treatmentTemperatureList = list;
            success(model);
        }
    }Abnormal:^(id responseObject) {
        if (abnormal) {
            abnormal(responseObject);
        }
    }Failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


-(void)upLoadUserTouXiangImage_userId:(NSString *)userId
                            userToken:(NSString *)userToken
                             deviceId:(NSString *)deviceId
                            userImage:(UIImage *)userImage
                              Success:(void(^)(id responseObject))success
                             Abnormal:(void(^)(id responseObject))abnormal
                              Failure:(void(^)(NSError *error))failure{
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"userId"]            = userId;
    parameters[@"userToken"]         = userToken;
    parameters[@"deviceId"]          = deviceId;
    
    //图片转64
    
    NSData *data = UIImageJPEGRepresentation(userImage, 0.7f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    parameters[@"userImage"]          = encodedImageStr;
    BaseNetModel *model              = [[BaseNetModel alloc]init];
    [model baseSendRequestWithDic:parameters andUrl:upLoadUserTouXiangImage_URL  Success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    }Abnormal:^(id responseObject) {
        if (abnormal) {
            abnormal(responseObject);
        }
    }Failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}


-(void)searchByMobile_userId:(NSString *)userId
                   userToken:(NSString *)userToken
                    deviceId:(NSString *)deviceId
                      mobile:(NSString *)mobile
                     Success:(void(^)(FriendModel *model))success
                    Abnormal:(void(^)(id responseObject))abnormal
                     Failure:(void(^)(NSError *error))failure{
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"userId"]            = userId;
    parameters[@"userToken"]         = userToken;
    parameters[@"deviceId"]          = deviceId;
    parameters[@"mobile"]             = mobile;
    BaseNetModel *model              = [[BaseNetModel alloc]init];
    [model baseSendRequestWithDic:parameters andUrl:searchByMobile_URL  Success:^(id responseObject) {
        if (success) {
            NSDictionary *dic = responseObject[@"retContent"];
            FriendModel *model = [FriendModel modelWithDictionary:dic];
            success(model);
        }
    }Abnormal:^(id responseObject) {
        if (abnormal) {
            abnormal(responseObject);
        }
    }Failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


-(void)sendAddFriendRequest_userId:(NSString *)userId
                         userToken:(NSString *)userToken
                          deviceId:(NSString *)deviceId
                     passiveUserId:(NSInteger)passiveUserId
                           Success:(void(^)(id responseObject))success
                          Abnormal:(void(^)(id responseObject))abnormal
                           Failure:(void(^)(NSError *error))failure{
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"userId"]            = userId;
    parameters[@"userToken"]         = userToken;
    parameters[@"deviceId"]          = deviceId;
    parameters[@"passiveUserId"]     = @(passiveUserId);
    BaseNetModel *model              = [[BaseNetModel alloc]init];
    [model baseSendRequestWithDic:parameters andUrl:addFriendRequest_URL  Success:^(id responseObject) {
        if (success) {
            NSDictionary *dic = responseObject[@"retContent"];
            success(dic);
        }
    }Abnormal:^(id responseObject) {
        if (abnormal) {
            abnormal(responseObject);
        }
    }Failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


-(void)addFriendResponse_userId:(NSString *)userId
                      userToken:(NSString *)userToken
                       deviceId:(NSString *)deviceId
                   activeUserId:(NSInteger)activeUserId
                       decision:(NSInteger)decision
                        Success:(void(^)(id responseObject))success
                       Abnormal:(void(^)(id responseObject))abnormal
                        Failure:(void(^)(NSError *error))failure{
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"userId"]            = userId;
    parameters[@"userToken"]         = userToken;
    parameters[@"deviceId"]          = deviceId;
    parameters[@"activeUserId"]      = @(activeUserId);
    parameters[@"decision"]          = @(decision);

    BaseNetModel *model              = [[BaseNetModel alloc]init];
    [model baseSendRequestWithDic:parameters andUrl:addFriendResponse_URL  Success:^(id responseObject) {
        if (success) {
            NSDictionary *dic = responseObject[@"retContent"];
            success(dic);
        }
    }Abnormal:^(id responseObject) {
        if (abnormal) {
            abnormal(responseObject);
        }
    }Failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


/**每日联网上报*/
-(void)meiRiShangBo_userId:(NSString *)userId
                 userToken:(NSString *)userToken
                  deviceId:(NSString *)deviceId
     geographicCoordinates:(NSString *)geographicCoordinates
                phoneModel:(NSString *)phoneModel
               phoneSystem:(NSString *)phoneSystem
                   Success:(void(^)(id responseObject))success
                  Abnormal:(void(^)(id responseObject))abnormal
                   Failure:(void(^)(NSError *error))failure{
    static BOOL isFinish  = YES;
    if (isFinish == NO) {
        return;
    }
    
    NSDate *date = [NSDate date];
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString  *currentDateStr  = [dateFormat stringFromDate:date];
    NSString *cacheDateStr     = [UserDefaultsUtils getCacheUpLoadDate];
    if ([cacheDateStr isEqualToString:currentDateStr]) {
        return;
    }
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"userId"]                = userId;
    parameters[@"userToken"]             = userToken;
    parameters[@"deviceId"]              = deviceId;
    parameters[@"geographicCoordinates"] = geographicCoordinates;
    parameters[@"phoneModel"]            = phoneModel;
    parameters[@"phoneSystem"]           = phoneSystem;
    BaseNetModel *netModel               = [[BaseNetModel alloc]init];
    isFinish = NO;
    [netModel baseSendRequestWithDic:parameters andUrl:meiRiShangBo_URL  Success:^(id responseObject) {
        [UserDefaultsUtils saveUpLoadDate:currentDateStr];
        isFinish = YES;
        if (success) {
            success(responseObject);
        }
    } Abnormal:^(id responseObject) {
        isFinish = YES;
        abnormal(responseObject);
    } Failure:^(NSError *error) {
        isFinish = YES;
        failure(error);
    }];
}


-(void)XingWeiUpLoad_jsonArray:(NSArray <XingWeiModel *>*)userBehaviorModelArr
                       Success:(void(^)(id responseObject))success
                      Abnormal:(void(^)(id responseObject))abnormal
                       Failure:(void(^)(NSError *error))failure{
    NSMutableArray *jsonArr = [[NSMutableArray alloc]init];
    for (XingWeiModel *userBeModel in userBehaviorModelArr) {
        [jsonArr addObject:userBeModel];
    }
    NSString *modelArrStr = [jsonArr modelToJSONString];
    LKLog(@"月:%@",modelArrStr);
    BaseNetModel *netModel           = [[BaseNetModel alloc]init];
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"jsonString"]        = modelArrStr;
    [netModel baseSendRequestWithDic:parameters
                              andUrl:xingWeiJiLu_URL
                             Success:^(id responseObject) {
                                        if (success) {
                                            success(responseObject);
                                        }
                                    }
                            Abnormal:^(id responseObject) {
                                        abnormal(responseObject);
                                    }
                             Failure:^(NSError *error) {
                                    failure(error);
                                }];
}



#pragma mark - 获取所有可见好友
-(void)loadAllCanSeeFriend_userId:(NSString *)userId
                        userToken:(NSString *)userToken
                         deviceId:(NSString *)deviceId
                          Success:(void(^)(NSArray<FriendInfoModel *>* friendList))success
                         Abnormal:(void(^)(id responseObject))abnormal
                          Failure:(void(^)(NSError *error))failure{
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"userId"]            = userId;
    parameters[@"userToken"]         = userToken;
    parameters[@"deviceId"]          = deviceId;
    BaseNetModel *model              = [[BaseNetModel alloc]init];
    [model baseSendRequestWithDic:parameters andUrl:getAllCanSeeFriend_URL  Success:^(id responseObject) {
        if (success) {
            NSDictionary *dic = responseObject[@"retContent"];
            NSArray *friendList = dic[@"friendList"];
            NSMutableArray *friendArr = [[NSMutableArray alloc]init];
            for (NSDictionary *subDic in friendList) {
                FriendInfoModel *model = [FriendInfoModel modelWithDictionary:subDic];
                [friendArr addObject:model];
            }
            success(friendArr);
        }
    }Abnormal:^(id responseObject) {
        if (abnormal) {
            abnormal(responseObject);
        }
    }Failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

-(void)yinShen_userId:(NSString *)userId
            userToken:(NSString *)userToken
             deviceId:(NSString *)deviceId
        locationShare:(NSInteger)locationShare  //0让看  1不让看
              Success:(void(^)(id responseObject))success
             Abnormal:(void(^)(id responseObject))abnormal
              Failure:(void(^)(NSError *error))failure{
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"userId"]            = userId;
    parameters[@"userToken"]         = userToken;
    parameters[@"deviceId"]          = deviceId;
    parameters[@"locationShare"]     = @(locationShare);
    
    BaseNetModel *model              = [[BaseNetModel alloc]init];
    [model baseSendRequestWithDic:parameters andUrl:yinShen_URL  Success:^(id responseObject) {
        if (success) {
            NSDictionary *dic = responseObject[@"retContent"];
            success(dic);
        }
    }Abnormal:^(id responseObject) {
        if (abnormal) {
            abnormal(responseObject);
        }
    }Failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


-(void)chaXunZuiXinGuangGao_userId:(NSString *)userId
                         userToken:(NSString *)userToken
                          deviceId:(NSString *)deviceId
                           Success:(void(^)(NSArray <GuangGaoModel *> *arr))success
                          Abnormal:(void(^)(id responseObject))abnormal
                           Failure:(void(^)(NSError *error))failure{
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"userId"]            = userId;
    parameters[@"userToken"]         = userToken;
    parameters[@"deviceId"]          = deviceId;
    
    BaseNetModel *model              = [[BaseNetModel alloc]init];
    [model baseSendRequestWithDic:parameters andUrl:zuiXinGuangGao_URL  Success:^(id responseObject) {
        if (success) {
            NSDictionary *dic = responseObject[@"retContent"];
            NSArray *arr = dic[@"adList"];
            NSMutableArray *list = [[NSMutableArray alloc]init];
            for (NSDictionary *dic2 in arr) {
                GuangGaoModel *model = [GuangGaoModel modelWithDictionary:dic2];
                [list addObject:model];
            }
            success(list);
        }
    }Abnormal:^(id responseObject) {
        if (abnormal) {
            abnormal(responseObject);
        }
    }Failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


-(void)weiQiDongYe_userId:(NSString *)userId
                userToken:(NSString *)userToken
                 deviceId:(NSString *)deviceId
                  Success:(void(^)(QiDongYeModel * model))success
                 Abnormal:(void(^)(id responseObject))abnormal
                  Failure:(void(^)(NSError *error))failure{
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"userId"]            = userId;
    parameters[@"userToken"]         = userToken;
    parameters[@"deviceId"]          = deviceId;
    
    BaseNetModel *model              = [[BaseNetModel alloc]init];
    [model baseSendRequestWithDic:parameters andUrl:WeiQiDongYe_URL  Success:^(id responseObject) {
        if (success) {
            NSDictionary *dic    = responseObject[@"retContent"];
            QiDongYeModel *model = [[QiDongYeModel alloc]init];
            model.adId           = [dic[@"adId"] integerValue];
            model.adTitle        = dic[@"adTitle"];
            model.adPicture      = dic[@"adPicture"];
            model.adHyperlink    = dic[@"adHyperlink"];
            model.showSeconds    = [dic[@"showSeconds"] integerValue];
            success(model);
        }
    }Abnormal:^(id responseObject) {
        if (abnormal) {
            abnormal(responseObject);
        }
    }Failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}
@end
