//
//  Url.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/4.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  接口

#ifndef Url_h
#define Url_h


#ifdef DEBUG
#define  SERVICE_URL            @"https://app.aikalife.com:9095/app/v1"     //测试环境 服务器地址
#else
#define  SERVICE_URL            @"https://app.aikalife.com:9095/app/v1"          //生产环境 服务器地址
#endif


/**短信验证码登录接口*/
#define SMSYanZhengMaLog_in_URL     @"/user/loginByMobile"

/**获取验证码*/
#define GetYanZhengMa_URL           @"/user/sendSms"

/**退出登录*/
#define LogOut_URL                  @"/user/signOut"

/**我的账号信息*/
#define GetMyInfo_URL               @"/user/userInfo"

/** 绑定蓝牙模组 */
#define MacBind_URL                 @"/macBind/bindOperate"

/** 获取所有的预制一键理疗方案 */
#define GetAllYuZhiPlan_URL         @"/treatment/getAllOnekeyTreatment"

/**获取指定id一键理疗方案的详情*/
#define GetPlanXiangQing_URL        @"/treatment/getOnekeyTreatment"

/**上传个人头像*/
#define upLoadUserTouXiangImage_URL @"/user/uploadUserImage"

/**根据手机号查找用户*/
#define  searchByMobile_URL         @"/userFriend/searchByMobile"


/**向某用户发出加好友请求*/
#define  addFriendRequest_URL       @"/userFriend/addFriendRequest"


/**响应用户的加好友请求*/
#define  addFriendResponse_URL      @"/userFriend/addFriendResponse"

#pragma mark -                      行为上报
/**每日上报*/
#define  meiRiShangBo_URL           @"/user/uploadLogin"

/**行为记录*/
#define xingWeiJiLu_URL             @"/behaviorHeat/addList"

/**获取所有可见好友*/
#define getAllCanSeeFriend_URL      @"/userFriend/getMyShareFriend"

/**隐身*/
#define yinShen_URL                 @"/userFriend/changeLocationShare"

/**查询最新广告*/
#define zuiXinGuangGao_URL          @"/merchantAd/getLatestAd"

/** 查询伪启动页*/
#define WeiQiDongYe_URL             @"/merchantAd/getStartPage"
#endif /* Url_h */
