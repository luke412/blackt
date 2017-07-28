//
//  LKNiuView.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/3/29.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  小牛按钮

typedef void(^clickBlock)();
#import <UIKit/UIKit.h>
@protocol CowClickDelegate <NSObject>

@required
/**点击小牛*/
-(void)cowClick;
@end


@interface LKNiuView : UIView
@property(nonatomic,weak) id<CowClickDelegate> delegate;
@property(nonatomic,weak) Base_ViewController *superVC;

/**展示设备信息*/
-(void)showInfo_currTemp:(NSInteger)currTemp MuBiaoTemp:(NSInteger)muBiaoTemp HeatState:(UserHeatState)userHeatState;

/**小牛展板显示温度*/
-(void)showTempText:(NSString *)text userState:(UserHeatState)state;

/**小牛展板显示状态*/
-(void)showStateText:(UserHeatState)state;

@end
