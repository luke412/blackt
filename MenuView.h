//
//  MenuView.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/1/18.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickBlock)();
@interface MenuView : UIView
@property (weak, nonatomic) IBOutlet UIButton *DisconnectBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeNameBtn;
@property (nonatomic ,assign)BOOL isOpen;
@property (nonatomic,copy) ClickBlock disconnectClickBlock;
@property (nonatomic,copy) ClickBlock modifyClickBlock;

-(void)set_disconnectClickBlock:(ClickBlock)block;
-(void)set_modifyClickBlock:(ClickBlock)block;
-(void)appearAnimation;
-(void)disappearAnimation;
@end
