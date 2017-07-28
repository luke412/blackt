//
//  YiChangManager.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/20.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

typedef void(^Success)(NSString *mac);
#import <Foundation/Foundation.h>

@interface YiChangManager : NSObject
@property(nonatomic,copy)Success successBlock;

/**进入到一系列的界面里*/
-(void)showViewControllers_vc:(Base_ViewController *)vc;


@end
