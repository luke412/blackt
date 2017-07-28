//
//  CurrDevice_TableViewCell.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/10.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "CurrDevice_TableViewCell.h"
@interface CurrDevice_TableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation CurrDevice_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
-(void)setDeviceName:(NSString *)deviceName{
    _deviceName = deviceName;
    _nameLabel.text = deviceName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
