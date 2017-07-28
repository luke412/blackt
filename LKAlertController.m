//
//  LKAlertController.m
//  test
//
//  Created by 鲁柯 on 2017/5/26.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "LKAlertController.h"
#import "LKTool.h"
@interface LKAlertController ()

@end

@implementation LKAlertController
- (void)viewDidLoad {
    [super viewDidLoad];
      //修改title
//        NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"        "];
//        [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];
//        [alertControllerStr addAttribute:NSFontAttributeName  value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 2)];
//        [self setValue:alertControllerStr forKey:@"attributedTitle"];
        
}
-(void)setText:(NSString *)text{
    //修改message
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:text];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[LKTool from_16To_Color:@"615F5F"] range:NSMakeRange(0, text.length)];
        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, text.length)];
        [self setValue:alertControllerMessageStr forKey:@"attributedMessage"];
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
