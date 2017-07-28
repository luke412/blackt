//
//  AddRequestSuccess_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/18.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  添加好友请求发送成功

#import "AddRequestSuccess_ViewController.h"
#import "Location_ViewController.h"
@interface AddRequestSuccess_ViewController ()
{
        //定时器
        NSTimer * _timer;
}
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;

@end

@implementation AddRequestSuccess_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(everyTime) userInfo:nil repeats:YES];
    //滚动条不受影响
     [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)everyTime{
    static NSInteger seconds = 2;
    if (seconds == 0) {
        //返回地图页面
        NSArray *VCArr = self.navigationController.viewControllers;
        for (Base_ViewController *vc in VCArr) {
             NSString *classStr=[NSString stringWithUTF8String:object_getClassName(vc)];
            if([classStr isEqualToString:@"Location_ViewController"]){
                Location_ViewController *temp = (Location_ViewController *)vc;
                [self.navigationController popToViewController:temp animated:NO];
                if (_timer != nil) {
                        //销毁定时器
                        [_timer invalidate];
                  }
                return;
            }
        }
        
        //如果没有找到地图页，跳到跟视图
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }
    
    _title2.text = [NSString stringWithFormat:@"%lds后返回地图页",seconds];
    seconds -= 1;
}
-(void)dealloc
{
        if (_timer != nil) {
                //销毁定时器
                [_timer invalidate];
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
