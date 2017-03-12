//
//  DingShiBtn.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/3/1.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DingShiBtn : UIButton
@property (weak, nonatomic) IBOutlet UIImageView *btnImageView;
@property (weak, nonatomic) IBOutlet UILabel *zhuangtaiLabel;
@property(nonatomic,assign) BOOL isSeted;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
-(void)reloadUI;
@end
