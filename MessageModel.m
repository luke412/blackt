//
//  MessageModel.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/5/13.
//  Copyright © 2017年 鲁柯. All rights reserved.
#import "MessageModel.h"
@implementation MessageModel
#pragma mark - 本地化 编码
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.idStr           forKey:@"idStr"];
    [aCoder encodeObject:self.text            forKey:@"text"];
    [aCoder encodeObject:self.title           forKey:@"title"];
    [aCoder encodeObject:self.timeStr         forKey:@"timeStr"];
    [aCoder encodeObject:self.isRead          forKey:@"isRead"];
    [aCoder encodeObject:self.customKey       forKey:@"customKey"];
    [aCoder encodeObject:self.customUrlKey    forKey:@"customUrlKey"];
    [aCoder encodeObject:self.diagnosisId     forKey:@"diagnosisId"];
    [aCoder encodeObject:self.createTimeKey   forKey:@"createTimeKey"];
    [aCoder encodeObject:self.headlineKey     forKey:@"headlineKey"];
    [aCoder encodeObject:self.descriptionKey  forKey:@"descriptionKey"];
    [aCoder encodeObject:self.introPicKey     forKey:@"introPicKey"];


}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.idStr          = [aDecoder decodeObjectForKey:@"idStr"];
        self.text           = [aDecoder decodeObjectForKey:@"text"];
        self.title          = [aDecoder decodeObjectForKey:@"title"];
        self.timeStr        = [aDecoder decodeObjectForKey:@"timeStr"];
        self.isRead         = [aDecoder decodeObjectForKey:@"isRead"];
        self.customKey      = [aDecoder decodeObjectForKey:@"customKey"];
        self.customUrlKey   = [aDecoder decodeObjectForKey:@"customUrlKey"];
        self.diagnosisId    = [aDecoder decodeObjectForKey:@"diagnosisId"];

        self.createTimeKey  = [aDecoder decodeObjectForKey:@"createTimeKey"];
        self.headlineKey    = [aDecoder decodeObjectForKey:@"headlineKey"];
        self.descriptionKey = [aDecoder decodeObjectForKey:@"descriptionKey"];
        self.introPicKey    = [aDecoder decodeObjectForKey:@"introPicKey"];

    }
    return self;
}

@end
