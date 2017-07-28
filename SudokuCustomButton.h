//
//  SudokuCustomButton.h
//  tefubao
//
//  Created by hzc on 15/10/28.
//  Copyright © 2015年 hzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SudokuCustomButton : LKButton

@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UIImageView *image;

/** 依照位移变换高度 */
-(void)changeHeight_weiYi:(CGFloat)weiYi;



/**显示在正在运行的样子*/
-(void)showRuningFace;

/**显示没有使用的样子*/
-(void)showStopFace;

/**动画*/
-(void)dongHua:(CGFloat)weiYi;
@end
