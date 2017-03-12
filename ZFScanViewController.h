//
//  ZFScanViewController.h
//  ZFScan
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZFMaskView.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
@interface ZFScanViewController : UIViewController
/** 输入输出的中间桥梁 */
@property (nonatomic, strong) AVCaptureSession * session;
/** 扫描结果 */
@property (nonatomic, copy) void (^returnScanBarCodeValue)(NSString * barCodeString);
@end
