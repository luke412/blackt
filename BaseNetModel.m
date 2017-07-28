//
//  BaseModel.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/3/20.
//  Copyright © 2017年 鲁柯. All rights reserved.
//


#import "BaseNetModel.h"
#import <objc/runtime.h>
@interface BaseNetModel ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation BaseNetModel
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
         _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
-(NSMutableDictionary *)fromModelToDictionary{

        NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i++) {
            const char *name = property_getName(properties[i]);
            
            NSString *propertyName = [NSString stringWithUTF8String:name];
            id propertyValue = [self valueForKey:propertyName];
            if (propertyValue) {
                [userDic setObject:propertyValue forKey:propertyName];
            }
            
        }
        free(properties);
        
        return userDic;
}

-(void)baseSendRequestWithDic:(NSDictionary *)parameters
                    andUrl  :(NSString *)url
                    Success:(requestSuccess)success
                   Abnormal:(requestAbnormal)abnormal
                    Failure:(requestFailure)failure{
    //拼接url
    NSMutableString * baseUrl = [[NSMutableString alloc]initWithString:SERVICE_URL];
    [baseUrl appendString:url];
    
    //模型转字典（请求参数）
    self.manager.requestSerializer.timeoutInterval = RequestTimeOut;
    
    //模型转字典（请求参数）
    [self.manager POST:baseUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress){}
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          LKLog(@"请求成功 url:%@,  参数：%@   返回:%@",baseUrl,parameters,responseObject);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUD];
             });
             
             
             if ([responseObject[@"retCode"] isEqualToString:@"0000"]) {
                 if (success) {
                     success(responseObject);
                 }
             }else{
                 if (abnormal) {
                     abnormal(responseObject);
                 }
             }
         }
                   
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
            LKLog(@"请求出错url:%@,  参数：%@",baseUrl,parameters);
            LKLog(@"%@",error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });

            if (failure) {
                failure(error);
            }
        }];

}
@end
