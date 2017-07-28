//
//  YiJianPlanXiangQing_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/13.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  一键理疗详情界面

#import "YiJianPlanXiangQing_ViewController.h"
#import "BenFangAn.h"
#import "ShiHeRenQunView.h"
#import "PlayView.h"
#import "BlueManager.h"
#import "YiJianManager.h"
#import "YiJianPlanModel.h"
#import "UIImageView+WebCache.h"
#import "ZiZhuManager.h"
#import "DataBaseManager.h"
#import "TianJia_ViewController.h"


@interface YiJianPlanXiangQing_ViewController () <PlayBtnClickDelegate,YiJianManagertDelegate>
@property(nonatomic,strong)BenFangAn       *benFangAn;
@property(nonatomic,strong)ShiHeRenQunView *shiHeRenQunView;
@property(nonatomic,strong)UIImageView     *topImageView;
@property(nonatomic,strong)UIScrollView    *scrollView;
@property(nonatomic,strong)PlayView        *playView;

@property(nonatomic,strong)UIBarButtonItem  *rightItem;
@property(nonatomic,strong)YiJianPlanModel *selfModel;

@property(nonatomic,strong)YiJianPlanModel *currPlan;
@end

@implementation YiJianPlanXiangQing_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YiJian_Manager.delegate = self;
    [self  setTittleWithText:self.titleText];
    
   
    self.view.backgroundColor = [LKTool from_16To_Color:BACK_COLOR_new];
    
    //加载方案详情
    NSString *userid    = [App_Manager getUserId];
    NSString *userToken = [App_Manager getUserToken];
    NSString *deviceid  = [App_Manager getDeviceId];
    NSString *schemeId  = self.schemeId;
    LKShow(@"正在加载...");
    [NetWork_Manager loadYiJianPlan_userId:userid
                                 userToken:userToken
                                  deviceId:deviceid
                                  schemeId:schemeId
                                   Success:^(YiJianPlanModel *model) {
                                       LKRemove;
                                       if (model) {
                                           _selfModel = model;
                                           [self loadUI_model:model];
                                       }
                                       //恢复现场
                                       if ([model.schemeName isEqualToString:self.titleText]) {
                                           [self huiFu];
                                       }
                                   } Abnormal:^(id responseObject) {
                                        LKRemove;
                                       [MBProgressHUD  showError:responseObject[@"retMsg"]];
                                   } Failure:^(NSError *error) {
                                        LKRemove;
                                       [MBProgressHUD  showError:@"网络开小差~\(≧▽≦)/"];
                                   }];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    //右按钮
    if (App_Manager.heatState == YiJian_heat && [self.schemeId isEqualToString:YiJian_Manager.currPlan.schemeId]) {
        self.navigationItem.rightBarButtonItem = nil;
        [self.playView showRunFace];
    }else{
        self.navigationItem.rightBarButtonItem = self.rightItem;
        [self.playView showHidden];
    }
    if (self.playView.hidden == NO) {
        [self.view bringSubviewToFront:self.playView];
    }
}
//如果有进程在进行，恢复现场
-(void)huiFu{
    if (App_Manager.heatState == YiJian_heat && [self.schemeId isEqualToString:YiJian_Manager.currPlan.schemeId]) {
        [self.playView showRunFace];
    }
    [self.view bringSubviewToFront:self.playView];
}


-(void)loadUI_model:(YiJianPlanModel *)model{
    self.currPlan = model;
    [self.benFangAn refreshUI_Model:model];
    [self.shiHeRenQunView refreshUI_Model:model];
    [self.playView showHidden];
    
    //重新计算scrollow的内部尺寸
    CGFloat topBianju             = lkptBiLi(10)*3;
    CGFloat topImageHegiht        = self.topImageView.frame.size.height;
    CGFloat benFanAnViewHeight    = self.benFangAn.frame.size.height;
    CGFloat shiheRenQunViewHeight = self.shiHeRenQunView.frame.size.height;

    self.scrollView.contentSize   = CGSizeMake(self.scrollView.contentSize.width,
                                             topBianju + topImageHegiht +benFanAnViewHeight+shiheRenQunViewHeight);
    
    //将播放视图移到最顶端
    if (self.playView.hidden == NO) {
        [self.view bringSubviewToFront:self.playView];
    }
}


#pragma mark - 代理方法
#pragma mark 播放键点击
-(void)playBtnClick:(LKButton *)btn{
    if (App_Manager.heatState == YiJian_heat) {
        NSString *name = self.currPlan.schemeName;
        [Win_Manager showTuiChuWindiw_name:name
                                   queDing:^{
                                       [YiJian_Manager end];
                                   } quXiao:^{
                                       
                                   }];
    }
}

//理疗开始
-(void)startRun:(NSInteger)restSeconds{
    [self.playView showRunFace];
    [self.view bringSubviewToFront:self.playView];
    self.navigationItem.rightBarButtonItem = nil;
    [self.playView refreshTimeLabel_restSeconds:restSeconds];
}

//理疗结束
-(void)end{
     [MBProgressHUD showSuccess:@"已结束"];
     self.navigationItem.rightBarButtonItem = self.rightItem;
     [self.playView refreshTimeLabel_restSeconds:0];
     [self.playView showHidden];
}

//理疗完成
-(void)finish{
    self.navigationItem.rightBarButtonItem = self.rightItem;
    [self.playView refreshTimeLabel_restSeconds:0];
    [self.playView showHidden];
}

-(void)refreshEveryTime:(NSInteger)restSeconds sumSecond:(NSInteger)sumSecond{
    [self.playView refreshTimeLabel_restSeconds:restSeconds];
    [self.playView refreshProgressView_restSeconds:restSeconds sumSeconds:sumSecond];
}
#pragma mark - 用户事件
//启动理疗
-(void)rightButtonClick{
    if ([DataBase_Manager isHaveBoundDevice] == NO) {
        [Win_Manager MeibangDing_bangDing:^{
                                            TianJia_ViewController *vc = [[TianJia_ViewController alloc]init];
                                            [self.navigationController pushViewController:vc animated:NO];
                                        } quXiao:nil];
        return;
    }
    //自助调温装填
    if (App_Manager.heatState == Zizhu_heat) {
        [Win_Manager showTuiChuWindiw_name:@"自助"
                                   queDing:^{
                                       [ZiZhu_Manager end];
                                       NSString *currMac = App_Manager.currDevice.clothesMac;
                                        LKShow(@"正在连接...");
                                       [Blue_Manager smartctionWithMac:currMac
                                                                Sucess:^(NSString *mac) {
                                                                    LKRemove;
                                                                    [YiJian_Manager planRun_Model:self.selfModel];
                                                                } Failure:^(NSString *mac) {
                                                                    LKRemove;
                                                                    [MBProgressHUD showError:@"连接失败"];
                                                                } andIsRunDelegate:YES];

                                   } quXiao:^{
                                       
                                   }];

        
    }
    //一键理疗状态
    else if(App_Manager.heatState == YiJian_heat ){
        [Win_Manager showTuiChuWindiw_name:YiJian_Manager.currPlan.schemeName
                                   queDing:^{
                                       [YiJian_Manager end];
                                       NSString *currMac = App_Manager.currDevice.clothesMac;
                                       LKShow(@"正在连接...");
                                       [Blue_Manager smartctionWithMac:currMac
                                                                Sucess:^(NSString *mac) {
                                                                    LKRemove;
                                                                    [YiJian_Manager planRun_Model:self.selfModel];
                                                                } Failure:^(NSString *mac) {
                                                                    LKRemove;
                                                                    [MBProgressHUD showError:@"连接失败"];
                                                                } andIsRunDelegate:YES];

                                   } quXiao:^{
                                       
                                   }];
    //无操作状态
    }else{
        NSString *currMac = App_Manager.currDevice.clothesMac;
        LKShow(@"正在连接...");
        [Blue_Manager smartctionWithMac:currMac
                                 Sucess:^(NSString *mac) {
                                     LKRemove;
                                     [YiJian_Manager planRun_Model:self.selfModel];
                                 } Failure:^(NSString *mac) {
                                     LKRemove;
                                     [MBProgressHUD showError:@"连接失败"];
                                 } andIsRunDelegate:YES];
    }
}



#pragma mark - 懒加载
-(UIImageView *)topImageView{
    if (!_topImageView) {
        CGFloat imageWidth = WIDTH_lk-lkptBiLi(5)*2;
        _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(lkptBiLi(5),
                                                                     lkptBiLi(10),
                                                                     imageWidth,
                                                                     lkptBiLi(120))];
        [_topImageView sd_setImageWithURL:[NSURL URLWithString:self.imagePath]
                         placeholderImage:[UIImage imageNamed:@"推文图片占位"]];
        
        _topImageView.contentMode         = UIViewContentModeScaleAspectFill;
        _topImageView.layer.cornerRadius  = 5;
        _topImageView.layer.masksToBounds = YES;

        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imageWidth - lkptBiLi(46) - lkptBiLi(150) ,
                                                                 lkptBiLi(45),
                                                                 lkptBiLi(150),
                                                                  lkptBiLi(17))];
        label.textColor     = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentRight;
        label.text          = self.titleText;
        label.font          = [UIFont systemFontOfSize:18];
        [_topImageView addSubview:label];
        
        //备注
        CGFloat beiZhuWidth  = 180;
        UILabel *beiZhuLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageWidth - lkptBiLi(17) -beiZhuWidth ,
                                                                        lkptBiLi(73),
                                                                        beiZhuWidth,
                                                                        lkptBiLi(32))];
        beiZhuLabel.text                      = self.currPlan.remark;
        beiZhuLabel.textAlignment             = NSTextAlignmentLeft;
        beiZhuLabel.textColor                 = [UIColor whiteColor];
        beiZhuLabel.numberOfLines             = 0;
        beiZhuLabel.font = [UIFont systemFontOfSize:12];
        [_topImageView addSubview:beiZhuLabel];
        CGRect myFrame = LKMakeRect_Font_Text_Frame(12, beiZhuLabel.text, imageWidth - lkptBiLi(17) -beiZhuWidth, lkptBiLi(73),imageWidth - lkptBiLi(17)*2 , lkptBiLi(48));
        beiZhuLabel.frame = CGRectMake(imageWidth- lkptBiLi(17) - myFrame.size.width, myFrame.origin.y, myFrame.size.width, myFrame.size.height);
        [self.scrollView addSubview:_topImageView];
    }
    return _topImageView;
}
-(BenFangAn *)benFangAn{
    if (!_benFangAn) {
         _benFangAn = [[[NSBundle mainBundle]loadNibNamed:@"BenFangAn" owner:nil options:nil]firstObject];
        [self.scrollView addSubview:_benFangAn];
        _benFangAn.frame = CGRectMake(lkptBiLi(5),
                                      [LKTool getBottomY:self.topImageView]+lkptBiLi(10),
                                      WIDTH_lk-lkptBiLi(5)*2,
                                      _benFangAn.height);
    }
    return _benFangAn;
}

-(ShiHeRenQunView *)shiHeRenQunView{
    if (!_shiHeRenQunView) {
        _shiHeRenQunView = [[[NSBundle mainBundle]loadNibNamed:@"ShiHeRenQunView" owner:nil options:nil]firstObject];
        _shiHeRenQunView.frame = CGRectMake(lkptBiLi(5),
                                            [LKTool getBottomY:self.benFangAn]+lkptBiLi(15),
                                            WIDTH_lk-lkptBiLi(5)*2,
                                            _shiHeRenQunView.height);
        [self.scrollView addSubview:_shiHeRenQunView];
    }
    return _shiHeRenQunView;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,
                                                                    64,
                                                                    WIDTH_lk,
                                                                    HEIGHT_lk-64)];
        _scrollView.contentSize = CGSizeMake(lkptBiLi(10), lkptBiLi(lkptBiLi(800)));
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}
-(PlayView *)playView{
    if (!_playView) {
        _playView = [[[NSBundle mainBundle]loadNibNamed:@"PlayView" owner:nil options:nil]firstObject];
        _playView.frame = CGRectMake(0,
                                     HEIGHT_lk-lkptBiLi(50),
                                     WIDTH_lk,
                                     lkptBiLi(50));
        _playView.delegate = self;
        [self.view addSubview:_playView];
    }
    return _playView;
}

-(UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,38,30)];
        [rightButton setTitleColor:[LKTool from_16To_Color:ZHONG_HUI_new] forState:UIControlStateNormal];
        [rightButton setTitle:@"使用" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightButtonClick)forControlEvents:UIControlEventTouchUpInside];
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    }
    return _rightItem;
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
