//
//  Main_ViewController.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/4.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "Base_ViewController.h"

@interface Main_ViewController : Base_ViewController
/** 示正在加热的界面 */
-(void)showHeatingFace_targetTemp:(NSInteger)targetTemp andRestSeconds:(NSInteger)Seconds;


/** 显示正在连接界面 */
-(void)showConnectingFace;


/**  显示停止加热的界面 */
-(void)showStopFace;
@end
