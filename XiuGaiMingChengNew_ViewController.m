//
//  XiuGaiMingChengNew_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/4/24.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  修改名称界面  子界面

#import "XiuGaiMingChengNew_ViewController.h"
#import "DataBaseManager.h"

@interface XiuGaiMingChengNew_ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation XiuGaiMingChengNew_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTittleWithText:LK(@"修改名称")];
    [self loadUI];
    [_textField becomeFirstResponder];
    
}
-(void)loadUI{
    if ([_myClothesModel.clothesStyle isEqualToString:@"BlackT"]) {
        self.leftImageView.image = [UIImage imageNamed:@"blackt2c"];
    }
    else if([_myClothesModel.clothesStyle isEqualToString:@"护腰"]){
        self.leftImageView.image = [UIImage imageNamed:@"护腰2c"];
    }
    else if([_myClothesModel.clothesStyle isEqualToString:@"其他"]){
        self.leftImageView.image = [UIImage imageNamed:@"其他设备2c"];
    }

    _textField.placeholder = _myClothesModel.clothesName;
    _textField.delegate    = self;
    _textField.borderStyle = UITextBorderStyleNone;
    
    UIButton *rightButton                  = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,30)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[LKTool from_16To_Color:tableViewCellTextColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(save)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem             = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)save{
    [self textFieldShouldReturn:self.textField];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
        if (textField.text.length<1) {
            [MBProgressHUD showError:LK(@"设备名称不能为空")];
            return NO;
        }
        if (textField.text.length>15) {
            [MBProgressHUD showError:LK(@"字符长度超过15位")];
            return NO;
        }
        
        NSMutableString *mutStr = [[NSMutableString alloc]initWithString:textField.text];
        NSString *str = [LKTool stringDeleteString:@" " fromStr:mutStr];
        if (str.length < 1){
            [MBProgressHUD showError:LK(@"名称不能为空")];
            return NO;
        }
    
    
        //检验是否重名
        NSArray <DeviceModel *>*clothes=[DataBase_Manager getAllBoundDevice];
        for (DeviceModel *model in clothes) {
            if ([_textField.text isEqualToString:model.clothesName]) {
                [MBProgressHUD showError:LK(@"此名称已被占用，请重新输入")];
                _textField.text=@"";
                return NO;
            }
        }
    

        //将修改写入数据库
        BOOL isSuccess = [DataBase_Manager XiuGai_mac:_myClothesModel.clothesMac name:_textField.text];
        if (isSuccess){
            [MBProgressHUD showSuccess:LK(@"修改名称成功")];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }else{
            //弹窗
            [MBProgressHUD showSuccess:LK(@"修改名称失败")];
        }
        return YES;
}
-(void)pop{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
