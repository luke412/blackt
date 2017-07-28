//
//  XiuGaiMingCheng_TableViewCell.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/4/13.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "XiuGaiMingCheng_TableViewCell.h"
@interface XiuGaiMingCheng_TableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;



@end

@implementation XiuGaiMingCheng_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
#pragma mark - set相关
-(void)setTittle:(NSString *)tittle{
    _tittle = tittle;
    self.myTitleLabel.text = _tittle;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
