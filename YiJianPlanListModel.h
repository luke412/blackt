//
//  YiJianPlanListModel.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/13.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YiJianPlanListModel : NSObject

/**预制方案ID Long类型 */
@property(nonatomic,copy)NSString *schemeId;

/** 预制方案名称*/
@property(nonatomic,copy)NSString *schemeName;

/**图片*/
@property(nonatomic,copy)NSString *drugbagLocationPic;

/**使用人数*/
@property(nonatomic,assign)NSInteger usingCount;
@end
