//
//  QieHuanSheBei_TableViewCell.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/4/7.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  切换设备



#import "QieHuanSheBei_TableViewCell.h"
@interface QieHuanSheBei_TableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel     *rightLabel;


@end

@implementation QieHuanSheBei_TableViewCell
-(void)setMyClickBlock:(clickBlock)myClickBlock{
    _myClickBlock = myClickBlock;
}
//点击切换设备
- (IBAction)qieHuanClick:(id)sender {
    if (_myClickBlock) {
        _myClickBlock();
    }
    
}
-(void)setDeviceName:(NSString *)deviceName{
    _deviceName          = deviceName;
    self.rightLabel.text = deviceName;
}

-(void)setDeviceMac:(NSString *)deviceMac{
    _deviceMac = deviceMac;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
