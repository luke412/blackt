//
//  PlayView.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/7/16.
//  Copyright © 2017年 鲁柯. All rights reserved.
// 一键理疗播放视图

#import "PlayView.h"
@interface PlayView ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet LKButton *playBtn;
@property (nonatomic,strong)UIProgressView *progressView;
@end

@implementation PlayView
-(void)awakeFromNib{
    [super awakeFromNib];
    CGFloat selfWidth = WIDTH_lk;
    CGFloat selfHeight = lkptBiLi(64);
    _playBtn.isOn = NO;
    [_playBtn setImage:[UIImage imageNamed:@"停止_一键理疗"] forState:UIControlStateNormal];

    _leftImage.frame             = CGRectMake(lkptBiLi(15), lkptBiLi(20), lkptBiLi(10), lkptBiLi(10));
    _timeLabel.frame             = CGRectMake(lkptBiLi(35), lkptBiLi(20), 150, lkptBiLi(12));
    _playBtn.frame               = CGRectMake(lkptBiLi(277), lkptBiLi(8), lkptBiLi(34), lkptBiLi(34));

    _progressView                = [[UIProgressView alloc]initWithFrame:CGRectMake(0,0, WIDTH_lk, 3)];
    _progressView.tintColor      = [LKTool from_16To_Color:@"#595959"];
    _progressView.trackTintColor = [LKTool from_16To_Color:@"#d6d6d6"];
    _progressView.progress       = 0.5;
    [self addSubview:_progressView];
    
}
-(void)showRunFace{
    self.hidden = NO;
    self.backgroundColor = [LKTool from_16To_Color:BACK_COLOR_new];
    _leftImage.hidden = NO;
    _timeLabel.hidden = NO;
    _playBtn.hidden = NO;

}
-(void)showHidden{
    self.hidden = YES;
}

//方案开启按钮点击
- (IBAction)startPlay:(id)sender{
    LKButton *btn = (LKButton *)sender;
    if (_delegate && [_delegate respondsToSelector:@selector(playBtnClick:)]) {
        [_delegate playBtnClick:btn];
    }
}

-(void)refreshProgressView_restSeconds:(NSInteger)restSeconds
                            sumSeconds:(NSInteger)sumSeconds{
    float value = 1.0 - (float)restSeconds/(float)sumSeconds;
    _progressView.progress =  value;
}
-(void)refreshTimeLabel_restSeconds:(NSInteger)restSeconds{
    NSInteger hours = restSeconds/3600;
    NSInteger mins =  (restSeconds - hours *3600)/60;
    NSInteger miaoShu = (restSeconds - hours * 3600) - mins * 60;
    NSString *str =  [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",hours,mins,miaoShu];
    _timeLabel.text = str;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
