//
//  XiaoXiXiangQing_ViewController.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/5/13.
//  Copyright © 2017年 鲁柯. All rights reserved.
//  消息详情界面

#import "XiaoXiXiangQing_ViewController.h"
#import "MessageModel.h"
#import "DataBaseManager.h"
@interface XiaoXiXiangQing_ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UITextView *text_textView;

@end

@implementation XiaoXiXiangQing_ViewController
-(void)viewWillAppear:(BOOL)animated{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTittleWithText:LK(@"消息详情")];
    _text_textView.userInteractionEnabled = NO;
    if ([_messageModel.customKey hasPrefix:@"A"]) {
        _title_label.text   =  @"通知";
        _text_textView.text = _messageModel.text;
    }else{
        _title_label.text   =  _messageModel.headlineKey;
        _text_textView.text = _messageModel.descriptionKey;
    }
    
    //修改数据库 已读状态
    self.messageModel.isRead = @"YES";
    [DataBase_Manager lk_xiuGaiReadStateWithMessage:self.messageModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
