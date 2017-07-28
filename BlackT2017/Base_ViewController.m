//
//  Base_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/22.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  所有界面的基类

#import "Base_ViewController.h"

@interface Base_ViewController ()
@end

@implementation Base_ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
     NSString *classStr=[NSString stringWithUTF8String:object_getClassName(self)];
    if ([classStr isEqualToString:@"Main_ViewController"] ||
        [classStr isEqualToString:@"WoDe_ViewController"] ||
        [classStr isEqualToString:@"FaXian_ViewController"]
        ) {
        self.tabBarController.tabBar.hidden = NO;
    }else{
        self.tabBarController.tabBar.hidden = YES;
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条颜色
    [self.navigationController.navigationBar setBarTintColor:[LKTool from_16To_Color:NAV_COLOR]];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [LKTool from_16To_Color:ThemeColor];
    
    //返回按钮上的字
    UIBarButtonItem *backIetm = [[UIBarButtonItem alloc] init];
    backIetm.title =LK(@"返回");                  //这是在基类里  所以可以在此写@“返回”  这样 就是中文"返回"了 这里为空
    self.navigationItem.backBarButtonItem = backIetm;
    self.navigationController.navigationBar.tintColor = [LKTool from_16To_Color:NAV_TEXT_COLOR];
    
    
}
-(void)setTittleWithText:(NSString *)text{
    UILabel *title  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    title.textColor = [LKTool from_16To_Color:NAV_TEXT_COLOR];
    title.backgroundColor   = [UIColor clearColor];
    title.textAlignment     = NSTextAlignmentCenter;
    title.text = LK(text);
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.navigationItem.titleView = title;
    self.view.backgroundColor=[UIColor whiteColor];
}



- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
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
