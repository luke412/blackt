//
//  LocationModel.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/12.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationModel : NSObject
@property(nonatomic,assign)double  latitude; //纬度
@property(nonatomic,assign)double  longitude;//经度
@property(nonatomic,copy)  NSString *title;
@end
