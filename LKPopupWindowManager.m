//
//  LKPopupWindowManager.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/30.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  弹窗管理员

#import "LKPopupWindowManager.h"
@implementation LKPopupWindowManager
-(void)synchronousNameDictionary{
    NSArray *devices = [[LKDataBaseTool sharedInstance] showAllDataFromTable:nil];
    if (!_setTempDictionary) {
        _setTempDictionary =[[NSMutableDictionary alloc]init];
    }
    [_setTempDictionary removeAllObjects];
    
    if (!_nameDictionary) {
        _nameDictionary = [[NSMutableDictionary alloc]init];
    }
    [_nameDictionary removeAllObjects];
    //填充设定温度字典

    //填充名称字典
    for (ClothesModel *model in devices) {
        NSString *mac = model.clothesMac;
        NSString *name = model.clothesName;
        [self.nameDictionary setObject:name forKey:mac];
    }
}
-(void)addDeviceToNameDictionaryWithMac:(NSString *)mac andName:(NSString *)name{
    [self.nameDictionary setObject:name forKey:mac];
}
-(void)deleteDeviceForNameDictionaryWithMac:(NSString *)mac{
    [self.nameDictionary removeObjectForKey:mac];
}


-(void)showPopupWindow_clothesIsHasBeen_WithVC:(UIViewController *)target{
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"绑定失败" message:@"原因：此设备已经绑定过" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"点击了取消按钮");
            }];
        [alertVc addAction:cancle];
     
        //4.控制器 展示弹框控件，完成时不做操作
        [target presentViewController:alertVc animated:YES completion:^{
                nil;
            }];
}
-(void)showPopupWindow_Error_WithVC:(UIViewController *)target andError:(NSString *)errorCode{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"绑定失败" message:@"原因：此设备已经绑定过" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"点击了取消按钮");
            }];
        [alertVc addAction:cancle];
        
        // 4.控制器 展示弹框控件，完成时不做操作
        [target presentViewController:alertVc animated:YES completion:^{
                nil;
            }];
}
-(void)showPopupWindow_withMessage:(UIViewController *)target andMessage:(NSString *)Message{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:Message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"点击了取消按钮");
            }];
        [alertVc addAction:cancle];
        
        // 4.控制器 展示弹框控件，完成时不做操作
        [target presentViewController:alertVc animated:YES completion:^{
                nil;
            }];
}
@end
