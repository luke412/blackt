//
//  DrawerDeviceImage.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/2/26.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawerDeviceImage : UIImageView
@property(nonatomic,copy)NSString *deviceStyle;
@property(nonatomic,copy)NSString     *deviceName;
@property(nonatomic,copy)  NSString   *deviceMac;
@property(nonatomic,assign) BOOL isSelected;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLbbel;
@property (weak, nonatomic) IBOutlet UIButton *coverBtn;







@end
