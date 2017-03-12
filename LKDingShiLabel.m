//
//  LKDingShiLabel.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/3/2.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "LKDingShiLabel.h"

@implementation LKDingShiLabel
{
    int timeStopCount;       //时间停止累计数

}
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self){
        //注册监听
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(ConnectionSuccessful_warm:) name:@"ConnectionSuccessful_warm" object:nil];
        [nc addObserver:self selector:@selector(HeartBeatRefresh:)          name:@"HeartBeatRefresh" object:nil];
        [nc addObserver:self selector:@selector(userSelectImageBtn_after)          name:@"userSelectImageBtn_after" object:nil];
        [nc addObserver:self selector:@selector(HeartBeatRefresh_nil)          name:@"HeartBeatRefresh_nil" object:nil];
        
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:15];
        
    }
    return self;
}



#pragma mark 通知响应   15分钟  --120分钟 UnbundlingSuccess
-(void)UnbundlingSuccess:(NSNotification *)notify{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *mac = [LKDataBaseTool sharedInstance].showMac;
        if (![[HeatingClothesBLEService sharedInstance]queryIsBLEConnected:mac]) {
            self.text=@"";
        }

    });
    
    
    
    
    
    
}

-(void)userSelectImageBtn_after{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
        if (![[HeatingClothesBLEService sharedInstance]queryIsBLEConnected:showMac]) {
            self.text=@"";
            return;
        }

    });
    
    
    

}
-(void)HeartBeatRefresh_nil{
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[HeatingClothesBLEService sharedInstance]queryIsBLEConnected:showMac]) {
            self.text=@"";
            return;
        }
    });

}
-(void)HeartBeatRefresh:(NSNotification *)notify{
    WarmShowInfoModel *model = notify.object;
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[HeatingClothesBLEService sharedInstance]queryIsBLEConnected:showMac]) {
            self.text=@"";
            return;
        }
        
        if (![model.mac isEqualToString:showMac]) {
            return;
        }
        
        
        float shengYuTime = model.remainingTime;    //秒数
        if (shengYuTime == 0) {
            self.text=@"";
        }else{
            int miaoshu =(int)shengYuTime;
            int xiaoShi = miaoshu / 3600;
            if (xiaoShi > 2) {
                self.text = @"";
                return;
            }
            
            int fenZhongShu = (miaoshu - (xiaoShi*3600))/60;
            int miaoshu2 = miaoshu - xiaoShi*3600 - fenZhongShu*60;
            NSString  *timeStr = [NSString stringWithFormat:@"%.2d:%.2d:%.2d",xiaoShi,fenZhongShu,miaoshu2];
            self.text = timeStr;
            
        }

    });
    
}

-(void)ConnectionSuccessful_warm:(NSNotification *)notify{
    NSString *mac = notify.object;
    
}
-(void)dealloc
{
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
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
