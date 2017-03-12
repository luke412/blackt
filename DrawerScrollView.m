//
//  DrawerScrollView.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/2/26.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  温暖界面抽屉视图
#import "DrawerScrollView.h"
@implementation DrawerScrollView 

-(void)awakeFromNib{
    [super awakeFromNib];
    [self  dataBaseRefresh];
    NSArray *subViews = self.chouTiScrollew.subviews;
    for (int i=0; i<subViews.count ;i++) {
         NSString *classStr=[NSString stringWithUTF8String:object_getClassName(subViews[i])];
        if ([classStr isEqualToString:@"DrawerDeviceImage"] && i==0) {
            DrawerDeviceImage *imageBtn = (DrawerDeviceImage *)subViews[0];
            imageBtn.isSelected = YES;
            [LKDataBaseTool sharedInstance].showMac = imageBtn.deviceMac;
        }else{
            DrawerDeviceImage *imageBtn = (DrawerDeviceImage *)subViews[i];
            imageBtn.isSelected = NO;

        }
    }

    

    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chouTiImageClick:)];
    self.chouTiImage.userInteractionEnabled = YES;
    tap.delegate = self;
    [self.chouTiImage addGestureRecognizer:tap];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(userSelectImageBtn:) name:@"userSelectImageBtn" object:nil];
     [nc addObserver:self selector:@selector(BindingSuccess:) name:@"BindingSuccess" object:nil];
}

//数据库发生变化刷新
-(void)dataBaseRefresh{
    CGFloat DrawerScrollView_MAX_WIDTH = WIDTH_lk-20;           //抽屉的最大宽度
    CGFloat subSrollView_MAX_WIDTH     = DrawerScrollView_MAX_WIDTH - 66;
    CGFloat subSrollViewWidth          ;
    
    self.layer.masksToBounds =YES;
    self.layer.cornerRadius  =10;
    self.backgroundColor = [[LKTool  from_16To_Color:@"f6f6f6"]colorWithAlphaComponent:0.6f];
    self.chouTiScrollew .backgroundColor = [[LKTool from_16To_Color:@"f6f6f6"]colorWithAlphaComponent:0.6f];
    NSArray<ClothesModel *> *devices = [[LKDataBaseTool sharedInstance]showAllDataFromTable:nil];
    if (devices.count<=9999) {
        subSrollViewWidth     = 100*devices.count;
        for (int i=0; i<99; i++) {
            subSrollViewWidth     = 100*i;
            if (subSrollViewWidth > subSrollView_MAX_WIDTH) {
                subSrollViewWidth = 100*(i-1);
                subSrollViewWidth  = MIN(100*(i-1), 100*devices.count);
                break;
            }
        }
                            
        self.chouTiScrollew.contentSize=CGSizeMake(100*devices.count, self.frame.size.height);
        
        self.frame = CGRectMake(0,
                                HEIGHT_lk-48-self.frame.size.height-100,
                                subSrollViewWidth+66,
                                self.frame.size.height);
        self.chouTiScrollew.frame = CGRectMake(0,
                                               0,
                                               subSrollViewWidth,
                                               self.frame.size.height);
        
        //清除旧的视图
        for (UIView *subView in self.chouTiScrollew.subviews) {
            [subView removeFromSuperview];
        }
        
        for (int i=0; i<devices.count; i++) {
            DrawerDeviceImage *imageBtn = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"DrawerDeviceImage" owner:self options:nil] lastObject];
            //装填imageBtn
            ClothesModel *model =  devices[i];
            imageBtn.deviceStyle  = model.clothesStyle;
            imageBtn.deviceName   = model.clothesName;
            imageBtn.deviceMac    = model.clothesMac;
            imageBtn.frame              = CGRectMake(10+100*(i), 13.5, 90, 90);
            [self.chouTiScrollew addSubview:imageBtn];
        }
    }
    
    
    if (self.frame.origin.x>-10) {  //打开状态
        self.chouTiImage.image = [UIImage imageNamed:@"抽屉按钮开"];
    }else if(self.frame.origin.x<-10){
        self.chouTiImage.image = [UIImage imageNamed:@"抽屉按钮关"];
    }
    
    //刷新选中状态
    NSString *mac = [LKDataBaseTool sharedInstance].showMac;
    for (UIView *subView in self.chouTiScrollew.subviews) {
         NSString *classStr=[NSString stringWithUTF8String:object_getClassName(subView)];
         if ([classStr isEqualToString:@"DrawerDeviceImage"]) {
            DrawerDeviceImage *imageBtn = (DrawerDeviceImage *)subView;
            imageBtn.isSelected = NO;
            if ([imageBtn.deviceMac isEqualToString:mac]) {
                imageBtn.isSelected = YES;
            }
        }
    }
    
}
-(void)chouTiImageClick:(UITapGestureRecognizer *)tap1{
    int bindDeviceCount = 0;
    for (UIView *subView in self.chouTiScrollew.subviews) {
         NSString *classStr=[NSString stringWithUTF8String:object_getClassName(subView)];
        if ([classStr isEqualToString:@"DrawerDeviceImage"]) {
            bindDeviceCount ++;
        }
    }
    
    if (bindDeviceCount == 0) {
        [MBProgressHUD showError:@"您还没有已绑设备"];
        return;
    }
    
    
    if (self.frame.origin.x>-10) {  //打开状态
         [self disappearAnimation];
    }else if(self.frame.origin.x<-10){
        [self appearAnimation];
    }
}


-(void)appearAnimation{
    [UIView animateWithDuration:0.1 animations:^{
        self.frame=CGRectMake(0,
                              self.frame.origin.y,
                              self.frame.size.width,
                              self.frame.size.height);
    }completion:^(BOOL finished){
        self.isOpen = YES;
         self.backgroundColor = [[LKTool  from_16To_Color:@"f6f6f6"]colorWithAlphaComponent:0.6f];
        if (self.frame.origin.x>-10) {  //打开状态
            self.chouTiImage.image = [UIImage imageNamed:@"抽屉按钮开"];
        }else if(self.frame.origin.x<-10){
            self.chouTiImage.image = [UIImage imageNamed:@"抽屉按钮关"];
        }

    }];
}
-(void)disappearAnimation{

    [UIView animateWithDuration:0.1 animations:^{
        self.frame=CGRectMake(-self.frame.size.width+66,
                              self.frame.origin.y,
                              self.frame.size.width,
                              self.frame.size.height);
    } completion:^(BOOL finished) {
        self.isOpen = NO;
        self.backgroundColor = [UIColor clearColor];
        if (self.frame.origin.x>-10) {  //打开状态
            self.chouTiImage.image = [UIImage imageNamed:@"抽屉按钮开"];
        }else if(self.frame.origin.x<-10){
            self.chouTiImage.image = [UIImage imageNamed:@"抽屉按钮关"];
        }

    }];
}



//刷新子视图 -- 更新选中状态
-(void)userSelectImageBtn:(NSNotification *)notiy{
    NSUserDefaults *luke = [NSUserDefaults standardUserDefaults];
    NSString *macAndisSelected = notiy.object;
    NSArray *arr = [macAndisSelected componentsSeparatedByString:@","];
    NSString *warmState  =[luke objectForKey:@"WarmViewControllerState"];
    NSString *mac        = arr[0];
    NSString *isSelected = arr[1];
    
    if ( ![warmState isEqualToString:@"Unbundling"] ) {
        for (UIView *subView in self.chouTiScrollew.subviews) {
             NSString *classStr=[NSString stringWithUTF8String:object_getClassName(subView)];
            if ([classStr isEqualToString:@"DrawerDeviceImage"]) {
                DrawerDeviceImage *imageBtn = (DrawerDeviceImage *)subView;
                imageBtn.isSelected = NO;
                if ([imageBtn.deviceMac isEqualToString:mac]) {
                    imageBtn.isSelected = YES;
                }
            }
        }
            
            
    }
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSNotification   *notify = [[NSNotification alloc]initWithName:@"userSelectImageBtn_after" object:nil userInfo:nil];
    [nc postNotification:notify];
}
-(void)BindingSuccess:(NSNotification *)notify{
    NSString *mac = notify.object;
    for (UIView *subView in self.chouTiScrollew.subviews) {
        NSString *classStr = [NSString stringWithUTF8String:object_getClassName(subView)];
        if ([classStr isEqualToString:@"DrawerDeviceImage"]) {
            DrawerDeviceImage *imageBtn = (DrawerDeviceImage *)subView;
            if ([imageBtn.deviceMac isEqualToString:mac]) {
                 imageBtn.isSelected = YES;
                [LKDataBaseTool sharedInstance].showMac = imageBtn.deviceMac;
                
            }
            else{
                imageBtn.isSelected = NO;
                
            }
            
        }
    }

}
-(void)dealloc
{
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        //移除所有self监听的所有通知
        [nc removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
