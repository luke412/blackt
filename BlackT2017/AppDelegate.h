//
//  AppDelegate.h
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/22.
//  Copyright © 2016年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager;  
}

@property (strong, nonatomic) UIWindow *window;

-(void)BluetoothPowerOff;
@end

