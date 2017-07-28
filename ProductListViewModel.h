//
//  ProductListViewModel.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/3/23.
//  Copyright © 2017年 鲁柯. All rights reserved.
//
typedef void(^requestSuccess)(id responseObject);
typedef void(^requestAbnormal)(id responseObject);
typedef void(^requestFailure)(NSError* error);



#import <Foundation/Foundation.h>

@interface ProductListViewModel : BaseNetModel

/*
 *  发送请求，加载产品列表数据
 */
-(void)sendLoadProductListData_RequestSuccess:(requestSuccess)success
                                     Abnormal:(requestAbnormal)abnormal
                                      Failure:(requestFailure)failure;

@end
