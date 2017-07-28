//
//  FriendModel.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/17.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "FriendModel.h"

@implementation FriendModel
-(NSString *)description{
   
    NSString *str = [NSString stringWithFormat:@"用户id:%ld  昵称：%@  是不是我好友:%ld",self.passiveUserId,self.userNickname,self.isMyFriend];
    return str;
}

@end
