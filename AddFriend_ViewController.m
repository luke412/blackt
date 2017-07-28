//
//  AddFriend_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/17.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  添加好友界面


#import "AddFriend_ViewController.h"
#import "FriendInfo_ViewController.h"
#import "FriendModel.h"

@interface AddFriend_ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UIView      *line;
@property (weak, nonatomic) IBOutlet UIButton    *queDing;

@property(nonatomic,assign)CGFloat  queDingY;
@end

@implementation AddFriend_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTittleWithText:@"添加好友"];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                           name:UIKeyboardWillShowNotification
                                           object:nil];
     
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                           name:UIKeyboardWillHideNotification
                                           object:nil];

    
    [self layOut];
}
-(void)layOut{
    _phoneNum.frame = CGRectMake(0, lkptBiLi(182), WIDTH_lk, lkptBiLi(20));
    _phoneNum.placeholder = @"请输入好友手机号";
    _phoneNum.font = [UIFont systemFontOfSize:20];
    _phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    
    _line.frame              = CGRectMake(lkptBiLi(20), lkptBiLi(204), WIDTH_lk-lkptBiLi(20)*2, 1);
    _line.backgroundColor = [LKTool from_16To_Color:@"#595959"];
    _queDing.frame           = CGRectMake(lkptBiLi(40),lkptBiLi(303),WIDTH_lk-lkptBiLi(40)*2, lkptBiLi(50));
    _queDingY = lkptBiLi(303);
    _queDing.layer.cornerRadius = 5;
    _queDing.layer.masksToBounds = YES;
    [_queDing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _queDing.backgroundColor = [LKTool from_16To_Color:BTN_backColor];
}
- (IBAction)queDingClick:(id)sender {
    [self.view endEditing:YES];
    if (_phoneNum.text.length != 11) {
        [MBProgressHUD showError:@"请输入正确手机号"];
        return;
    }
    NSString *userId    = [App_Manager getUserId];
    NSString *userToken = [App_Manager getUserToken];
    NSString *deviceId  = [App_Manager getDeviceId];
    NSString *mobile    = _phoneNum.text;
    LKShow(@"正在查找...");
    [NetWork_Manager searchByMobile_userId:userId
                                 userToken:userToken
                                  deviceId:deviceId
                                    mobile:mobile
                                   Success:^(FriendModel *model) {
                                       LKRemove;
                                       FriendInfo_ViewController *vc = [[FriendInfo_ViewController alloc]init];
                                       vc.currFriendModel =model;
                                       vc.currFriendModel.phoneNum =_phoneNum.text;
                                       [self.navigationController pushViewController:vc animated:NO];
                                   } Abnormal:^(id responseObject) {
                                        LKRemove;
                                       [MBProgressHUD showError:responseObject[@"retMsg"]];
                                        _phoneNum.placeholder = responseObject[@"retMsg"];
                                       _phoneNum.text = @"";
                                   } Failure:^(NSError *error) {
                                       LKRemove;
                                       [MBProgressHUD showError:@"网络开小差~\(≧▽≦)/"];
                                   }];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        int height = keyboardRect.size.height;
        int width = keyboardRect.size.width;
        NSLog(@"键盘高度是  %d",height);
        NSLog(@"键盘宽度是  %d",width);
    
      
        //拿到响应者底部纵坐标
        CGFloat bottom=_queDing.frame.origin.y+_queDing.frame.size.height;
        NSLog(@"鲁柯%f",bottom);
        //不需上移
        if (bottom<HEIGHT_lk-height-20) {
                NSLog(@"不会遮挡");
            }
        //响应者位置偏低  视图需要上移 20为保留的余量
        else{
                CGFloat cha=bottom-(HEIGHT_lk-height-20);
                NSLog(@"cha:%f",cha);
                self.queDing.frame = CGRectMake(self.queDing.frame.origin.x,
                                                self.queDing.frame.origin.y - cha,
                                                self.queDing.frame.size.width,
                                                self.queDing.frame.size.height);

            }
}
 
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.queDing.frame = CGRectMake(self.queDing.frame.origin.x,
                                    _queDingY,
                                    self.queDing.frame.size.width,
                                    self.queDing.frame.size.height);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
