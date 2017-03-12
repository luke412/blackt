//
//  ToolSlowInstructions_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/27.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  连接过慢说明界面 连接步骤界面 连接过慢

#import "ToolSlowInstructions_ViewController.h"
#import "Connecting_ViewController.h"
@interface ToolSlowInstructions_ViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ellipse1;
@property (weak, nonatomic) IBOutlet UIImageView *ellipse2;
@property (weak, nonatomic) IBOutlet UIImageView *ellipse3;
@property (weak, nonatomic) IBOutlet UIImageView *centerImage;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIImageView *ellipse4;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

@property(nonatomic,assign)int pageTotalNumber;
@property(nonatomic,assign)int pageCurrentNumber;    //“页面”的序号





@end

@implementation ToolSlowInstructions_ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageTotalNumber=3;
    self.pageCurrentNumber=0;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"连接步骤";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.navigationItem.titleView = title;

    //右按钮
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,60,30)];
    [rightButton setTitle:@"跳过" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    [self createUIWithPageNum:0];
    
    //左按钮
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,60,30)];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonAnswer)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    //添加手势
    [self addGuest];
}
-(void)createUIWithPageNum:(int)pageNum{
    if (pageNum==self.pageTotalNumber) {
        //搜索设备
        [HeatingClothesBLEService sharedInstance].SearchNumber=0;
        [HeatingClothesBLEService sharedInstance].isBound=NO;
        [[HeatingClothesBLEService sharedInstance]StartScanningDeviceWithMac:nil];
        [self.navigationController popToViewController:[HeatingClothesBLEService sharedInstance].myViewController animated:NO];
//        [self.navigationController pushViewController:[HeatingClothesBLEService sharedInstance].myViewController animated:NO];
    }else{
        self.leftBtn .imageView.image=[UIImage  imageNamed:@"箭头左边"];
        self.rightBtn.imageView.image=[UIImage imageNamed: @"箭头右边"];
        self.leftBtn.hidden =NO;
        self.rightBtn.hidden=NO;
        NSArray *ellipseArr=@[self.ellipse1,self.ellipse2,self.ellipse3,self.ellipse4];
        for (UIImageView *imageV in ellipseArr) {
            imageV.image=[UIImage imageNamed:@"椭圆空"];//
        }
        UIImageView *imageV1=ellipseArr[pageNum];
        imageV1.image=[UIImage imageNamed:@"椭圆实"];
        if (pageNum==0){
            self.leftBtn.hidden  =YES;
        }else if(pageNum==self.pageTotalNumber){
            self.rightBtn.hidden =YES;
        }
        NSLog(@"%d",pageNum);
        NSArray *imageArr=@[@"第一步",@"第二步",@"第三步图片"];
        NSArray *textArr= @[@"按右侧键蓝灯亮起确认盒子有电，蓝灯不亮，请充电。",
                            @"图示下拨档位键，看到红灯亮起",@"请确认Black T与控制盒连接好，否则会接触不良。"];
        self.centerImage.image=[UIImage imageNamed:imageArr[pageNum]];
        self.describeLabel.text=textArr[pageNum];
    }
}
-(void)leftButtonAnswer{
    //返回到根界面  温暖界面
    [self.navigationController popToRootViewControllerAnimated:NO];
}
//左侧按钮点击
- (IBAction)leftBtnClick:(id)sender{
    if (self.pageCurrentNumber!=0) {
        self.pageCurrentNumber--;
    }
    [self createUIWithPageNum:self.pageCurrentNumber];
}
//右侧按钮点击
- (IBAction)rightBtnClick:(id)sender{
    NSLog(@"%d,%d",self.pageCurrentNumber,self.pageTotalNumber);
    if (self.pageCurrentNumber!=self.pageTotalNumber) {
        self.pageCurrentNumber++;
    }
    [self createUIWithPageNum:self.pageCurrentNumber];
}

//右侧点击 跳过
-(void)rightButtonClick{
    [HeatingClothesBLEService sharedInstance].SearchNumber=0;
    [HeatingClothesBLEService sharedInstance].isBound=NO;
    [[HeatingClothesBLEService sharedInstance]StartScanningDeviceWithMac:nil];
    [self.navigationController popToViewController:[HeatingClothesBLEService sharedInstance].myViewController animated:NO];
//    [self.navigationController pushViewController:[HeatingClothesBLEService sharedInstance].myViewController animated:NO];
}

-(void)addGuest{
    //创建一个滑动手势，能监听上、下、左、右四个方向的滑动
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiped:)];
        //设置监听的方向
        swip.direction = UISwipeGestureRecognizerDirectionLeft;
        /*
              UISwipeGestureRecognizerDirectionRight
              向右滑动
              UISwipeGestureRecognizerDirectionLeft
              向左滑动
              UISwipeGestureRecognizerDirectionUp
              向上滑动
              UISwipeGestureRecognizerDirectionDown
              向下滑动
              */
        swip.delegate = self;
        [self.view addGestureRecognizer:swip];
        
        UISwipeGestureRecognizer *swip2 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiped:)];
        swip2.direction = UISwipeGestureRecognizerDirectionRight;
        swip2.delegate = self;
        [self.view  addGestureRecognizer:swip2];
    


}
//轮播图滑动手势
-(void)swiped:(UISwipeGestureRecognizer *)gesture
{
     if (gesture.direction & UISwipeGestureRecognizerDirectionRight) {
                        NSLog(@"向右滑动");
       [self leftBtnClick:nil];
      }
     else if(gesture.direction & UISwipeGestureRecognizerDirectionLeft){
          NSLog(@"向左滑动");
         [self rightBtnClick:nil];
      }
}
- (void)didReceiveMemoryWarning{
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
