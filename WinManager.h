//
//  WinManager.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/8.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  弹窗




#define  LKShow(text)      [Win_Manager showLoading_showText:text]
#define  LKRemove          [Win_Manager removeLoading]
#import "DOSingleton.h"
#import "UIImageView+WebCache.h"
@interface WinManager : DOSingleton
-(void)showLoading_showText:(NSString *)text;
-(void)removeLoading;


//好友请求弹窗
-(void)showFriendRequestWindow_text:(NSString *)text
                             TongYi:(void(^)())tongYi
                           ZaiXiang:(void(^)())zaiXiang;


//好友请求同意弹窗
-(void)friendTongYiWindow_text:(NSString *)text
                     lookBlock:(void(^)())lookBlock;

-(void)showLiliaoEndWindow_planName:(NSString *)name
                            queDing:(void(^)())queDing;

-(void)showTuiChuWindiw_name:(NSString *)name
                     queDing:(void(^)())queDing
                      quXiao:(void(^)())quXiao;


/**蓝牙未开启弹窗*/
-(void)showWin_bluePoweredOff;

/** 没有绑定设备 */
-(void)MeibangDing_bangDing:(void(^)())bangDingBlock
                     quXiao:(void(^)())quXiaoBlock;




/** 停止加热（连接）- 首页 */
-(void)stopHeat_Stop:(void(^)())stopBlack
                JiXu:(void(^)())JiXuBlock;

/**小牛弹窗 - 自助调温*/
-(void)showZiZhuCowWindow_TempStr:(NSString *)TempStr
                     tempStateStr:(NSString *)tempStateStr
                         planName:(NSString *)planNname;

/** 退出登录 */
-(void)showlogOutWindow_logOut:(void(^)())logOutBlock
                        cancal:(void(^)())cancalBlock;

/** 位置请求显示 */
-(void)showWeiZhiWindow_weiZhiYes:(void(^)())weiZhiYes
                             weiZhiNo:(void(^)())weiZhiNo;

/** 首次登录显示蓝牙请求提示 */
-(void)showBlueWindow_blueYes:(void(^)())blueYes
                       blueNo:(void(^)())blueNo;

/**
 *  显示启动页
 *
 *  @param imagePath    要显示的图片路径
 *  @param duration     持续时间 （秒）
 */

-(void)showQiDongYe_imagePath:(NSString *)imagePath
                     duration:(NSInteger)duration
                 TiaoGuoBlock:(void(^)())tiaoGuoBlock
                WanChengBlock:(void(^)())wanChengBlock
                 TimeOutBlock:(void(^)())timeOutBlock;
;
@end
