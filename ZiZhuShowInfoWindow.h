//
//  ZiZhuShowInfoWindow.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/5/24.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZiZhuShowInfoWindow : UIView
@property(nonatomic,copy)NSString *heatStateStr;
@property(nonatomic,copy)NSString *wenDuValueStr;

-(void)showInfo;
@end
