//
//  YingYanManager.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/14.
//  Copyright © 2017年 鲁柯. All rights reserved.
//
typedef void(^QueryCacheTrackBlock)(NSDictionary *responseDic);
typedef void(^QueryHistoryTrackBlock)(NSDictionary *responseDic);
typedef void(^EntitySearch)(NSDictionary *responseDic);
typedef void(^QueryTrackLatestPointBlock)(NSDictionary *responseDic,NSString *userid);


#import <Foundation/Foundation.h>
#import "BaiduTraceSDK/BaiduTraceSDK.h"
@interface YingYanManager : NSObject <BTKTraceDelegate, BTKFenceDelegate, BTKTrackDelegate, BTKEntityDelegate>

#pragma makr  - 开启关闭鹰眼 
-(void)startYingYan_EntityName:(NSString *)entityName;
-(void)stopYingYan;

#pragma mark - 开始采集
/**开始采集*/
-(void)startGather;
/**停止采集*/
-(void)stopGather;



#pragma mark  - 查询缓存信息

/**
 *  查询缓存信息
 *
 *  @param queryCacheBlock 查询完成后的回调
 */
-(void)queryTrackCacheInfo_QueryCacheBlock:(QueryCacheTrackBlock)queryCacheBlock;


/**
 *  清除指定缓存信息
 *
 *  @param startTime 清除区间左值 （时间戳）
 *  @param endTime   清除区间右值  
 */
-(void)clearTrackCacheInfo_startTime:(NSUInteger)startTime endTime:(NSUInteger)endTime;



/**
 *  关键字搜索实体设备
 *
 *  @param Keyword 关键字
 *  @param entitySearchBlock 返回所有符合条件的实体
 */
-(void)searchEntityWithKeyword:(NSString *)Keyword
                      complete:(EntitySearch)entitySearchBlock;


/**
 *  获取实时位置
 *
 *  @param Keyword                    关键字
 *  @param queryTrackLatestPointBlock 回调
 */
-(void)queryTrackLatestPoint_Keyword:(NSString *)Keyword
                            complete:(QueryTrackLatestPointBlock)queryTrackLatestPointBlock;
@end
