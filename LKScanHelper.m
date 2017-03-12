//
//  LKScanHelper.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/1/23.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  新二维码扫描框架 原生

#import "LKScanHelper.h"
@interface LKScanHelper ()<AVCaptureMetadataOutputObjectsDelegate>

@end
@implementation LKScanHelper
+ (instancetype)manager
{
    static LKScanHelper *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[LKScanHelper alloc] init];
    });
    return singleton;
}

-(instancetype)init{
    self=[super init];
    
    //初始化连接对象
    if (self) {
        _session=[[AVCaptureSession alloc]init];
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        //FIXME：避免模拟器运行崩溃
        if(!TARGET_IPHONE_SIMULATOR){
            //获取摄像设备
            AVCaptureDevice *device=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            //创建输入流
            _input=[AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            [_session addInput:_input];
            
            //创建输出流
            _output=[[AVCaptureMetadataOutput alloc]init];
            //设置代理 在主线程里刷新
            [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            [_session addOutput:_output];
            _output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
            
            //要在addOutput之后，否则iOS10 会崩溃
            _layer=[AVCaptureVideoPreviewLayer layerWithSession:_session];
            _layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        }
    }
    return self;
}

#pragma mark - 方法
//开始捕获
-(void)startRunning{
    if(!TARGET_IPHONE_SIMULATOR){
        [_session startRunning];
    }
}

-(void)stopRunning{
    if(!TARGET_IPHONE_SIMULATOR){
        [_session stopRunning];
    }

}

#pragma mark - 代理方法 输出
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject *metadataObject=[metadataObjects objectAtIndex:0];
        NSLog(@"扫描结果%@",metadataObject.stringValue);
    }

}

#pragma mark - 设置扫描范围

-(void)setScanningRect:(CGRect) scanRect scanView:(UIView *)scanView{
    CGFloat x,y,width,height;
    x=scanRect.origin.y/_layer.frame.size.height;
    y=scanRect.origin.x/_layer.frame.size.width;
    width=scanRect.size.height/_layer.frame.size.height;
    height=scanRect.size.width/_layer.frame.size.width;
    
    _output.rectOfInterest=CGRectMake(x, x, width, height);
    self.scanView=scanView;
    if (self.scanView) {
        self,scanView.frame=scanRect;
        if (_viewController) {
            [_viewController addSubview:self.scanView];
        }
    }


}

-(void)showLayer:(UIView *)viewContainer{
    _viewController=viewContainer;
    _layer.frame=_viewController.layer.frame;
    [_viewController.layer insertSublayer:_layer atIndex:0];

}
@end
