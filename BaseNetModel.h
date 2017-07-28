//
//  BaseModel.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/3/20.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

typedef void(^requestSuccess)(id responseObject);
typedef void(^requestAbnormal)(id responseObject);
typedef void(^requestFailure)(NSError* error);

typedef void(^dataValidationSuccess)();
typedef void(^dataValidationFailure)(NSString *errorMsg);

#import <Foundation/Foundation.h>
@interface BaseNetModel : NSObject
/*
 *  model转字典
 */
-(NSMutableDictionary *)fromModelToDictionary;



/*
 *  发送网络请求
 */
-(void)baseSendRequestWithDic:(NSDictionary *)parameters
                     andUrl  :(NSString *)url
                      Success:(requestSuccess)success
                     Abnormal:(requestAbnormal)abnormal
                      Failure:(requestFailure)failure;
@end
