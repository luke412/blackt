//
//  Connecting_ViewController.h
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/27.
//  Copyright © 2016年 鲁柯. All rights reserved.
//

#import "Base_ViewController.h"



@interface Connecting_ViewController : Base_ViewController
@property(nonatomic,assign)BOOL  isSearch;//要不要在本页搜索
@property(nonatomic,copy)NSString *macAdress;
@property(nonatomic,copy)NSString *superVCName;  //KC01_JianCha_ViewController
@property(nonatomic,copy)NSString *deviceType;   //KC01 KC02
@end
