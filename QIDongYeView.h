//
//  QIDongYeView.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/26.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "UIImageView+WebCache.h"
typedef void(^TiaoGuoBlock)();
typedef void(^TimeOutBlock)();

#import <UIKit/UIKit.h>

@interface QIDongYeView : UIView
@property(nonatomic,strong)NSString *backImagePath;
@property(nonatomic,copy)NSString *labelText;

/** 点击跳过回调 */
@property(nonatomic,copy)TiaoGuoBlock tiaoGuoBlock;

/** 超时回调 */
@property(nonatomic,copy)TimeOutBlock timeOutBlock;
@end
