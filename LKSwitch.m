//
//  LKSwitch.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/3/2.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "LKSwitch.h"

@implementation LKSwitch
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(HeartBeatRefresh:)          name:@"HeartBeatRefresh" object:nil];
        [nc addObserver:self selector:@selector(HeartBeatRefresh_nil)       name:@"HeartBeatRefresh_nil" object:nil];
    }
    return self;
}

-(void)HeartBeatRefresh_nil{
    dispatch_async(dispatch_get_main_queue(), ^{
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    if (![[HeatingClothesBLEService sharedInstance]queryIsBLEConnected:showMac]) {
        self.on = NO;   //如果未连接 就将开关设为关闭状态
        return;
    }
    

});
   
    
}

-(void)HeartBeatRefresh:(NSNotification *)notify{
    NSLog(@"够酷的声音：%@",[NSThread currentThread]) ;
    WarmShowInfoModel *model = notify.object;
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[HeatingClothesBLEService sharedInstance]queryIsBLEConnected:showMac]) {
            self.on = NO;   //如果未连接 就将开关设为关闭状态
            return;
        }
        if (![model.mac isEqualToString:showMac]) {
            return;
        }
        if (model.remainingTime == 0) {
            self.on = NO;   //如果时间到了 就将开关设为关闭状态
            return;
        }
        else if (model.remainingTime >10000) {
            self.on = YES;
        }else if(model.remainingTime >0 && model.remainingTime <10000){
            self.on = YES;
            
        }
    });
    
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
