//
//  BoundSetName_ViewController.h
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/27.
//  Copyright © 2016年 鲁柯. All rights reserved.
//

#import "Base_ViewController.h"
typedef void(^getNameBlock)(NSString *name);
@interface BoundSetName_ViewController : Base_ViewController
@property(nonatomic,copy)NSString     *macAddress;   //从上一界面传来的Mac地址
@property(nonatomic,copy)getNameBlock myGetNameBlock;
@property(nonatomic,assign)BOOL isModify;
-(void)get_nameBlock:(getNameBlock)myGetNameBlock;
@end
