//
//  WoDe_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/4.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  我的界面

#define woDeCellHeight 60

#import "WoDe_ViewController.h"
#import "UIImageView+WebCache.h"
#import <Photos/Photos.h>//选择多张图片
#import "ZLPhotoActionSheet.h"
#import "SDImageCache.h"
#import "SheZhi_ViewController.h"
#import "FaXin_Xiao_ViewController.h"
#import "SystemInfo_ViewController.h"
#import "MyHistoryViewController.h"
#import "UIImageView+WebCache.h"

#import "UserInfoModel.h"
#import "ZLPhotoTool.h"
#import "SheZhi_Handler.h"

@interface WoDe_ViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UITableView   *tableView_LK;
@property (nonatomic,strong) NSArray       *titleArr;
@property (nonatomic,strong) UIImageView   *touXiangImageView;
@property (nonatomic,strong) UILabel       *userNameLabel;
@property (nonatomic,strong) UserInfoModel *userModel;
@property (nonatomic,strong) UIButton *logOutBtn;
@end

@implementation WoDe_ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    UserInfoModel *userModel = [UserDefaultsUtils getCacheUserInfo];
    _userNameLabel.text = userModel.userMobile;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTittleWithText:@"我的"];
    [self createUI];
}
-(void)createUI{
    //头像
    [self.view addSubview:self.touXiangImageView];
    [self.view addSubview:self.userNameLabel];
    [self.view addSubview:self.logOutBtn];
    
    [self.view addSubview:self.tableView_LK];
    if ([self.tableView_LK respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView_LK setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView_LK respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView_LK setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self refreshUserInfo];
}

-(void)refreshUserInfo{
    UserInfoModel *userModel = [UserDefaultsUtils getCacheUserInfo];
    if (!userModel) {
        NSString *userId    = [App_Manager getUserId];
        NSString *userToken = [App_Manager getUserToken];
        NSString *deviceId  = [App_Manager getDeviceId];
         [NetWork_Manager getMyUserInfo_userId:userId userToken:userToken deviceId:deviceId
                                       Success:^(UserInfoModel *infoModel) {
                                           App_Manager.currUserInfo = infoModel;
                                            [UserDefaultsUtils saveUserInfo_UserModel:infoModel];
                                           _userNameLabel.text = infoModel.userMobile;
                                           [_touXiangImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.userImage] placeholderImage:[UIImage imageNamed:@"推文图片占位"]];
                                       } Abnormal:^(id responseObject) {
                                           
                                       } Failure:^(NSError *error) {
                                           
                                       }];
    }else{
        _userNameLabel.text = userModel.userName;
        [_touXiangImageView sd_setImageWithURL:[NSURL URLWithString:userModel.userImage] placeholderImage:[UIImage imageNamed:@"推文图片占位"]];
    }
}
#pragma mark - tableView代理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *titleStr = self.titleArr[indexPath.row];
    if ([titleStr isEqualToString:@"发现"]) {
        FaXin_Xiao_ViewController *vc = [[FaXin_Xiao_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }else if ([titleStr isEqualToString:@"消息"]){
        SystemInfo_ViewController *vc = [[SystemInfo_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *reuseIdentifier = @"reuseIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.titleArr[indexPath.row];
        cell.textLabel.textColor = [LKTool from_16To_Color:tableViewCellTextColor];
        return cell;
   
}
//返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return   lkptBiLi(woDeCellHeight);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 0.000000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        return 0.000000001;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
            {
                    [cell setSeparatorInset:UIEdgeInsetsZero];
            }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
            {
                    [cell setLayoutMargins:UIEdgeInsetsZero];
            }
}
#pragma mark - 事件
-(void)touXiangTap{//photoLibraryDesciption
     ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
        //设置最大选择数量
        actionSheet.maxSelectCount = 1;
        //设置预览图最大数目
        actionSheet.maxPreviewCount = 20;
        [actionSheet showWithSender:self
                            animate:YES
              lastSelectPhotoModels:nil
                         completion:^(NSArray<UIImage *> * selectPhotos,
                                      NSArray<ZLSelectPhotoModel *> *  selectPhotoModels) {
                         if (selectPhotos.count<1) {
                             return ;
                         }
        UIImage *touXiang = selectPhotos[0];
        [UserDefaultsUtils saveImage:touXiang withKey:TOU_XIANG_KEY];
        self.touXiangImageView.image = touXiang;
        
        //上传头像
         NSString *userid     = [App_Manager getUserId];
         NSString *usertoken  = [App_Manager getUserToken];
         NSString *deviceid   = [App_Manager getDeviceId];
         UIImage *image = touXiang;
                             LKShow(@"正在处理...");
         [NetWork_Manager upLoadUserTouXiangImage_userId:userid
                                               userToken:usertoken
                                                deviceId:deviceid
                                               userImage:image
                                                 Success:^(id responseObject) {
                                                     LKRemove;
                                                     [MBProgressHUD showSuccess:@"操作成功"];
                                                 } Abnormal:^(id responseObject) {
                                                      LKRemove;
                                                     [MBProgressHUD showError:responseObject[@"retMsg"]];
                                                 } Failure:^(NSError *error) {
                                                      LKRemove;
                                                     [MBProgressHUD showError:@"网络开小差~\(≧▽≦)/"];
                                                 }];
    }];
}
-(void)logOutClick:(UIButton *)Btn{
    WinManager *winManager = [WinManager sharedInstance];
    SheZhi_Handler *sheZhiHandler = [[SheZhi_Handler alloc]init];
    [winManager showlogOutWindow_logOut:^{
        [sheZhiHandler logOut];
    } cancal:nil];

}

#pragma mark - 懒加载
-(NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"发现",@"消息"];
    }
    return _titleArr;
}

-(UITableView *)tableView_LK{
    CGFloat tableViewY = lkptBiLi(227);
    
    CGFloat tableViewHeight = self.titleArr.count * lkptBiLi(woDeCellHeight);
    if (!_tableView_LK) {
        _tableView_LK               = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                                   tableViewY,
                                                                                   WIDTH_lk,
                                                                                   tableViewHeight) style:UITableViewStyleGrouped];
        _tableView_LK.delegate      = self;
        _tableView_LK.dataSource    = self;
        _tableView_LK.scrollEnabled = NO;
    }
    return _tableView_LK;
}
//头像
-(UIImageView *)touXiangImageView{
    CGFloat imageWidth = lkptBiLi(67);
    CGFloat imageHeight = imageWidth;
    if (!_touXiangImageView) {
        _touXiangImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH_lk/2-imageWidth/2, 64+20, imageWidth, imageHeight)];
        _touXiangImageView.layer.masksToBounds = YES;
        _touXiangImageView.layer.cornerRadius  =  imageWidth/2;
        _touXiangImageView.userInteractionEnabled = YES;
        NSString *imageParh = @"";
        [_touXiangImageView sd_setImageWithURL:[NSURL URLWithString:imageParh] placeholderImage:[UIImage imageNamed:@"推文图片占位"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touXiangTap)];
        tap.delegate                = self;
        [_touXiangImageView addGestureRecognizer:tap];
    }
    return _touXiangImageView;
}
//用户名label
-(UILabel *)userNameLabel{
    CGFloat labelWidth = 200;
    CGFloat labelHegiht = 30;
    CGFloat topBIanJu = 15;
    if (!_userNameLabel) {
        _userNameLabel               = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH_lk/2-labelWidth/2, [LKTool getBottomY:_touXiangImageView]+topBIanJu, labelWidth, labelHegiht)];
        _userNameLabel.font          = [UIFont systemFontOfSize:15];
        _userNameLabel.textColor     = [LKTool from_16To_Color:ZUI_SHEN_HUI];
        _userNameLabel.text          = @"15176416133";
        _userNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _userNameLabel;
}

-(UIButton *)logOutBtn{
    if (!_logOutBtn) {
        _logOutBtn = [[UIButton alloc]initWithFrame:CGRectMake(-2,HEIGHT_lk - lkptBiLi(83) -lkptBiLi(woDeCellHeight) , WIDTH_lk+4, lkptBiLi(woDeCellHeight))];
        [_logOutBtn addTarget:self action:@selector(logOutClick:) forControlEvents:UIControlEventTouchUpInside];
        [_logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logOutBtn setTitleColor:[LKTool from_16To_Color:ZHONG_HUI_new] forState:UIControlStateNormal];
        UIColor *color = self.tableView_LK.separatorColor;
        LKLog(@"%@",color);
        [_logOutBtn.layer setBorderColor:[LKTool from_16To_Color:CHAO_QIAN_HUI_new].CGColor];
        [_logOutBtn.layer setBorderWidth:1];
        [_logOutBtn.layer setMasksToBounds:YES];
    }
    return _logOutBtn;
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
