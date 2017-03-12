//
//  LKManager.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/1/6.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  各种常用操作的管理者

#import "DOSingleton.h"

@interface LKManager : DOSingleton




-(NSString *)getMacFromQRCodeWithVC:(UINavigationController *)vc andTarget:(nullable UIViewController *)targetVC;
@end
