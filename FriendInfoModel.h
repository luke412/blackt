//
//  FriendInfoModel.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/18.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendInfoModel : NSObject
/** 用户ID Long类型 */
@property(nonatomic,assign)NSInteger friendUserId;

/** 用户昵称*/
@property(nonatomic,copy)NSString *userNickname;

/** 用户手机号 */
@property(nonatomic,copy)NSString *userMobile;

/** 用户I头像 */
@property(nonatomic,copy)NSString *userImage;
@end
