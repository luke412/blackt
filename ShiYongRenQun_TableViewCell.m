//
//  ShiYongRenQun_TableViewCell.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/16.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "ShiYongRenQun_TableViewCell.h"
#import "ShiYongRenModel.h"

@interface ShiYongRenQun_TableViewCell()
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *myTextLabel;

@end
@implementation ShiYongRenQun_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _tagView.frame              = CGRectMake(lkptBiLi(28), lkptBiLi(3), lkptBiLi(12), lkptBiLi(12));
    _tagView.layer.cornerRadius = lkptBiLi(12)/2;
    _myTitleLabel.frame         = CGRectMake([LKTool getRightX:_tagView]+lkptBiLi(15), lkptBiLi(0), lkptBiLi(230), lkptBiLi(17));
    _myTitleLabel.font          = [UIFont systemFontOfSize:18];
    _myTextLabel.frame          = CGRectMake(_myTitleLabel.frame.origin.x,[LKTool getBottomY:_myTitleLabel]+2, lkptBiLi(224),24*2);
    _myTextLabel.numberOfLines  = 1;
    _myTextLabel.contentMode    = UIViewContentModeTop;
    _myTextLabel.font           = [UIFont systemFontOfSize:15];
    _myTextLabel.textColor      = [LKTool from_16To_Color:@"#595959"];
    _myTitleLabel.textColor     = [LKTool from_16To_Color:@"#595959"];
}
-(void)refreshUI_ShiYongRenModel:(ShiYongRenModel *)model{
    _myTitleLabel.text = model.title;
    _myTextLabel.text  = model.text;
    
    CGSize size = [_myTextLabel.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(lkptBiLi(224),0)];
    _myTextLabel.frame = CGRectMake(_myTitleLabel.frame.origin.x,[LKTool getBottomY:_myTitleLabel]+2, lkptBiLi(224),size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
