//
//  ClothesModel.m
//  BlackT2017
//
//  Created by 鲁柯 on 2016/12/29.
//  Copyright © 2016年 鲁柯. All rights reserved.
//  衣服数据模型      我的衣服表中的记录模型

#import "ClothesModel.h"

@implementation ClothesModel
-(NSString *)description{
    NSString *string = [NSString stringWithFormat:@"衣物名:%@ 衣物mac:%@  衣物类型:%@", self.clothesName,self.clothesMac,self.clothesStyle];
    return string;
}
@end
