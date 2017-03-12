//
//  DrawerDeviceImage.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/2/26.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  抽屉里每隔设备的展示imageview

#import "DrawerDeviceImage.h"

@implementation DrawerDeviceImage


-(void)awakeFromNib{
    [super awakeFromNib];
    self.isSelected = NO;
    self.userInteractionEnabled          = YES;
    self.deviceImage.layer.masksToBounds = YES;
    self.deviceImage.layer.cornerRadius  = 10;
    self.backgroundColor                 = [[LKTool from_16To_Color:@"f6f6f6"]colorWithAlphaComponent:0.6f];
    
    

}

//按钮选中去搜索
- (IBAction)coverBtnClick:(id)sender {
    NSUserDefaults *luke = [NSUserDefaults standardUserDefaults];
     NSString *warmStateStr = [luke objectForKey:@"WarmViewControllerState"];

    if ( [warmStateStr isEqualToString:@"Normal"] && self.isSelected == YES) {
        return;
    }
    
    self.isSelected  = !self.isSelected;
    
    [[LGCentralManager sharedInstance] stopScanForPeripherals];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSString *macAndisSelected;
    if (self.isSelected  == YES) {
        macAndisSelected  = [NSString stringWithFormat:@"%@,YES",self.deviceMac];
    }else{
        macAndisSelected  = [NSString stringWithFormat:@"%@,NO",self.deviceMac];
    }
    NSNotification   *notify = [[NSNotification alloc]initWithName:@"userSelectImageBtn" object:macAndisSelected userInfo:nil];
    [nc postNotification:notify];
}





//重写set方法
-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (self.isSelected == YES){ //选中状态
        if ([_deviceStyle isEqualToString:@"BlackT"]) {
            _deviceImage.image = [UIImage imageNamed:@"抽屉BlackT_中"];
        }
        else if ([_deviceStyle isEqualToString:@"护腰"]){
            _deviceImage.image = [UIImage imageNamed:@"抽屉护腰_中"];
        }
        else if ([_deviceStyle isEqualToString:@"其他"]){
            _deviceImage.image = [UIImage imageNamed:@"抽屉其他衣物_中"];
        }
        
    }else{//未选中状态
        if ([_deviceStyle isEqualToString:@"BlackT"]) {
            _deviceImage.image = [UIImage imageNamed:@"抽屉BlackT"];
        }
        else if ([_deviceStyle isEqualToString:@"护腰"]){
            _deviceImage.image = [UIImage imageNamed:@"抽屉护腰"];
        }
        else if ([_deviceStyle isEqualToString:@"其他"]){
            _deviceImage.image = [UIImage imageNamed:@"抽屉其他衣物"];
        }
    }
}

-(void)setDeviceMac:(NSString *)deviceMac{
    _deviceMac = deviceMac;
    
}
-(void)setDeviceStyle:(NSString *)deviceStyle{
    _deviceStyle  = deviceStyle;
    if ([_deviceStyle isEqualToString:@"BlackT"]) {
        _deviceImage.image = [UIImage imageNamed:@"抽屉BlackT"];
    }
    else if ([_deviceStyle isEqualToString:@"护腰"]){
        _deviceImage.image = [UIImage imageNamed:@"抽屉护腰"];
    }
    else if ([_deviceStyle isEqualToString:@"其他"]){
        _deviceImage.image = [UIImage imageNamed:@"抽屉其他衣物"];
    }
}
-(void)setDeviceName:(NSString *)deviceName{
    _deviceName = deviceName;
    _nameLbbel.text = _deviceName;
}
-(void)dealloc
{
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        //移除所有self监听的所有通知
        [nc removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
