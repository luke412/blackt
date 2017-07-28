//
//  JC_Connecting_ViewController.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/20.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

typedef void(^BlueSuccess)(NSString *mac);
typedef void(^BlueFailure)(NSString *mac);

#import "Base_ViewController.h"

@interface JC_Connecting_ViewController : Base_ViewController
@property(nonatomic,copy)NSString *macAdress;
@property(nonatomic,copy)NSString *superVCName;  //KC01_JianCha_ViewController
@property(nonatomic,copy)NSString *deviceType;   //KC01 KC02

@property(nonatomic,copy)BlueSuccess blueSuccess;
@property(nonatomic,copy)BlueFailure blueFailure;


@end
