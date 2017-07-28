//
//  YiChang4_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/20.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "YiChang4_ViewController.h"
@interface YiChang4_ViewController ()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;



@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *text1;
@property (weak, nonatomic) IBOutlet UILabel *text2;
@property (weak, nonatomic) IBOutlet UILabel *text3;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@end

@implementation YiChang4_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTittleWithText:@"重启方法"];
    _view1.layer.cornerRadius = 6;
    _view2.layer.cornerRadius = 6;
    _view3.layer.cornerRadius = 6;
    _btn.layer.cornerRadius = 5;
    [self UIlayout];
}

-(void)UIlayout{
    [LKTool setView_Y:lkptBiLi(107) andView:_titleView];
    _view1.frame = CGRectMake(lkptBiLi(61), lkptBiLi(222),12 , 12);

    _text1.frame = [LKTextTool makeRect_Font:17 text:@"断开带电源和设备   " origin: CGPointMake([LKTool getRightX:_view1]+lkptBiLi(10), lkptBiLi(219)) constrainedToSize: CGSizeMake(_text1.frame.size.width+10, 0)];
    _view2.frame = CGRectMake(lkptBiLi(61), lkptBiLi(280),12 , 12);
  

    _text2.frame = [LKTextTool makeRect_Font:17 text:@"双击Home键，将APP退出后台，并再次打开" origin: CGPointMake([LKTool getRightX:_view1]+lkptBiLi(10),  lkptBiLi(272)) constrainedToSize: CGSizeMake(_text2.frame.size.width, 0)];
    
    _view3.frame = CGRectMake(lkptBiLi(61), lkptBiLi(353),12 , 12);
    _text3.frame  = [LKTextTool makeRect_Font:17 text:@"关闭蓝牙并再次打开" origin: CGPointMake([LKTool getRightX:_view1]+lkptBiLi(10), lkptBiLi(350)) constrainedToSize: CGSizeMake(_text3.frame.size.width, 0)];

       [LKTool setView_Y:lkptBiLi(445) andView:_btn];
    
     [LKTool setView_CenterX:WIDTH_lk/2 andView:_btn];
     [LKTool setView_CenterX:WIDTH_lk/2 andView:_titleView];
     [LKTool setView_CenterX:WIDTH_lk/2 andView:_btn];
     [LKTool setView_CenterX:WIDTH_lk/2 andView:_btn];
    
}


- (IBAction)btnClick:(id)sender {
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
