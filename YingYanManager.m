//
//  YingYanManager.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/14.
//  Copyright © 2017年 鲁柯. All rights reserved.
//




#import "YingYanManager.h"
@interface YingYanManager ()
/**查询缓存轨迹*/
@property (nonatomic,copy)QueryCacheTrackBlock  queryCacheBlock;
/**查询轨迹*/
@property (nonatomic,copy)QueryHistoryTrackBlock  queryHistoryTrackBlock;
/**搜索实体设备*/
@property(nonatomic,copy)EntitySearch      entitySearchBlock;
/**实时位置*/
@property(nonatomic,copy)QueryTrackLatestPointBlock  queryTrackLatestPointBlock;

/**当前查询者的userid*/
@property(nonatomic,copy)NSString *userid;
@end



@implementation YingYanManager
#pragma mark - 开启关闭
-(void)startYingYan_EntityName:(NSString *)entityName{

    
    
    BTKStartServiceOption *op = [[BTKStartServiceOption alloc] initWithEntityName:entityName];
    // 开启服务
    [[BTKAction sharedInstance] startService:op delegate:self];
}
-(void)stopYingYan{
    [[BTKAction sharedInstance] stopService:self];
}




#pragma mark - 开始采集
/**开始采集*/
-(void)startGather{
    [[BTKAction sharedInstance] startGather:self];
    [[BTKAction sharedInstance] changeGatherAndPackIntervals:5 packInterval:10 delegate:self];
}
/**停止采集*/
-(void)stopGather{
    [[BTKAction sharedInstance] stopGather:self];
}




#pragma mark - 查询缓存信息
-(void)queryTrackCacheInfo_QueryCacheBlock:(QueryCacheTrackBlock)queryCacheBlock{
    // 构造请求对象
    BTKQueryTrackCacheInfoRequest *request = [[BTKQueryTrackCacheInfoRequest alloc] initWithEntityNames:nil serviceID:BaiDuYingYanSeverID tag:333];
    // 发起请求
    [[BTKTrackAction sharedInstance] queryTrackCacheInfoWith:request delegate:self];
    self.queryCacheBlock = queryCacheBlock;
}




#pragma mark - 清除指定缓存信息
-(void)clearTrackCacheInfo_startTime:(NSUInteger)startTime
                             endTime:(NSUInteger)endTime{
    // 设置entityA名下，要清空的轨迹缓存的起止时间
    BTKClearTrackCacheOption *op1      = [[BTKClearTrackCacheOption alloc] initWithEntityName:@"entityA" startTime:startTime endTime:endTime];
    // 设置清空的条件
    NSMutableArray *options            = [NSMutableArray arrayWithCapacity:2];
    [options addObject:op1];
    // 构造请求对象
    BTKClearTrackCacheRequest *request = [[BTKClearTrackCacheRequest alloc] initWithOptions:options serviceID:BaiDuYingYanSeverID tag:33];
    // 发起请求
    [[BTKTrackAction sharedInstance] clearTrackCacheWith:request delegate:self];
}



#pragma mark - 查询某个时段内的轨迹
-(void)queryHistoryTrack_startTime:(NSUInteger)startTime
                           endTime:(NSUInteger)endTime
                          complete:(QueryHistoryTrackBlock)queryHistoryTrackBlock
{    // 构造请求对象
    // 设置纠偏选项
//    BTKQueryTrackProcessOption *option = [[BTKQueryTrackProcessOption alloc] init];
//    option.denoise = TRUE;
//    option.mapMatch = TRUE;
//    option.radiusThreshold = 10;
    
    BTKQueryHistoryTrackRequest *request = [[BTKQueryHistoryTrackRequest alloc] initWithEntityName:@"entityA" startTime:startTime
                                                                                           endTime:endTime
                                                                                       isProcessed:TRUE
                                                                                     processOption:nil
                                                                                    supplementMode:BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_WALKING
                                                                                   outputCoordType:BTK_COORDTYPE_BD09LL
                                                                                          sortType:BTK_TRACK_SORT_TYPE_DESC
                                                                                         pageIndex:1
                                                                                          pageSize:10
                                                                                         serviceID:BaiDuYingYanSeverID
                                                                                               tag:13];
    // 发起查询请求
    [[BTKTrackAction sharedInstance] queryHistoryTrackWith:request delegate:self];
    self.queryHistoryTrackBlock = queryHistoryTrackBlock;
}

#pragma mark - 实时位置 （关键字检索）
-(void)searchEntityWithKeyword:(NSString *)Keyword
                      complete:(EntitySearch)entitySearchBlock{
    // 设置过滤条件
    BTKQueryEntityFilterOption *filterOption   = [[BTKQueryEntityFilterOption alloc] init];
    filterOption.activeTime                    = [[NSDate date] timeIntervalSince1970] - 7 * 24 * 3600;
    //设置排序条件，返回的多个entity按照，定位时间'loc_time'的倒序排列
    BTKSearchEntitySortByOption * sortbyOption = [[BTKSearchEntitySortByOption alloc] init];
    sortbyOption.fieldName                     = @"loc_time";
    sortbyOption.sortType                      = BTK_ENTITY_SORT_TYPE_DESC;
    //构造请求对象
    BTKSearchEntityRequest *request = [[BTKSearchEntityRequest alloc] initWithQueryKeyword:Keyword
                                                                                    filter:filterOption
                                                                                    sortby:sortbyOption
                                                                           outputCoordType:BTK_COORDTYPE_BD09LL
                                                                                 pageIndex:1
                                                                                  pageSize:10
                                                                                 ServiceID:BaiDuYingYanSeverID
                                                                                       tag:34];
    // 发起检索请求
    [[BTKEntityAction sharedInstance] searchEntityWith:request delegate:self];
    self.entitySearchBlock = entitySearchBlock;
}

#pragma mark -实时位置
-(void)queryTrackLatestPoint_Keyword:(NSString *)Keyword
                            complete:(QueryTrackLatestPointBlock)queryTrackLatestPointBlock{
    NSInteger userIdInt = [Keyword integerValue];
    BTKQueryTrackProcessOption *option = [[BTKQueryTrackProcessOption alloc] init];
    option.denoise                     = TRUE;
    option.mapMatch                    = TRUE;
    option.radiusThreshold             = 0;
    
    //构造请求对象
    BTKQueryTrackLatestPointRequest *request = [[BTKQueryTrackLatestPointRequest alloc] initWithEntityName:Keyword
                                                                                             processOption: option
                                                                                           outputCootdType:BTK_COORDTYPE_BD09LL
                                                                                                 serviceID:BaiDuYingYanSeverID tag:userIdInt];
    
    //发起查询请求
    [[BTKTrackAction sharedInstance] queryTrackLatestPointWith:request delegate:self];
    self.queryTrackLatestPointBlock = queryTrackLatestPointBlock;
    self.userid = Keyword;

}

#pragma mark - 实时位置回调


/**
 实时位置查询的回调方法
 
 @param response 查询结果
 */
-(void)onQueryTrackLatestPoint:(NSData *)response{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    
    if (self.queryTrackLatestPointBlock) {
        self.queryTrackLatestPointBlock(dict,self.userid);
    }
}




#pragma mark- 实体终端搜索回调
/**
 关键字检索Entity终端实体的回调方法
 
 @param response 检索结果
 */
-(void)onEntitySearch:(NSData *)response{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];

    if (self.entitySearchBlock) {
       self.entitySearchBlock(dict);
    }
}


#pragma mark - 回调

/**
 缓存查询的回调方法
 
 @param response 查询结果
 */
-(void)onQueryTrackCacheInfo:(NSData *)response{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    if (self.queryCacheBlock) {
        self.queryCacheBlock(dict);
    }
}

/**
 轨迹查询的回调方法
 
 @param response 查询结果
 */
-(void)onQueryHistoryTrack:(NSData *)response{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    if (self.queryHistoryTrackBlock) {
        self.queryHistoryTrackBlock(dict);
    }

}
@end
