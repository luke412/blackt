


//
//  UserInfoModel.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/12.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userId              forKey:@"userId"];
    [aCoder encodeObject:self.userToken           forKey:@"userToken"];
    [aCoder encodeObject:self.userNickname        forKey:@"userNickname"];
    [aCoder encodeObject:self.userName            forKey:@"userName"];
    [aCoder encodeObject:self.userMobile          forKey:@"userMobile"];
    [aCoder encodeObject:self.userEmail           forKey:@"userEmail"];
    [aCoder encodeObject:self.loginPwd            forKey:@"loginPwd"];
    [aCoder encodeObject:self.registrationType    forKey:@"registrationType"];
    [aCoder encodeObject:self.userImage           forKey:@"userImage"];
    [aCoder encodeObject:@(self.locationShare)    forKey:@"locationShare"];
    [aCoder encodeObject:@(self.merchantId)       forKey:@"merchantId"];
    [aCoder encodeObject:self.merchantName        forKey:@"merchantName"];

    
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.userId           = [aDecoder decodeObjectForKey:@"userId"];
        self.userToken        = [aDecoder decodeObjectForKey:@"userToken"];
        self.userNickname     = [aDecoder decodeObjectForKey:@"userNickname"];
        self.userName         = [aDecoder decodeObjectForKey:@"userName"];
        self.userMobile       = [aDecoder decodeObjectForKey:@"userMobile"];
        self.userEmail        = [aDecoder decodeObjectForKey:@"userEmail"];
        self.loginPwd         = [aDecoder decodeObjectForKey:@"loginPwd"];
        self.registrationType = [aDecoder decodeObjectForKey:@"registrationType"];
        self.userImage        = [aDecoder decodeObjectForKey:@"userImage"];
        self.locationShare    = [[aDecoder decodeObjectForKey:@"locationShare"] integerValue];
        self.merchantId       = [[aDecoder decodeObjectForKey:@"merchantId"] integerValue];
        self.merchantName     = [aDecoder decodeObjectForKey:@"merchantName"];

    }
    return self;
}
@end
