//
//  ZiZhuManager.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/7.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "DOSingleton.h"

@protocol  ZiZhuManagerDelegate <NSObject>
@required
-(void)ZhiZhuHeartRefresh:(NSInteger)seconds;
-(void)ZhiZhuFinish;
-(void)ZhiZhuEnd;
-(void)ZhiZhuStart_wenDu:(NSInteger)wenDu andSeconds:(NSInteger)seconds;
@end


@interface ZiZhuManager : DOSingleton
@property(nonatomic,weak) id<ZiZhuManagerDelegate> delegate;

-(void)run_dingShiSeconds:(NSInteger)seconds;
-(void)finish;
-(void)end;
@end
