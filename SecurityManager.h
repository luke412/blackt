//
//  SecurityManager.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/3/23.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "DOSingleton.h"

@interface SecurityManager : DOSingleton
+ (AFSecurityPolicy*)customSecurityPolicy;
@end
