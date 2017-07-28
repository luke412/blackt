//
//  LKSwitch.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/5/26.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKSwitch : UISwitch
@property(nonatomic,copy)NSString *name;


-(instancetype)initWithFrame:(CGRect)frame andName:(NSString *)name;
@end
