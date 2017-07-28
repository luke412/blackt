//
//  LKTextTool.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/24.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "LKTextTool.h"

@implementation LKTextTool
+(CGRect)makeRect_Font:(CGFloat)fontSize
                  text:(NSString *)text
                origin:(CGPoint)origin
     constrainedToSize:(CGSize)constrainedToSize{
    
    
    CGRect infoRect = [text boundingRectWithSize:constrainedToSize
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]}
                                         context:nil];
    
    // 参数1: 自适应尺寸,提供一个宽度,去自适应高度
    // 参数2:自适应设置 (以行为矩形区域自适应,以字体字形自适应)
    // 参数3:文字属性,通常这里面需要知道是字体大小
    // 参数4:绘制文本上下文,做底层排版时使用,填nil即可
      
    //向上取整
    return CGRectMake(ceil(origin.x) ,
                      ceil(origin.y) ,
                      ceil(infoRect.size.width),
                      ceil(infoRect.size.height));
}
@end
