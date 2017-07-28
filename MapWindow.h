//
//  MapWindow.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/22.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

typedef void(^ZaiXiangBlock)();
typedef void(^TongYiBlock)();



#import <UIKit/UIKit.h>

@interface MapWindow : UIView
@property(nonatomic,copy)ZaiXiangBlock zaiXiangBlock;
@property(nonatomic,copy)TongYiBlock   tongYiBlock;


-(void)showText:(NSString *)text;
@end
