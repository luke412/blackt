//
//  ObjectChangeNotifyModel.h
//  容器类监听
//
//  Created by 鲁柯 on 2017/3/27.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ObjectChangeNotifyModel : NSObject
@property(nonatomic,strong)id  NewObject;
@property(nonatomic,strong)id  OldObject;
@property(nonatomic,copy)NSString *className;
@property(nonatomic,copy)NSString *mac;   //发生变化的mac
@end
