


//
//  ProductListViewModel.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/3/23.
//  Copyright © 2017年 鲁柯. All rights reserved.
//



#import "ProductListViewModel.h"

@implementation ProductListViewModel
-(void)sendLoadProductListData_RequestSuccess:(requestSuccess)success
                                     Abnormal:(requestAbnormal)abnormal
                                      Failure:(requestFailure)failure{
    [self sendRequestWithUrl:Load_ProductList_URL Success:^(id responseObject) {
        [LKTool LKdictionaryToJson:responseObject];
        
    } Abnormal:^(id responseObject) {
         [LKTool LKdictionaryToJson:responseObject];
    } Failure:^(NSError *error) {
        NSLog(@"错了");
    }];


}
@end
