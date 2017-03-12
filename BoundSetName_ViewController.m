//
//  BoundSetName_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/27.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  绑定衣物2界面  写入衣物名字界面   写入衣物名称界面

#import "BoundSetName_ViewController.h"

@interface BoundSetName_ViewController ()<UIScrollViewDelegate>
{
    UIScrollView   *scrollw;
    NSArray        *nameArr;
    NSArray        *imagesArray;
    NSArray        *deviceStyleArr;   //设备类型

    NSString       *myDeviceStyle;
    UIPageControl  *pageControl;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField; //名字textfield
@property (weak, nonatomic) IBOutlet UIButton *queDingBtn;

@end

@implementation BoundSetName_ViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton=YES;
    if (self.isModify==YES) {
        self.navigationItem.hidesBackButton=NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"绑定衣物";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.navigationItem.titleView = title;
    
    //添加监听
    //当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                           name:UIKeyboardWillShowNotification
                                           object:nil];
     
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                           name:UIKeyboardWillHideNotification
                                           object:nil];
    
        UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,60)];
    leftButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButtonClick)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem =leftItem;
    



    [self createUI];
}
-(void)leftButtonClick{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)createUI{
    imagesArray=@[@"BlackT高清2",@"护腰新图",@"其他衣物(2)"];
    nameArr=    @[@"我的Black T",@"我的Black Care",@"其他衣物"];
    deviceStyleArr=@[@"BlackT",@"护腰",@"其他"];
    
    self.nameTextField.text=nameArr[0];
    //名字预处理，去重。
    if (self.isModify==YES) {
        NSArray *devices=[[LKDataBaseTool sharedInstance] showAllDataFromTable:nil];
        for (ClothesModel *model in devices) {
            if ([self.macAddress isEqualToString:model.clothesMac]) {
                self.nameTextField.text=model.clothesName;
            }
        }
    }else{
        [self getName];
    }
    
    
    
    myDeviceStyle          =deviceStyleArr[0];
    scrollw=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, WIDTH_lk/1.6+20)];
    scrollw.contentSize=CGSizeMake(WIDTH_lk*imagesArray.count, 200);
    scrollw.pagingEnabled=YES;
    scrollw.tag=50;
    scrollw.delegate=self;
    scrollw.showsVerticalScrollIndicator = NO;
    scrollw.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollw];
    [self createPageControl];
    
    for (int i=0;i<imagesArray.count; i++) {
        UIImage *image=[UIImage imageNamed:imagesArray[i]];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*WIDTH_lk, 0, WIDTH_lk, WIDTH_lk/1.6)];
        imageView.image=image;
        [scrollw addSubview:imageView];
    }
    
    if (self.isModify==YES) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
        title.textColor = [UIColor whiteColor];
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"修改衣物名称";
        title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        self.navigationItem.titleView = title;
    }
    
    _queDingBtn.layer.masksToBounds =YES;
    _queDingBtn.layer.cornerRadius =10;
    _queDingBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
}

//名字去重，预处理
-(void)getName{
    NSArray *devices=[[LKDataBaseTool sharedInstance] showAllDataFromTable:nil];
    for (int i=0; i<devices.count; i++){
        ClothesModel *model=devices[i];
        if ([self.nameTextField.text isEqualToString:model.clothesName]) {//如果重名了
            NSString *str=self.nameTextField.text;
            NSArray *arr = [str componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"QWERTYUIOPLKJHGFDSAZXCVBNMpoiuytrewqasdfghjklmnbvcxz"]];
            NSMutableArray *arrMut=[[NSMutableArray alloc]initWithArray:arr];
            NSString *strLastChar=[arr lastObject];
            NSScanner* scan = [NSScanner scannerWithString:strLastChar]; //定义一个NSScanner，扫描string
                int val;
                //如果末尾是数字
                if([scan scanInt:&val] && [scan isAtEnd]){
                    int lastNum=[strLastChar intValue];//末尾数字
                    lastNum++;
                    NSString *laststr=[NSString stringWithFormat:@"%d",lastNum];
                    [arrMut removeLastObject];
                    [arrMut addObject:laststr];
                    NSMutableString *mutStr=[[NSMutableString alloc]initWithString:self.nameTextField.text];
                NSRange range=[mutStr rangeOfString:strLastChar];
                [mutStr deleteCharactersInRange:range];
                [mutStr appendFormat:laststr];
                self.nameTextField.text=mutStr;
                    [self getName];
                }else{
                    self.nameTextField.text=[NSString stringWithFormat:@"%@2",self.nameTextField.text];//追加2
                    [self getName];
                }
        }
    }

    
}
-(void)createPageControl
{
        //创建pageControl,通常与ScrollView一起使用
        pageControl =[[UIPageControl alloc]initWithFrame:CGRectMake(0,[LKTool getBottomY:scrollw]-50, self.view.frame.size.width, 40)];
        //设置透明度
        pageControl.alpha = 0.5;
        //设置总页数
        pageControl.numberOfPages = 3;
        //设置当前选中的页
        pageControl.currentPage = 0;
        //设置选中页的小圆点的颜色
        pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        //设置非选中页的小圆点的颜色
        pageControl.pageIndicatorTintColor = [UIColor blackColor];
        //添加到当前视图控制器的View上
        [self.view addSubview:pageControl];
        
}

//减速结束，也就是停止滚动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //通过偏移量计算出当前显示的是第几张图片，_pageControl.currentPage表示选中的页，把算出得结果赋给_pageControl.currentPage
    int index = scrollView.contentOffset.x /self.view.frame.size.width;
    self.nameTextField.text=nameArr[index];
    myDeviceStyle          =deviceStyleArr[index];
    //获取衣物类型
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect   keyboardRect = [aValue CGRectValue];
        int height = keyboardRect.size.height;
        int width = keyboardRect.size.width;
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UIView   *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
        CGRect   firstResponderRect=[firstResponder convertRect:firstResponder.bounds toView:self.view];
        
        //拿到响应者底部纵坐标
        CGFloat bottom=firstResponderRect.origin.y+firstResponderRect.size.height;
        //不需上移
        if (bottom<HEIGHT_lk-height-20) {
            }
        //响应者位置偏低  视图需要上移 20为保留的余量
        else{
                CGFloat cha=bottom-(HEIGHT_lk-height-20);
                self.view.frame=CGRectMake(0, -cha, WIDTH_lk, HEIGHT_lk);
            }
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
     self.view.frame=CGRectMake(0, 0, WIDTH_lk, HEIGHT_lk);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//确定按钮
- (IBAction)click:(id)sender{
    if (self.nameTextField.text.length<1) {
        [MBProgressHUD showError:@"衣物名称不能为空"];
        return;
    }
    if (self.nameTextField.text.length>15) {
        [MBProgressHUD showError:@"字符长度超过15位"];
        return;
    }
    
    NSMutableString *mutStr = [[NSMutableString alloc]initWithString:self.nameTextField.text];
    NSString *str = [LKTool stringDeleteString:@" " fromStr:mutStr];
    if (str.length < 1){
        [MBProgressHUD showError:@"名称不能为空"];
        return;
    }
    
    
    if (self.isModify==YES) {
        //检验是否重名
        NSArray *clothes=[[LKDataBaseTool sharedInstance]showAllDataFromTable:nil];
        for (ClothesModel *model in clothes) {
            if ([self.nameTextField.text isEqualToString:model.clothesName]) {
                [MBProgressHUD showError:@"此名称已被占用，请重新输入"];
                self.nameTextField.text=@"";
                return;
            }
        }

        
        //
        
        //将修改写入数据库
        BOOL isSuccess=[[LKDataBaseTool sharedInstance]ModifytheNameFromTheTableWithMac:self.macAddress andNewName:self.nameTextField.text andStyle:myDeviceStyle];
        if (isSuccess){
            [MBProgressHUD showSuccess:@"修改名称成功"];
            NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"ModifyNameSuccess" object:self.macAddress];
            [self performSelector:@selector(pop) withObject:nil afterDelay:1.2];
        }else{
            //弹窗
            [MBProgressHUD showSuccess:@"修改名称失败"];
        }

    }
    
    
    
    
    //将绑定衣物写入数据库
    else{
        //检验是否重名
        NSArray *clothes=[[LKDataBaseTool sharedInstance]showAllDataFromTable:nil];
        for (ClothesModel *model in clothes) {
            if ([self.nameTextField.text isEqualToString:model.clothesName]){
                [MBProgressHUD showError:@"此名称已被占用，请重新输入"];
                self.nameTextField.text=@"";
                return;
            }
        }
        
        NSString* returnText=[[LKDataBaseTool sharedInstance] InsertedIntoTheTableWithMacAddress:self.macAddress andName:self.nameTextField.text andStyle:myDeviceStyle];
        if ([returnText isEqualToString:@"成功"]) {
            [MBProgressHUD showSuccess:@"绑定成功"];
            NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
            NSLog(@"self还在不在：%@"           ,self);
            NSLog(@"self.macAddress还在不在：%@",self.macAddress);
            
            [nc postNotificationName:@"BindingSuccess" object:self.macAddress];
            [self performSelector:@selector(pop) withObject:nil afterDelay:1.2];
        }else if([returnText hasSuffix:@"is not unique"]){
            //弹窗
            [[LKPopupWindowManager sharedInstance] showPopupWindow_clothesIsHasBeen_WithVC:self];
        }else{
            
        }
    }
    
    
    
    
}
-(void)pop{
      [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)get_nameBlock:(getNameBlock)myGetNameBlock{
    self.myGetNameBlock=myGetNameBlock;
}

-(void)dealloc{
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        //移除所有self监听的所有通知
        [nc removeObserver:self];
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
