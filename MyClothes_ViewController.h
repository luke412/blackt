//
//  MyClothes_ViewController.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/1/4.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "Base_ViewController.h"
@interface MyClothes_ViewController : Base_ViewController
@property (weak, nonatomic) IBOutlet UILabel     *myClothesLabel;
@property (weak, nonatomic) IBOutlet UITextField *clothesNameTextField;
@property(nonatomic,assign) MASTER   master; //跳转动作的发起cell
@end
