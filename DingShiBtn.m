//
//  DingShiBtn.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/3/1.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  定时按钮

#import "DingShiBtn.h"

@implementation DingShiBtn

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self){
        
    }
    return self;
}
-(void)reloadUI{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(HeartBeatRefresh:)  name:@"HeartBeatRefresh" object:nil];
    [nc addObserver:self selector:@selector(HeartBeatRefresh_nil)  name:@"HeartBeatRefresh_nil" object:nil];

}
-(void)HeartBeatRefresh_nil{
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    
    //返回主线程绘制UI
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[HeatingClothesBLEService  sharedInstance]queryIsBLEConnected:showMac]) {
            self.isSeted = NO;
            return;
        }
        
    });
}

-(void)HeartBeatRefresh:(NSNotification *)notify{
    WarmShowInfoModel *model = notify.object;
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    
    //返回主线程绘制UI
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![model.mac isEqualToString:showMac]) {
            return;
        }
        
        float shengYuShiJian = model.remainingTime;
        if (![[HeatingClothesBLEService  sharedInstance]queryIsBLEConnected:showMac]) {
            self.isSeted = NO;
            return;
        }
        if (shengYuShiJian == 0){
            self.isSeted = NO;
        }else{
            self.isSeted =YES;
        }
        
        
        
        
        if (model.remainingTime == 0) {
            self.isSeted = NO;   //如果时间到了 就将开关设为关闭状态
            return;
        }
        else if (model.remainingTime >10000) {
            self.isSeted = NO;
        }else if(model.remainingTime >0 && model.remainingTime <10000){
            self.isSeted = YES;
            
        }
        
    });
}


-(void)setIsSeted:(BOOL)isSeted{
    _isSeted = isSeted;
    if (_isSeted == YES) {
        self.btnImageView.image=[UIImage imageNamed:@"已定时按钮"];
        self.leftImageView.image = [UIImage imageNamed:@"已定时时钟"];
        self.zhuangtaiLabel.text=@"已定时";
        self.zhuangtaiLabel.textColor = [LKTool from_16To_Color:@"ffffff"];
    }else{
        self.btnImageView.image=[UIImage imageNamed:@"未定时按钮"];
        self.leftImageView.image = [UIImage imageNamed:@"未定时时钟"];
        self.zhuangtaiLabel.text=@"未定时";
        self.zhuangtaiLabel.textColor = [LKTool from_16To_Color:@"f4527c"];

    }
}

-(void)dealloc{
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
