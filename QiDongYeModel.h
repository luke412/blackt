//
//  QiDongYeModel.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/26.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QiDongYeModel : NSObject
/**伪启动页ID Integer类型 */
@property(nonatomic,assign)NSInteger adId;

/**标题*/
@property(nonatomic,copy)NSString *adTitle;

/**图片 http://xxx.jpg */
@property(nonatomic,copy)NSString  *adPicture;

/** 跳转URL地址 */
@property(nonatomic,copy)NSString *adHyperlink;

/** 展示秒数 Integer类型*/
@property(nonatomic,assign)NSInteger showSeconds;

@end
