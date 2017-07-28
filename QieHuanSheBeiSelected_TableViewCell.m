//
//  QieHuanSheBeiSelected_TableViewCell.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/4/7.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  切换设备cell 选中状态

#import "QieHuanSheBeiSelected_TableViewCell.h"
@interface QieHuanSheBeiSelected_TableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel     *rightLabel;

@end

@implementation QieHuanSheBeiSelected_TableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    /**
     *  渐变色
     */
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.colors = @[(__bridge id) [LKTool from_16To_Color:@"FFEAF7"].CGColor, (__bridge id)[LKTool from_16To_Color:@"B4AFFF"].CGColor];
//    gradientLayer.locations = @[@0, @1.0];
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(1.0, 0);
//    gradientLayer.frame = CGRectMake(0, 0,WIDTH_lk, self.frame.size.height);
//    [self.contentView.layer addSublayer:gradientLayer];
    [self.contentView addSubview:_rightLabel];
}

#pragma mark - set 相关
-(void)setDeviceName:(NSString *)deviceName{
    _deviceName = deviceName;
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
