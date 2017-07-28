//
//  LKView.h
//  圆形进度条
//
//  Created by 鲁柯 on 2017/2/15.
//  Copyright © 2017年 鲁柯. All rights reserved.
//
#import <UIKit/UIKit.h>

//LKView 状态
typedef enum {
    Connected,
    Disconnect,
    Connecting
}ConnectionStatus;

@protocol  LKViewDelegate <NSObject>
@required
-(void)ConnectClick;
/** 连接状态下用户调节温度 */
-(void)userGesture_wenDu:(NSInteger)wenDu;
/** 处于其他理疗模式的时候接收到用户事件 */
-(void)disconnectStateEvent;
@end



@interface LKView : UIImageView
@property (nonatomic,weak)  id<LKViewDelegate> delegate;
@property (nonatomic ,assign) CGFloat  lineWidth;
@property (nonatomic ,assign) CGFloat  radius;
@property (nonatomic ,assign) CGFloat  progress;

@property (nonatomic ,assign) CGPoint  circleCenterPosition;    //圆心位置
@property (nonatomic ,assign) CGPoint  handlePosition;          //手柄位置

@property(nonatomic,assign,readonly)ConnectionStatus viewState;   //是否是已连接状态
@property(nonatomic,weak)  Base_ViewController *superVC;

/**
 *  刷新手柄位置
 *
 *  @param Temp 目标温度
 */
-(void)refreshHandle_muBiaoTemp:(float)Temp;

/** 示正在加热的界面 */
-(void)showHeatingFace_targetTemp:(NSInteger)targetTemp;
/** 显示正在连接界面 */
-(void)showConnectingFace;

/**  显示停止加热的界面 */
-(void)showStopFace;
@end
