//
//  LKKPointAnnotation.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/21.
//  Copyright © 2017年 鲁柯. All rights reserved.
//
#import <UIKit/UIKit.h>
@class LocationModel;
@interface LKKPointAnnotation : BMKPointAnnotation
/**  所对应的用户id */
@property(nonatomic,copy)NSString *userId;

/** 大头针的位置 */
@property(nonatomic,strong)LocationModel *locationModel;

/** 是不是自己*/
@property(nonatomic,assign)BOOL isMe;
@end
