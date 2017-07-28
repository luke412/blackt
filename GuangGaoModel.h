//
//  GuangGaoModel.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/20.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuangGaoModel : NSObject
/**标题*/
@property(nonatomic,copy)NSString *adTitle;
/**简介*/
@property(nonatomic,copy)NSString *adIntro;
/**内容*/
@property(nonatomic,copy)NSString *adContent;
/**发布时间 yyyy-MM-dd HH:mm:ss格式*/
@property(nonatomic,copy)NSString *adPublishDate;
/**图片 http://xxx.jpg*/
@property(nonatomic,copy)NSString *adPicture;
/**跳转URL地址*/
@property(nonatomic,copy)NSString *adHyperlink;
@end
