//
//  MessageModel.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/5/13.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject <NSCoding>
/**
 *  数据库id  yyyy年MM月dd日 HH时mm分$ss秒
 */
@property(nonatomic,copy)NSString *idStr;
/** 内容 */
@property(nonatomic,copy)NSString *text;
/** 标题 */
@property(nonatomic,copy)NSString *title;

/**  yyyy年MM月dd日 HH时mm分 */
@property(nonatomic,copy)NSString *timeStr;
/** 是否已读 */
@property(nonatomic,copy)NSString * isRead;
/** 消息的分类 */
@property (nonatomic,copy)NSString *customKey;
/** 消息的url*/
@property (nonatomic,copy)NSString *customUrlKey;
/**方案id*/
@property (nonatomic,copy)NSString *diagnosisId;

//--------新增 2017-06-28
/**消息生成时间*/
@property(nonatomic,copy)NSString *createTimeKey;
/**大标题*/
@property(nonatomic,copy)NSString *headlineKey;
/**简介*/
@property(nonatomic,copy)NSString *descriptionKey;

/**占位图*/
@property(nonatomic,copy)NSString *introPicKey;

/** 主动方的userid */
@property(nonatomic,copy)NSString *activeUserIdKey;
@end
