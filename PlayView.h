//
//  PlayView.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/16.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  PlayBtnClickDelegate <NSObject>
@required
-(void)playBtnClick:(LKButton *)btn;

@end


@interface PlayView : UIView
@property(nonatomic,weak)id <PlayBtnClickDelegate>delegate;

-(void)showRunFace;
-(void)showHidden;

/**
 *  刷新时间标签
 *
 *  @param restSeconds 方案剩余时间（秒数）
 */
-(void)refreshTimeLabel_restSeconds:(NSInteger)restSeconds;

/**
 *  刷新进度条
 *
 *  @param restSeconds 剩余时间（秒数）
 *  @param sumSeconds  总时间  (秒数)
 */
-(void)refreshProgressView_restSeconds:(NSInteger)restSeconds
                            sumSeconds:(NSInteger)sumSeconds;
@end
