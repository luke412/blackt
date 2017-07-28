//
//  LanYa_ViewController.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/20.
//  Copyright © 2017年 鲁柯. All rights reserved.
//
typedef void(^clickBlick)();

#import "Base_ViewController.h"

@interface LanYa_ViewController : Base_ViewController
@property(nonatomic,copy)clickBlick myClickBlick;

@end
