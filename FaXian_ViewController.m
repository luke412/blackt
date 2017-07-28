//
//  FaXian_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/4.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  发现界面

#import "FaXian_ViewController.h"
#import "JiBu_ViewController.h"
#import "Location_ViewController.h"
#import "YiJianGongNeng_ViewController.h"

#import "SudokuCustomButton.h"
#import "GuangGaoModel.h"
#import "UIImageView+WebCache.h"
#import "GuangGaoURL_ViewController.h"
#import "LKImageBtn.h"

@interface FaXian_ViewController ()<UIScrollViewDelegate>
{
    NSArray *titleArr;
    NSArray <NSString *>            *btnImageNameArr;
    NSMutableArray <GuangGaoModel*>*dataSource;
    UIView                          *btnBackView;    //三按钮父视图
    
    CGFloat  selfBtnHeight;  //三按钮原始的高度
    CGFloat  backHeight   ;  //三按钮背景原始高度
    
    UIImageView *moRenImage;  //占位图
}
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray <LKImageBtn *>*btnArr;
@end

@implementation FaXian_ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    for (NSInteger i = 0 ; i<_btnArr.count; i++) {
        LKImageBtn *btn = _btnArr[i];
        [btn showStopFace];
        if (App_Manager.heatState ==  YiJian_heat && i == 1) {
                [btn showRuningFace];
        }
    }
    
    self.view.backgroundColor = [LKTool from_16To_Color:BACK_COLOR_new];
     [self createRequest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _btnArr = [[NSMutableArray alloc]init];
    dataSource = [[NSMutableArray alloc]init];
    [self setTittleWithText:@"发现"];
   
    [self createUI];
}
-(void)createRequest{
    NSString *userid = [App_Manager getUserId];
    NSString *token  = [App_Manager getUserToken];
    NSString *deviceid = [App_Manager getDeviceId];
    [NetWork_Manager chaXunZuiXinGuangGao_userId:userid
                                       userToken:token
                                        deviceId:deviceid
                                         Success:^(NSArray<GuangGaoModel *> *arr) {
                                             [dataSource removeAllObjects];
                                             [dataSource addObjectsFromArray:arr];
                                             [self createImage];
                                         } Abnormal:^(id responseObject) {
                                             [MBProgressHUD showError:responseObject[@"retMsg"]];
                                         } Failure:^(NSError *error) {
                                              [MBProgressHUD showError:@"网络开小差~\(≧▽≦)/"];
                                         }];
}
-(void)createUI{
    //添加顶部按钮
    CGFloat leftBianJu = lkptBiLi(5);
    CGFloat topBianJu  = lkptBiLi(10);
    CGFloat kuanGaoBi  = 1.11;
    CGFloat btnWidth   = (WIDTH_lk -(leftBianJu * 4))/3;
    CGFloat btnHeight  = floorf(btnWidth/kuanGaoBi);
    
    
    titleArr        = @[@"位置",@"一键功能",@"运动"];
    btnImageNameArr = @[@"位置_new",@"一键功能",@"运动"];
    btnBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH_lk, btnHeight + lkptBiLi(10)*2)];
    backHeight  = btnHeight + lkptBiLi(10)*2;
    for (NSInteger i=0; i<3; i++) {
         NSString *imageName    = btnImageNameArr[i];
        LKImageBtn *imageBtn = [[LKImageBtn alloc]initWithFrame:CGRectMake(leftBianJu + (leftBianJu + btnWidth)*i,
                                                                          topBianJu,
                                                                          btnWidth,
                                                                          btnHeight)
                                                       andTitle:[titleArr objectAtIndex:i]
                                                       andImage:[UIImage imageNamed:imageName]];
        selfBtnHeight = btnHeight;
        imageBtn.layer.cornerRadius = 5;
        imageBtn.tag = i;
        [imageBtn showStopFace];
        [imageBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        imageBtn.backgroundColor = [UIColor whiteColor];
        [_btnArr addObject:imageBtn];
        [btnBackView addSubview:imageBtn];
    }
     [self.view addSubview:btnBackView];
     [self.view addSubview:self.scrollView];
}

-(void)createImage{
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    [moRenImage removeFromSuperview];
    
    //添加图片
     CGFloat imageKuanGaoBi = 640.0/350.0;
    CGFloat leftBianJu = lkptBiLi(5);
    CGFloat topBianJu  = lkptBiLi(10);
    CGFloat kuanGaoBi  = 1.11;
    CGFloat btnWidth   = (WIDTH_lk -(leftBianJu * 4))/3;
    CGFloat btnHeight  = floorf(btnWidth/kuanGaoBi);

    CGFloat imageWidth            = WIDTH_lk;
    CGFloat imageHeight           = floorf(imageWidth/imageKuanGaoBi);
    CGFloat imageJianJu           = lkptBiLi(5);
    CGFloat scrollView_SizeHeight = topBianJu*2+btnHeight+(imageJianJu+imageHeight)*dataSource.count;
    CGFloat imageY                = topBianJu*2+btnHeight;
    self.scrollView.contentSize   = CGSizeMake(WIDTH_lk, scrollView_SizeHeight);
    for (NSInteger i = 0; i<dataSource.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,i*(imageHeight+imageJianJu), imageWidth, imageHeight)];
        GuangGaoModel *model   = dataSource[i];
        NSString *imagePath    = model.adPicture;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"推文图片占位"]];
        imageView.userInteractionEnabled = YES;
        LKButton *btn = [[LKButton alloc]initWithFrame:imageView.bounds];
        btn.backgroundColor = [UIColor clearColor];
        [btn lk_addActionforControlEvents:UIControlEventTouchUpInside
                              ActionBlock:^{
                                  GuangGaoURL_ViewController *vc = [[GuangGaoURL_ViewController alloc]init];
                                  vc.url = model.adHyperlink;
                                  [self.navigationController pushViewController:vc animated:NO];
                              }];
        [imageView addSubview:btn];
        [self.scrollView addSubview:imageView];
    }
}

#pragma mark - 顶部按钮事件
-(void)click:(id)sender{
    UIButton *btn = (UIButton*)sender;
    NSString *title = titleArr[btn.tag];
    if ([title isEqualToString:@"运动"]) {
        JiBu_ViewController *vc   = [[JiBu_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }else if ([title isEqualToString:@"位置"]){
        Location_ViewController *vc = [[Location_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }else if ([title isEqualToString:@"一键功能"]){
        YiJianGongNeng_ViewController *vc = [[YiJianGongNeng_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark - 滚动条代理
//scrollView滚动时，就调用该方法。任何offset值改变都调用该方法。即滚动过程中，调用多次
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidScroll");
    CGPoint point = scrollView.contentOffset;
    NSLog(@"%f,%f",point.x,point.y);
    
    //动画
    [self animation:point.y];
}

#pragma mark - 动画
-(void)animation:(CGFloat)weiYi{
    CGFloat maxWeiYi = selfBtnHeight * max_weiyi_bi;
    if (weiYi > maxWeiYi) {
        weiYi = maxWeiYi;
    }else if (weiYi < 0 ){
        weiYi = 0;
    }
    
    for (LKImageBtn *btn in _btnArr) {
        btn.maxWeiYi =maxWeiYi;
        [btn dongHua:weiYi];
    }
    [LKTool setView_Height:backHeight - weiYi andView:btnBackView];
    [LKTool setView_Y: [LKTool getBottomY:btnBackView] andView:_scrollView];
}
#pragma mark - 懒加载
-(UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView                 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, [LKTool getBottomY:btnBackView], WIDTH_lk, HEIGHT_lk - 64-48)];
        _scrollView.contentSize     = CGSizeMake(WIDTH_lk,HEIGHT_lk - 64-48);
        _scrollView.backgroundColor = [LKTool from_16To_Color:BACK_COLOR_new];
        _scrollView.delegate        = self;
        //372 * 242
        CGFloat bili = 372.0/242.0;
        moRenImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH_lk/2-372/2/2, 120, 372.0/2, 242.0/2)];
        moRenImage.image = [UIImage imageNamed:@"发现界面占位图"];
        [_scrollView addSubview:moRenImage];
    }
    return _scrollView;
}

-(void)didReceiveMemoryWarning {
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
