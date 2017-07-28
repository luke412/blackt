//
//  NetWorkManager.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/6.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfoModel;
@class YiJianPlanListModel;
@class YiJianPlanModel;
@class FriendModel;
@class XingWeiModel;
@class FriendInfoModel;
@class GuangGaoModel;
@class QiDongYeModel;

@interface NetWorkManager : DOSingleton
@property (nonatomic,assign)int netWorkState;

/**获取验证码*/
-(void)getYanZhengMa_userMobile:(NSString *)userMobile
                    smsSendtype:(NSString *)smsSendtype
                       deviceId:(NSString *)deviceId
                        Success:(void(^)(NSString *smsid))success
                       Abnormal:(void(^)(id responseObject))abnormal
                        Failure:(void(^)(NSError *error))failure;




/**退出登录*/
-(void)LogOut_userId:(NSString *)userId
           userToken:(NSString *)userToken
            deviceId:(NSString *)deviceId
             Success:(void(^)(id responseObject))success
            Abnormal:(void(^)(id responseObject))abnormal
             Failure:(void(^)(NSError *error))failure;




/**登录*/
-(void)logIn_userMobile:(NSString *)userMobile
           loginSmsCode:(NSString *)loginSmsCode
                  smsId:(NSString *)smsId
               deviceId:(NSString *)deviceId
             deviceType:(NSString *)deviceType
                Success:(void(^)(NSString* token ,NSString *userId,NSInteger merchantId,NSString *merchantName))success
               Abnormal:(void(^)(id responseObject))abnormal
                Failure:(void(^)(NSError *error))failure;



/**获取个人信息*/
-(void)getMyUserInfo_userId:(NSString *)userId
                  userToken:(NSString *)userToken
                   deviceId:(NSString *)deviceId
                    Success:(void(^)(UserInfoModel * infoModel))success
                   Abnormal:(void(^)(id responseObject))abnormal
                    Failure:(void(^)(NSError *error))failure;


/**
 *  绑定蓝牙模组
 *
 *  @param userId     用户ID
 *  @param userToken  令牌
 *  @param deviceId   设备ID
 *  @param macNo      蓝牙模组MAC
 *  @param bindStatus 操作类型 0绑定1解绑
 */
-(void)macBind_userId:(NSString *)userId
            userToken:(NSString *)userToken
             deviceId:(NSString *)deviceId
                macNo:(NSString *)macNo
           bindStatus:(NSString *)bindStatus
              Success:(void(^)(id responseObject))success
             Abnormal:(void(^)(id responseObject))abnormal
              Failure:(void(^)(NSError *error))failure;


/** 加载所有预制一键理疗方案 */
-(void)loadAllYuZhiPlan_userId:(NSString *)userId
                     userToken:(NSString *)userToken
                      deviceId:(NSString *)deviceId
                       Success:(void(^)(NSArray <YiJianPlanListModel *>* planArr))success
                      Abnormal:(void(^)(id responseObject))abnormal
                       Failure:(void(^)(NSError *error))failure;

/** 获取指定id一键理疗详情 */
-(void)loadYiJianPlan_userId:(NSString *)userId
                   userToken:(NSString *)userToken
                    deviceId:(NSString *)deviceId
                    schemeId:(NSString *)schemeId
                     Success:(void(^)(YiJianPlanModel *model))success
                    Abnormal:(void(^)(id responseObject))abnormal
                     Failure:(void(^)(NSError *error))failure;

/**上传个人头像*/

-(void)upLoadUserTouXiangImage_userId:(NSString *)userId
                            userToken:(NSString *)userToken
                             deviceId:(NSString *)deviceId
                            userImage:(UIImage *)userImage
                              Success:(void(^)(id responseObject))success
                             Abnormal:(void(^)(id responseObject))abnormal
                              Failure:(void(^)(NSError *error))failure;


/**根据手机号查找用户*/
-(void)searchByMobile_userId:(NSString *)userId
                   userToken:(NSString *)userToken
                    deviceId:(NSString *)deviceId
                      mobile:(NSString *)mobile
                     Success:(void(^)(FriendModel *model))success
                    Abnormal:(void(^)(id responseObject))abnormal
                     Failure:(void(^)(NSError *error))failure;


/**向某用户发出加好友请求*/
-(void)sendAddFriendRequest_userId:(NSString *)userId
                         userToken:(NSString *)userToken
                          deviceId:(NSString *)deviceId
                         passiveUserId:(NSInteger)passiveUserId
                           Success:(void(^)(id responseObject))success
                          Abnormal:(void(^)(id responseObject))abnormal
                           Failure:(void(^)(NSError *error))failure;


/**
 *  响应加好友请求
 *
 *  @param userId       。
 *  @param userToken      。
 *  @param deviceId      。
 *  @param activeUserId 主动方的id
 *  @param decision     0同意1拒绝2永不接收
 */
-(void)addFriendResponse_userId:(NSString *)userId
                      userToken:(NSString *)userToken
                       deviceId:(NSString *)deviceId
                   activeUserId:(NSInteger)activeUserId
                       decision:(NSInteger)decision
                        Success:(void(^)(id responseObject))success
                       Abnormal:(void(^)(id responseObject))abnormal
                        Failure:(void(^)(NSError *error))failure;

#pragma mark - 行为上报
-(void)meiRiShangBo_userId:(NSString *)userId
                 userToken:(NSString *)userToken
                  deviceId:(NSString *)deviceId
     geographicCoordinates:(NSString *)geographicCoordinates
                phoneModel:(NSString *)phoneModel
               phoneSystem:(NSString *)phoneSystem
                   Success:(void(^)(id responseObject))success
                  Abnormal:(void(^)(id responseObject))abnormal
                   Failure:(void(^)(NSError *error))failure;

/**行为记录*/
-(void)XingWeiUpLoad_jsonArray:(NSArray <XingWeiModel *>*)userBehaviorModelArr
                             Success:(void(^)(id responseObject))success
                            Abnormal:(void(^)(id responseObject))abnormal
                             Failure:(void(^)(NSError *error))failure;


/**获取所有可见好友*/
-(void)loadAllCanSeeFriend_userId:(NSString *)userId
                        userToken:(NSString *)userToken
                         deviceId:(NSString *)deviceId
                          Success:(void(^)(NSArray<FriendInfoModel *>* friendList))success
                         Abnormal:(void(^)(id responseObject))abnormal
                          Failure:(void(^)(NSError *error))failure;


/**隐身*/
-(void)yinShen_userId:(NSString *)userId
            userToken:(NSString *)userToken
             deviceId:(NSString *)deviceId
        locationShare:(NSInteger)locationShare  //0让看  1不让看
              Success:(void(^)(id responseObject))success
             Abnormal:(void(^)(id responseObject))abnormal
              Failure:(void(^)(NSError *error))failure;



/** 查询最新广告 */
-(void)chaXunZuiXinGuangGao_userId:(NSString *)userId
                         userToken:(NSString *)userToken
                          deviceId:(NSString *)deviceId
                           Success:(void(^)(NSArray <GuangGaoModel *> *arr))success
                          Abnormal:(void(^)(id responseObject))abnormal
                           Failure:(void(^)(NSError *error))failure;



/** 查询伪启动页 */
-(void)weiQiDongYe_userId:(NSString *)userId
                userToken:(NSString *)userToken
                 deviceId:(NSString *)deviceId
                  Success:(void(^)(QiDongYeModel * model))success
                 Abnormal:(void(^)(id responseObject))abnormal
                  Failure:(void(^)(NSError *error))failure;

@end
