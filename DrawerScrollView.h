//
//  DrawerScrollView.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/2/26.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerDeviceImage.h"

#define leftBianJu                  60
#define height_DrawerScrollView     90

#define subImageWidth               95
#define subImageHeight              60
@interface DrawerScrollView : UIView <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView   *chouTiImage;
@property (weak, nonatomic) IBOutlet UIScrollView  *chouTiScrollew;

@property(nonatomic,assign)BOOL isOpen;

-(void)appearAnimation;
-(void)disappearAnimation;
-(void)dataBaseRefresh;
@end
