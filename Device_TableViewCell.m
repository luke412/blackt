//
//  Device_TableViewCell.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/4/6.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "Device_TableViewCell.h"
#import <objc/runtime.h>
@interface Device_TableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel     *rightLabel;
@property (weak, nonatomic) IBOutlet UIView *delBtnView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *line;

@end
@implementation Device_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiped:)];
            //设置监听的方向
            swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
            swipLeft.delegate = self;
            [self.backView addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiped:)];
            //设置监听的方向
            swipRight.direction = UISwipeGestureRecognizerDirectionRight;
            swipRight.delegate = self;
            [self.backView addGestureRecognizer:swipRight];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(delBtnClick:)];
    tap.delegate=self;
    [self.delBtnView addGestureRecognizer:tap];
    
    _line.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1];
}
-(void)delBtnClick:(UITapGestureRecognizer *)tap2
{
    if (_delBlock) {
        _delBlock();
    }
}
-(void)swiped:(UISwipeGestureRecognizer *)gesture
{
     if (gesture.direction & UISwipeGestureRecognizerDirectionRight) {
                        NSLog(@"向右滑动");
                    [self closeEditState];
                       
    }
        else if(gesture.direction & UISwipeGestureRecognizerDirectionLeft){
                            NSLog(@"向左滑动");
                                [self openEditState];
    }
}


-(void)openEditState{
    CGFloat weiYi = self.delBtnView.frame.size.width;
    [UIView animateWithDuration:0.1 animations:^{
        self.backView.frame = CGRectMake(-weiYi, 0, WIDTH_lk, self.frame.size.height);
    } completion:^(BOOL finished) {
        _isOpenEditState = YES;
    }];
}
-(void)closeEditState{
    [UIView animateWithDuration:0.1 animations:^{
        self.backView.frame = CGRectMake(0, 0, WIDTH_lk, self.frame.size.height);
    } completion:^(BOOL finished) {
        _isOpenEditState = NO;
    }];
}
#pragma mark - set方法
-(void)setDeviceName:(NSString *)deviceName{
    _deviceName = deviceName;
    self.rightLabel.text = deviceName;
}

-(void)setDeviceMac:(NSString *)deviceMac{
    _deviceMac = deviceMac;
}

-(void)layoutSubviews{
    for (UIView *subView in self.subviews) {
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            // 这里是右边的
            UIView *shareConfirmationView = subView.subviews[0];
            for (UIView *shareView in shareConfirmationView.subviews) {
                UIImageView *shareImage = [[UIImageView alloc] init];
                shareImage.contentMode = UIViewContentModeScaleAspectFit;
                shareImage.image = [UIImage imageNamed:@"删除"];
                shareImage.frame = CGRectMake(0, 0, 25, 25);
                shareImage.center = CGPointMake(shareView.frame.size.width/2, shareView.frame.size.height/2);
                [shareView addSubview:shareImage];
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
