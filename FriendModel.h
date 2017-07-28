//
//  FriendModel.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/17.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject
#pragma mark - 追加参数
/** 手机号*/
@property(nonatomic,copy)NSString *phoneNum;



/** 用户id*/
@property(nonatomic,assign)NSInteger passiveUserId;

/**用户昵称*/
@property(nonatomic,copy)NSString *userNickname;

/**用户头像*/
@property(nonatomic,copy)NSString *userImage;

/**是不是我的好友  0 不是  1是*/
@property(nonatomic,assign)NSInteger isMyFriend;
@end
