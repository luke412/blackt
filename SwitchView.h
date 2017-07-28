//
//  SwitchView.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/5/15.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  SwitchViewDelegate <NSObject>
@required
-(void)switchClick:(LKButton *)kaiGuanBtn;
@end


@interface SwitchView : UIView
@property (strong, nonatomic)  UIImageView *leftImage;
@property (strong, nonatomic)  UILabel     *centerLabel;
@property (strong,nonatomic)  LKButton     *kaiGuanBtn;
@property (strong, nonatomic)  UIView      *bottomLine;
@property (nonatomic,weak) id<SwitchViewDelegate> delegate;


-(void)showKaiGuanClose;
-(void)showKaiGuanOpen;
@end
