//
//  BlueiTiShiView.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/24.
//  Copyright © 2017年 鲁柯. All rights reserved.
//
typedef void(^YunXuBlock)();
typedef void(^BuXuBlock)();


#import <UIKit/UIKit.h>

@interface BlueiTiShiView : UIView
@property(nonatomic,copy)YunXuBlock yunXuBlock;
@property(nonatomic,copy)BuXuBlock  buXuBlock;

@end
