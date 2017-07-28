//
//  LKImageBtn.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/21.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKImageBtn : UIButton
/** 动画有效的最大位移 */
@property(nonatomic,assign)CGFloat maxWeiYi;


-(instancetype)initWithFrame:(CGRect)frame
                    andTitle:(NSString *)title
                    andImage:(UIImage *)image;


/**显示在正在运行的样子*/
-(void)showRuningFace;

/**显示没有使用的样子*/
-(void)showStopFace;

/**动画 */
-(void)dongHua:(CGFloat)weiYi;

@end
