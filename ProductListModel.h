//
//  ProductListModel.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/3/23.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageModel.h"
@interface ProductListModel : NSObject
@property(nonatomic,copy)NSString *productId;
@property(nonatomic,copy)NSString *productName;
@property(nonatomic,copy)NSString *productIntro;
@property(nonatomic,copy)NSMutableArray <ImageModel *> *picList;
@end
