//
//  ZFScanViewController.m
//  ZFScan
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFScanViewController.h"
#import "BluthNameAddDevice_ViewController.h"

@interface ZFScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL isOk;//是否拥有权限
}


/** 扫描支持的编码格式的数组 */
@property (nonatomic, strong) NSMutableArray * metadataObjectTypes;
/** 遮罩层 */
@property (nonatomic, strong) ZFMaskView * maskView;
/** 取消按钮 */
@property (nonatomic, strong) UIButton * cancelButton;

@end

@implementation ZFScanViewController

- (NSMutableArray *)metadataObjectTypes{
    if (!_metadataObjectTypes) {
        _metadataObjectTypes = [NSMutableArray arrayWithObjects:AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code,  AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypePDF417Code,  AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode, nil];
        
        // >= iOS 8
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            [_metadataObjectTypes addObjectsFromArray:@[AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeDataMatrixCode]];
        }
    }
    return _metadataObjectTypes;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.session startRunning];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //鲁柯修改  [self.maskView removeAnimation];
    [MBProgressHUD hideHUD];
    [self.session stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTittleWithText:LK(@"扫 码")];
    [self capture];
    [self addUI];
}



/**
 *  添加遮罩层
 */
- (void)addUI{
    CGFloat leftJu            = lkptBiLi(69);
    CGFloat topJu             = lkptBiLi(88);
    CGFloat imageWidth        = WIDTH_lk - leftJu*2;
    CGFloat imageHeight       = floorf(imageWidth *150/564);
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(leftJu, topJu, imageWidth, imageHeight)];
    topImageView.image        = [UIImage imageNamed:@"扫码顶部"];
    [self.view addSubview:topImageView];
    
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(leftJu, [LKTool getBottomY:topImageView]+5, imageWidth, imageHeight)];
    label.textColor = [UIColor whiteColor];
    label.font      = [UIFont systemFontOfSize:15];
    label.text      = @"请对准设备二维码扫码";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    
    self.maskView = [[ZFMaskView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.maskView];
    
    //取消按钮
    CGFloat cancel_width    = 200;
    CGFloat cancel_height   = 35;
    CGFloat cancel_xPos     = (CGRectGetWidth(self.maskView.frame) - cancel_width) / 2;
    CGFloat cancel_yPos     = CGRectGetHeight(self.maskView.frame) - cancel_height - 30;

    self.cancelButton       = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelButton.frame = CGRectMake(cancel_xPos, cancel_yPos, cancel_width, cancel_height);
    [self.cancelButton setTitle:LK(@"蓝牙名称添加设备") forState:UIControlStateNormal];
    [self.cancelButton setTintColor:[UIColor whiteColor]];
    [self.cancelButton addTarget:self action:@selector(bulthAddDevice) forControlEvents:UIControlEventTouchUpInside];
    [self.maskView addSubview:self.cancelButton];
}

/**
 *  扫描初始化
 */
- (void)capture{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        NSLog(@"没有相机权限");
       UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:LK(@"温馨提示") message:LK(@"扫码需要您的相机授权，请在设置-隐私-相机中打开授权，然后重启应用") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:LK(@"暂时不要") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    NSLog(@"点击了取消按钮");
                    [self.navigationController popToRootViewControllerAnimated:NO];
            
                }];
        
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:LK(@"去设置") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //跳转至相机授权页
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]];
                 //让应用主动crash
            [[HeatingClothesBLEService sharedInstance]stopTheHeart];
            
            }];
            [alertVc addAction:confirm];
            [alertVc addAction:cancle];
         
            //4.控制器 展示弹框控件，完成时不做操作
            [self presentViewController:alertVc animated:YES completion:^{
                    nil;
                }];
        return;
    }

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"设备没有相机！！！！");
        return;
    }
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //初始化链接对象
    self.session = [[AVCaptureSession alloc] init];
    //高质量采集率
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
    [self.session addInput:input];
    [self.session addOutput:output];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:layer];
    //设置扫描支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = self.metadataObjectTypes;
    //开始捕获
    [self.session startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0){
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects.firstObject;
        if (self.returnScanBarCodeValue) {
            self.returnScanBarCodeValue(metadataObject.stringValue);
        }
    }
}

#pragma mark - 取消事件
/**
 * 取消事件
 */
- (void)bulthAddDevice{
//    if (self.navigationController) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
    BluthNameAddDevice_ViewController *vc = [[BluthNameAddDevice_ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}
@end
