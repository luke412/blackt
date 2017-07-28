//  QiDongYeModel.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/26.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  启动页模型

#import "QiDongYeModel.h"

@implementation QiDongYeModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.adId)            forKey:@"adId"];
    [aCoder encodeObject:self.adTitle            forKey:@"adTitle"];
    [aCoder encodeObject:self.adPicture          forKey:@"adPicture"];
    [aCoder encodeObject:self.adHyperlink        forKey:@"adHyperlink"];
    [aCoder encodeObject:@(self.showSeconds)     forKey:@"showSeconds"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.adId        = [[aDecoder decodeObjectForKey:@"adId"] integerValue];
        self.adTitle     = [aDecoder decodeObjectForKey:@"adTitle"];
        self.adPicture   = [aDecoder decodeObjectForKey:@"adPicture"];
        self.adHyperlink = [aDecoder decodeObjectForKey:@"adHyperlink"];
        self.showSeconds = [[aDecoder decodeObjectForKey:@"showSeconds"] integerValue];
    }
    return self;
}
@end
