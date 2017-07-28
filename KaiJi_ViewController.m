//
//  KaiJi_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/20.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "KaiJi_ViewController.h"

@interface KaiJi_ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation KaiJi_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTittleWithText:@"蓝牙开启"];
    
    _image.frame = CGRectMake(lkptBiLi(15), 64+lkptBiLi(20), lkptBiLi(290), lkptBiLi(290));
    _text.frame = CGRectMake(lkptBiLi(33), lkptBiLi(400), lkptBiLi(254), lkptBiLi(25));
    
    CGFloat btnHeight = _btn.frame.size.height;
    CGFloat btnWitch  = _btn.frame.size.width;
    _btn.frame = CGRectMake(lkptBiLi(40),
                            HEIGHT_lk - btnHeight - lkptBiLi(33),
                            btnWitch,
                            btnHeight);
    _btn.layer.cornerRadius = 5;
    [LKTool setView_CenterX:WIDTH_lk/2 andView:_image];
    [LKTool setView_CenterX:WIDTH_lk/2 andView:_text];
    
    [LKTool setView_CenterX:WIDTH_lk/2 andView:_btn];
}
- (IBAction)queDingClick:(id)sender {
    
    if (_myClickBlick) {
        _myClickBlick();
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end