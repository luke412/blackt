//
//  LKColor.h
//  工具类
//
//  Created by 鲁柯 on 16/1/21.
//  Copyright © 2016年 luke. All rights reserved.
//
//钥匙串
//#import "SFHFKeychainUtils.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define iPhone4  4
#define iPhone5  5
#define iPhone6  6
#define iPhone6p 7
#define iPadAir  8
#define iPadPro  9

//16进制色值变rgb宏
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:((float)((rgbValue & 0xFF000000) >> 24))/255.0]
#define WIDTH_lk  ([[UIScreen mainScreen] bounds].size.width)
#define HEIGHT_lk ([[UIScreen mainScreen] bounds].size.height)
#define BEN_RI   10//本日cell跳转
#define BEN_YUE  11//本月
#define BEN_NIAN 12
@interface LKTool : NSObject
#pragma mark UUID  钥匙串
/**
  *  判断一个是否包含某个object
  *  @return 是否包含
  */
+(BOOL)DoesItIncludeTheElement:(NSString *)element InTheArray:(NSArray*)array;
/**
  *  获取手机设备的唯一标识
  *  算法：生成绝对唯一的一个字符串，将字符串传到钥匙串，永久保存，用户重新安装后，先取密码，取不到，重新建立
  *  @return 唯一标识
  */

//+(NSString *)getLK_UUID;
+ (NSInteger) calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate;
/**
  *  获得传入视图的底线纵坐标
  *
  *  @param view 传入视图
  *
  *  @return 纵坐标的数值
  */
+(CGFloat)getRightX:(UIView *)view;
+(CGFloat)getBottomY:(UIView *)view;

#pragma mark 颜色 色值转换
/**
  *  将传入的色值字符串--->为UIColor
  *
  *  @param str_16 色值字符串
  *
  *  @return UIColor
  */
+(NSString * )changeToRangeWithString:(NSString *)str;
+(UIColor *)from_16To_Color:(NSString *)str_16;
//字典变json
+(NSString *)LKdictionaryToJson:(NSDictionary *)dic;
#pragma mark 判断传入字符串是否为手机号
+(BOOL)validateMobile:(NSString *)mobileNum;
#pragma mark 单个数值运算
#pragma mark 苹果屏幕适配

+(CGRect)LK_CGRectMaketWithX:(CGFloat)x andY:(CGFloat)y andWidth:(CGFloat)width andHeight:(CGFloat)height;

#pragma mark 只适配位置，不改变控件大小
+(CGRect)LK_CGRectMaketWeiZhi_WithX:(CGFloat)x andY:(CGFloat)y andWidth:(CGFloat)width andHeight:(CGFloat)height;

#pragma mark 适配开关 自己决定四个要素哪个要适配哪个不要适配
+(CGRect)LK_CGRectMaketWeiZhi_WithX:(CGFloat)x andY:(CGFloat)y andWidth:(CGFloat)width andHeight:(CGFloat)height andXBool:(BOOL)xBool andYBool:(BOOL)yBool andWidthBool:(BOOL)withBool andheightBool:(BOOL)heightBool;

#pragma mark 计算器方法 传入算式字符串，返回浮点型结果 （加减法目前只支持）
+(float)calculatorWithStr:(NSString *)str;

#pragma mark 删除字符串中指定字符
+(NSString *) stringDeleteString:(NSString *)deleteStr fromStr:(NSString *)oldStr;
+(NSString *) stringDeleteStringArr:(NSArray *)deleteStrArr fromStr:(NSString *)oldStr;

#pragma mark 传入日期 返回星期(20160101)
+(NSString *)getDayOfTheWeekFromDate:(NSString *)date;

#pragma mark 输入日期返回，这是本年第几天
+(int)DiJiTian:(NSString *)date;
#pragma mark 是否为闰年
+(BOOL)isRunNian:(int)nian2;

#pragma mark 给定UIColor返回色值
+(UIColor *)RGBStr_Color:(NSString *)colorStr;
+(NSString *)getColorStrFromcolor:(UIColor *)clolor_lk;

#pragma mark 字典汉字正常显示
+(void)logDic:(NSDictionary *)dic;

+(BOOL)isYinHangNumber:(NSString *)number;
+ (NSString *)returnBankName:(NSString*) idCard;

/**
  *  创建一个 AFHTTPSessionManager单例
  *
  *  @return 返回单例
  */
//+(AFHTTPSessionManager *)initSingle_AFHTTPSessionManager;

/**
  *  验证身份证号
  *
  *  @param numberStr 待检验字符串
  *
  *  @return 结果
  */
+(BOOL)isShenFenZheng:(NSString *)numberStr;


+(dispatch_queue_t)createlukeQueue;
+(int)iPhoneStyle;
@end
