//
//  FriendView.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/12.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

typedef void(^SwitchClick)(LKButton *switchBtn);

#import <UIKit/UIKit.h>

@interface FriendView : UIView
@property (weak, nonatomic) IBOutlet UILabel    *addFriendLabel;
@property (weak, nonatomic) IBOutlet UILabel    *chaKanFriendLabel;

@property (weak, nonatomic) IBOutlet UIView     *line1;
@property (weak, nonatomic) IBOutlet UIView     *line2;
@property (weak, nonatomic) IBOutlet LKButton   *kaiGuanBtn;
@property (weak, nonatomic) IBOutlet UITextView *textShowLabel;
@property (weak, nonatomic) IBOutlet UIButton   *addFriendEventBtn;
@property(nonatomic,strong) LKButton *mengBan;


@property(nonatomic,weak)Base_ViewController *superVC;
@property(nonatomic,copy)SwitchClick  mySwitchClick;

-(void)initialization_superVC:(Base_ViewController *)vc;

/**打开抽屉*/
-(void)open;
-(void)close;

-(void)showCurrFace_btn:(LKButton *)btn;
@end
