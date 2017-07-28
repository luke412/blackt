//
//  FriendView.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/12.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "FriendView.h"
#import "AddFriend_ViewController.h"

@interface FriendView ()
@end;

@implementation FriendView

-(void)awakeFromNib{
    [super awakeFromNib];
    CGFloat selfWidth = lkptBiLi(264);
    
    _addFriendLabel.frame = CGRectMake(lkptBiLi(22),
                                       lkptBiLi(20),
                                       _addFriendLabel.frame.size.width,
                                       _addFriendLabel.frame.size.height);
    
    _line1.frame = CGRectMake(lkptBiLi(0),
                                       lkptBiLi(60),
                                       selfWidth,
                                       1);
    
    
    _chaKanFriendLabel.frame = CGRectMake(lkptBiLi(22),
                                       lkptBiLi(82),
                                       _chaKanFriendLabel.frame.size.width,
                                       _chaKanFriendLabel.frame.size.height);
    
    _kaiGuanBtn.frame = CGRectMake(lkptBiLi(192),
                                   lkptBiLi(79),
                                   _kaiGuanBtn.frame.size.width,
                                   _kaiGuanBtn.frame.size.height);
    _kaiGuanBtn.isOn = YES;
    [self showCurrFace_btn:_kaiGuanBtn];
    _line2.frame = CGRectMake(lkptBiLi(0),
                              lkptBiLi(120),
                              selfWidth,
                              1);
    _textShowLabel.frame = CGRectMake(lkptBiLi(20),
                                      lkptBiLi(133),
                                      selfWidth - lkptBiLi(20)*2,
                                      50);
    _textShowLabel.userInteractionEnabled = NO;
    
}
-(void)initialization_superVC:(Base_ViewController *)vc{
    self.superVC = vc;
    self.frame               = CGRectMake(WIDTH_lk-lkptBiLi(264),
                                          64,
                                          lkptBiLi(264),
                                          HEIGHT_lk-64);
    self.frame               = CGRectMake(WIDTH_lk+lkptBiLi(264)+10,
                                          64,
                                          lkptBiLi(264),
                                          HEIGHT_lk-64);
    self.layer.shadowColor   = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset  = CGSizeMake(-1,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 0.7;//阴影透明度，默认0
    self.layer.shadowRadius  = 4;//阴影半径，默认3    [self.view
    [vc.view addSubview:self];
    
    _mengBan = [[LKButton alloc]initWithFrame:CGRectMake(0,64,WIDTH_lk - lkptBiLi(264),HEIGHT_lk-64)];
    _mengBan.backgroundColor = [UIColor blackColor];
    _mengBan.alpha = 0.3;
    [_mengBan addTarget:self action:@selector(mengBanClick) forControlEvents:UIControlEventTouchUpInside];
    [self.superVC.view addSubview:_mengBan];
    _mengBan.hidden = YES;
}
-(void)mengBanClick{
    [self close];
}

//查看好友开关
- (IBAction)kaiguan:(id)sender {
    LKButton *btn =(LKButton *)sender;
    btn.isOn = !btn.isOn;
    [self showCurrFace_btn:btn];
    if (_mySwitchClick) {
        _mySwitchClick(btn);
    }
}

#pragma mark - 开关按钮变化
-(void)showCurrFace_btn:(LKButton *)btn{
    if (btn.isOn == YES) {
        [btn setImage:[UIImage imageNamed:@"开关开"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"开关关"] forState:UIControlStateNormal];
    }
}


//添加好友点击
- (IBAction)addFriendClick:(id)sender {
    AddFriend_ViewController *vc = [[AddFriend_ViewController alloc]init];
    [self.superVC.navigationController pushViewController:vc animated:NO];
}


-(void)open{
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(WIDTH_lk-lkptBiLi(264), 64, lkptBiLi(264), HEIGHT_lk-64);
    } completion:^(BOOL finished){
        _mengBan.hidden = NO;
    }];
}

-(void)close{
    _mengBan.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(WIDTH_lk+lkptBiLi(264)+10, 64, lkptBiLi(264), HEIGHT_lk-64);
    } completion:^(BOOL finished) {
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
