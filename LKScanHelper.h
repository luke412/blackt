//
//  LKScanHelper.h
//  BlackT2017
//
//  Created by 鲁柯 on 2017/1/23.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface LKScanHelper : NSObject
@property(nonatomic,strong)AVCaptureSession *session;
@property(nonatomic,strong)AVCaptureDeviceInput *input;
@property(nonatomic,strong)AVCaptureMetadataOutput *output;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *layer;
@property(nonatomic,strong)UIView *scanView;

@property(nonatomic,strong)UIView *viewController;
+ (instancetype)manager;
-(void)startRunning;
-(void)stopRunning;
-(void)showLayer:(UIView *)viewContainer;
-(void)setScanningRect:(CGRect) scanRect scanView:(UIView *)scanView;
@end
