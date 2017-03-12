//
//  LKnameLabel.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/3/6.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "LKnameLabel.h"

@implementation LKnameLabel

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(HeartBeatRefresh_nil) name:@"HeartBeatRefresh_nil" object:nil];
        [nc addObserver:self selector:@selector(HeartBeatRefresh:)    name:@"HeartBeatRefresh" object:nil];
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)HeartBeatRefresh_nil{
    dispatch_async(dispatch_get_main_queue(), ^{
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    if (![[HeatingClothesBLEService sharedInstance] queryIsBLEConnected:showMac]) {
        self.text=@"";
    }
    
    
    NSDictionary *deviceDic = [LKPopupWindowManager sharedInstance].nameDictionary;
    
    
    NSString *name;
    for (NSString  *macStr in deviceDic.allKeys) {
        if ([macStr isEqualToString:showMac]) {
            name = [deviceDic objectForKey:macStr];
        }
    }
    self.text = name;

});

}
-(void)HeartBeatRefresh:(NSNotification *)notify{
    NSString *showMac = [LKDataBaseTool sharedInstance].showMac;
    NSDictionary *deviceDic = [LKPopupWindowManager sharedInstance].nameDictionary;
    
    NSString *name;
    for (NSString  *macStr in deviceDic.allKeys) {
        if ([macStr isEqualToString:showMac]) {
            name = [deviceDic objectForKey:macStr];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.text = name;
        if (name == nil) {
            self.text = @"";
        }
    });
}

-(void)dealloc
{
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        //移除所有self监听的所有通知
        [nc removeObserver:self];
}

@end
