//
//  UserInfoModel.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/12.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "DOSingleton.h"

@interface UserInfoModel : NSObject <NSCoding>

/**用户ID*/
@property(nonatomic,copy)NSString *userId;

/** 用户令牌*/
@property(nonatomic,copy) NSString *userToken;

/**昵称*/
@property(nonatomic,copy)NSString *userNickname;
/**用户名*/
@property(nonatomic,copy)NSString *userName;
/**手机号*/
@property(nonatomic,copy)NSString *userMobile;
/**邮箱*/
@property(nonatomic,copy)NSString *userEmail;
/**登录密码*/
@property(nonatomic,copy)NSString *loginPwd;
/** 注册方式 1用户名2手机号3邮箱4QQ5微信6微博 */
@property(nonatomic,copy)NSString *registrationType;

/**头像地址*/
@property(nonatomic,copy)NSString *userImage;

/**同不同意好友查看 0同意看  1不同意*/
@property(nonatomic,assign)NSInteger locationShare;

/** 用户所属商户 */
@property(nonatomic,copy)NSString *merchantName;

/** 此用户所属商户ID  */
@property(nonatomic,assign)NSInteger merchantId;


@end
