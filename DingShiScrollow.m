//
//  DingShiScrollow.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/4/2.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "DingShiScrollow.h"

@interface DingShiScrollow ()<UIScrollViewDelegate>
@property(nonatomic,strong)showTimeLabel  *yuanTimeLabel;//时间label
@property(nonatomic,strong)UIScrollView   *yuanScrollView;

@property(nonatomic,strong)UIButton  *queDingBtn;

@property(nonatomic,strong)NSMutableArray *yuanArray;   //圆形复用池
@end

@implementation DingShiScrollow

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _yuanScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_lk, 200)];
        _yuanScrollView.contentOffset = CGPointMake(200, _yuanScrollView.contentOffset.y);
        _yuanScrollView.delegate = self;
        _yuanScrollView.decelerationRate = 0.7;
        _yuanScrollView.contentSize = CGSizeMake(2700, _yuanScrollView.frame.size.height);
        _yuanScrollView.showsHorizontalScrollIndicator = NO;
        _yuanArray = [[NSMutableArray alloc]init];
       
        for (int i=0; i<=30; i++) {
            //标签
            showTimeLabel *label = [[showTimeLabel alloc]initWithFrame:CGRectMake((i)*80+WIDTH_lk/2, 20, label_WIDTH, label_WIDTH)];
            
            if (i==0) {
                label.text     = [NSString stringWithFormat:@"不限时"];
            }else{
                label.text     = [NSString stringWithFormat:@"%dmin",(i)*5];
            }
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor     = [UIColor whiteColor];
            label.backgroundColor    = [LKTool from_16To_Color:@"8694f6"];
            [_yuanScrollView addSubview:label];
            [_yuanArray addObject:label];
        }
         [self addSubview:self.yuanScrollView];
        
        self.queDingBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH_lk/2-55, self.frame.size.height-60, 110, 40)];
        [self.queDingBtn.layer setBorderColor:[LKTool from_16To_Color:dingShiShen].CGColor];
        [self.queDingBtn.layer setBorderWidth:1];
        [self.queDingBtn.layer setMasksToBounds:YES];
        self.queDingBtn.layer.masksToBounds = YES;
        self.queDingBtn.layer.cornerRadius  = self.queDingBtn.frame.size.height/2;
        [self.queDingBtn setTitle:@"确 定" forState:UIControlStateNormal];
        [self.queDingBtn setTitleColor:[LKTool from_16To_Color:dingShiShen] forState:UIControlStateNormal];
        [self.queDingBtn addTarget:self action:@selector(queDingClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.queDingBtn];
        [self getTimerFromLabelWithIsLeft:NO];
    }
    return self;
}

#pragma mark - UIScrollow 相关
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"滑动结束");

    if (scrollView.contentOffset.x == 0) {
        [self getTimerFromLabelWithIsLeft:YES];

    }
    [self getTimerFromLabelWithIsLeft:NO];
}
//拖动结束，手指离开屏幕的时候
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if(!decelerate){
       
        [self getTimerFromLabelWithIsLeft:NO];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    LKLog(@"滚动中");
    for (showTimeLabel *targetLabel in _yuanArray) {
         CGRect targetLabelRect =[targetLabel convertRect:targetLabel.bounds toView:self];
         float left_x = targetLabelRect.origin.x;
         float width_label = targetLabelRect.size.width;
         float juLi =  fabs(   WIDTH_lk/2-(left_x+width_label/2) );
        if (juLi<WIDTH_lk / 2) {
            [targetLabel changeLabelSizeWithDistance:juLi];
        }
        
    }
   
    
}

#pragma mark - 获取设定的时间
-(void)getTimerFromLabelWithIsLeft:(BOOL)isLeft{
    for (UILabel *label in _yuanArray) {
      //  label.backgroundColor = [LKTool from_16To_Color:@"8694f6"];
        label.backgroundColor = [LKTool from_16To_Color:dingShiShen];
    }
    //屏幕中轴线在滚动视图上的横坐标
    CGFloat select_X = WIDTH_lk/2 + _yuanScrollView.contentOffset.x;

    //寻找距离中轴线最近的label
    int x_min,x_max;
    for(int i=0;i<_yuanArray.count-1;i++){
        if (isLeft == YES) {
            showTimeLabel *tempLabel = _yuanArray[0];
            self.selectedLabel = tempLabel;  //最左边的
            break;
        }
        showTimeLabel *tempLabel =(showTimeLabel *) _yuanArray[i];
        showTimeLabel *tempLabel2  =(showTimeLabel *) _yuanArray[i+1];
        tempLabel.backgroundColor  = [LKTool from_16To_Color:dingShiShen];
        tempLabel2.backgroundColor = [LKTool from_16To_Color:dingShiShen];
        CGFloat label_center_x = tempLabel.frame.origin.x + tempLabel.frame.size.width/2;   //获取每隔Label的中轴线
        CGFloat label_center_x2 = tempLabel2.frame.origin.x + tempLabel2.frame.size.width/2;   //获取每隔Label的中轴线
        if (label_center_x < select_X && label_center_x2>select_X) {
            x_min = label_center_x;
            x_max = label_center_x2;
            if (select_X - x_min > x_max - select_X) {
                self.selectedLabel = tempLabel2;
            }else{
                self.selectedLabel = tempLabel;
            }
            break;
        }
    }
    [self jiuZhengWeiZhi:self.selectedLabel];
}

//纠正位置，令目标label位于屏幕中央
-(void)jiuZhengWeiZhi:(UILabel *)targetLabel{
    [UIView animateWithDuration:0.1 animations:^{
        _yuanScrollView.contentOffset = CGPointMake(targetLabel.center.x-WIDTH_lk/2, _yuanScrollView.contentOffset.y);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)queDingClick{
    if (_myQueDingBlock) {
        _myQueDingBlock(self.selectedLabel.text);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
