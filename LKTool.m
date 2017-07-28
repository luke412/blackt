//
//  LKColor.m
//  色值转换宏
//
//  Created by 鲁柯 on 16/1/21.
//  Copyright © 2016年 luke. All rights reserved.
#import "LKTool.h"
#import "Base_ViewController.h"
@implementation LKTool
+ (UIFont *)qsh_systemFontOfSize:(CGFloat)pxSize{
    
//    CGFloat pt = (pxSize/96)*72;
//    
//    
//    NSLog(@"pt--%f",pt);
//    
//    CGFloat ptZhnegShu = floorf(pt);
//    
//    
//    UIFont *font = [UIFont systemFontOfSize:ptZhnegShu];
//    
//    return font;
    
    
        CGFloat pt = (pxSize)/(96/72);
    
        NSLog(@"pt--%f",pt);
    
        CGFloat ptZhnegShu = ceilf(pt);
    
    
        UIFont *font = [UIFont systemFontOfSize:ptZhnegShu];
        
        return font;
    
}


+(BOOL)DoesItIncludeTheElement:(NSString *)element InTheArray:(NSArray<NSString *>*)array{
    for (NSString *str in array) {
        if ([element isEqualToString:str]) {
            
            return YES;
        }
    }
    return NO;
}
#pragma mark 16进制转RGB 颜色
+(CGFloat)fromPxToPt_BiLi:(CGFloat)value_px{
    return  value_px /320 * WIDTH_lk;
}
+ (NSInteger) calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate
{
        //创建日期格式化对象
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        //取两个日期对象的时间间隔：
        //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
        NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];
        
        int days=((int)time)/(3600*24);
        //int hours=((int)time)%(3600*24)/3600;
        //NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
        return days;
}

//获取顶部坐标
+(CGFloat)getTopY:(UIView *)view{
    CGFloat topY=view.frame.origin.y;
        return topY;
    
}
//获得控件最右边的坐标
+(CGFloat)getRightX:(UIView *)view{
        CGFloat rightX=view.frame.origin.x+view.frame.size.width;
        return rightX;
}
//获取底线纵坐标
+(CGFloat)getBottomY:(UIView *)view{
        CGFloat bottomY=view.frame.origin.y+view.frame.size.height;
        return bottomY;
}
+(NSString *)LKdictionaryToJson:(NSDictionary *)dic{
         NSData *data=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
         NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"json字符串为：%@",jsonStr);
         return jsonStr;
}
+ (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+(UIColor *)from_16To_Color:(NSString *)str_16{
        NSString *string16D = [str_16 uppercaseString];
        NSString *Tou=[string16D substringWithRange:NSMakeRange(0,1)];
        if (![Tou isEqualToString:@"#"]) {//如果首个字符不是#
                string16D=[NSString stringWithFormat:@"#%@",string16D];
            }
    
        //NSLog(@"大写转换后%@",string16D);
        NSString *num_red= [string16D substringWithRange:NSMakeRange(1, 2)];
        NSString *num_green=[string16D substringWithRange:NSMakeRange(3, 2)];
        NSString *num_blue=[string16D substringWithRange:NSMakeRange(5, 2)];
        CGFloat red=[self str_16Tofloat:num_red];
        CGFloat green=[self str_16Tofloat:num_green];
        CGFloat blue=[self str_16Tofloat:num_blue];
    
        UIColor *color=[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
        return color;
}

+(float)str_16Tofloat:(NSString *)str_16{
        char s = [str_16 characterAtIndex:0];
        char g =[str_16 characterAtIndex:1];
        float gao;
        float di;
        if (s>=65&&s<=90) {//是大写字母
                gao=(s-55)*16;
            }
        else if(s>='0'&&s<='9'){
                gao=(s-48)*16;
            }
        if (g>=65&&g<=90) {//是大写字母
                di=(g-55);
            }
        else if(g>='0'&&g<='9'){
                di=(g-48);
            }
        return gao+di;
}
#pragma mark 颜色
+(UIColor *)RGBStr_Color:(NSString *)colorStr{
        NSArray *arr = [colorStr componentsSeparatedByString:@","];
        if (arr.count==3) {
                float red  =[arr[0] floatValue];
                float green=[arr[1] floatValue];
                float blue =[arr[2] floatValue];
                return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
            }
        else{
                NSLog(@"颜色输入格式错误");
                return 0;
            }
        
}

#pragma mark 屏幕适配
+(CGRect)LK_CGRectMaketWithX:(CGFloat)x andY:(CGFloat)y andWidth:(CGFloat)width andHeight:(CGFloat)height
{  //此适配方法原则：适配机型上的图形宽高各占屏幕总宽高比例与6s相同，但不保证图形“模样”如果适配机型的屏幕宽高比与6s不同则图形可能会变形
        CGFloat _width_lk= [[UIScreen mainScreen] bounds].size.width;
        CGFloat _height_lk=[[UIScreen mainScreen] bounds].size.height;
        // NSLog(@"检验宽度：%f",_width_lk);
        //NSLog(@"高度%f",_height_lk);
        return CGRectMake(x * (_width_lk / 375), y * (_height_lk/667), width *(_width_lk / 375), height * (_height_lk / 667));
}
+(CGRect)LK_CGRectMaketWeiZhi_WithX:(CGFloat)x andY:(CGFloat)y andWidth:(CGFloat)width andHeight:(CGFloat)height{
        CGFloat _width_lk= [[UIScreen mainScreen] bounds].size.width;
        CGFloat _height_lk=[[UIScreen mainScreen] bounds].size.height;
        // NSLog(@"检验宽度：%f",_width_lk);
        //NSLog(@"高度%f",_height_lk);
        return CGRectMake(x * (_width_lk / 375), y * (_height_lk/667), width, height);
}

//适配开关
+(CGRect)LK_CGRectMaketWeiZhi_WithX:(CGFloat)x andY:(CGFloat)y andWidth:(CGFloat)width andHeight:(CGFloat)height andXBool:(BOOL)xBool andYBool:(BOOL)yBool andWidthBool:(BOOL)withBool andheightBool:(BOOL)heightBool{
        CGFloat _width_lk= [[UIScreen mainScreen] bounds].size.width;
        CGFloat _height_lk=[[UIScreen mainScreen] bounds].size.height;
        CGFloat x2;
        CGFloat y2;
        CGFloat width2;
        CGFloat height2;
        //位置 X
        if (xBool==YES) {//要适配
                x2=x * (_width_lk / 375);
            }
        if(xBool==NO){
                x2=x;
            }
        
        //位置Y
        if (yBool==YES) {//要适配
                y2=y * (_height_lk / 667);
            }
        if(yBool==NO){
                y2=y;
            }
        
        //大小width
        if (withBool==YES) {//要适配
                width2=width * (_width_lk / 375);
            }
        if(withBool==NO){
                width2=width;
            }
    
        //大小height
        if (heightBool==YES) {//要适配
                height2=height * (_height_lk / 667);
            }
        if(heightBool==NO){
                height2=height;
            }
    
        
        
        
        
            return CGRectMake(x2,y2, width2, height2);
}
/**
  *  判断是否为银行卡号
  *
  *  @param number 传入的号码
  *
  *  @return 返回值
  */
+(BOOL)isYinHangNumber:(NSString *)number{
    //^([0-9]{16}|[0-9]{19})$
      
        NSString * MOBILE = @"^([0-9]{16}|[0-9]{19})$";
        
        
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        if ([regextestmobile evaluateWithObject:number] == YES)
           
            {
                    
                    return YES;
                }
        else
            {
                    return NO;
                }
}
#pragma mark- 手机号码正则表达式
+ (BOOL)validateMobile:(NSString *)mobileNum
{
        /**
              * 手机号码
              * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
              * 联通：130,131,132,152,155,156,185,186
              * 电信：133,1349,153,180,189
              */
        NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
        /**
              10         * 中国移动：China Mobile
              11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
              12         */
        NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
        /**
              15         * 中国联通：China Unicom
              16         * 130,131,132,152,155,156,185,186
              17         */
        NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
        /**
              20         * 中国电信：China Telecom
              21         * 133,1349,153,180,189
              22         */
        NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
        /**
              25         * 大陆地区固话及小灵通
              26         * 区号：010,020,021,022,023,024,025,027,028,029
              27         * 号码：七位或八位
              28         */
        // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
        
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
        
        if (([regextestmobile evaluateWithObject:mobileNum] == YES)
                    || ([regextestcm evaluateWithObject:mobileNum] == YES)
                    || ([regextestct evaluateWithObject:mobileNum] == YES)
                    || ([regextestcu evaluateWithObject:mobileNum] == YES))
            {
                    
                    return YES;
                }
        else
            {
                    return NO;
                }
}

#pragma mark 身份证验证
+(BOOL)isShenFenZheng:(NSString *)numberStr{
                  numberStr = [numberStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                  if ([numberStr length] != 18) {
                              return NO;
                       }
                 NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
                 NSString *leapMmdd = @"0229";
                 NSString *year = @"(19|20)[0-9]{2}";
                 NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
                 NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
              NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
                 NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
                 NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
                 NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
            
                 NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                 if (![regexTest evaluateWithObject:numberStr]) {
                           return NO;
                       }
                 int summary = ([numberStr substringWithRange:NSMakeRange(0,1)].intValue + [numberStr substringWithRange:NSMakeRange(10,1)].intValue) *7
                         + ([numberStr substringWithRange:NSMakeRange(1,1)].intValue + [numberStr substringWithRange:NSMakeRange(11,1)].intValue) *9
                         + ([numberStr substringWithRange:NSMakeRange(2,1)].intValue + [numberStr substringWithRange:NSMakeRange(12,1)].intValue) *10
                         + ([numberStr substringWithRange:NSMakeRange(3,1)].intValue + [numberStr substringWithRange:NSMakeRange(13,1)].intValue) *5
                         + ([numberStr substringWithRange:NSMakeRange(4,1)].intValue + [numberStr substringWithRange:NSMakeRange(14,1)].intValue) *8
                         + ([numberStr substringWithRange:NSMakeRange(5,1)].intValue + [numberStr substringWithRange:NSMakeRange(15,1)].intValue) *4
                         + ([numberStr substringWithRange:NSMakeRange(6,1)].intValue + [numberStr substringWithRange:NSMakeRange(16,1)].intValue) *2
                         + [numberStr substringWithRange:NSMakeRange(7,1)].intValue *1 + [numberStr substringWithRange:NSMakeRange(8,1)].intValue *6
                         + [numberStr substringWithRange:NSMakeRange(9,1)].intValue *3;
                 NSInteger remainder = summary % 11;
                 NSString *checkBit = @"";
                 NSString *checkString = @"10X98765432";
                 checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
                 return [checkBit isEqualToString:[[numberStr substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}
//计算器方法
+(float)calculatorWithStr:(NSString *)str{
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"+-"];
        //这是运算数字数组
        NSArray *Arr = [str componentsSeparatedByCharactersInSet:set];
        NSMutableArray *numArr=[NSMutableArray arrayWithArray:Arr];
        
        NSCharacterSet *setNum = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        //运算符数组
        NSArray *strArr2 = [str componentsSeparatedByCharactersInSet:setNum];
        NSMutableArray *strArr=[NSMutableArray arrayWithArray:strArr2];
        //去除空值
        if(strArr){
            [strArr removeObject:@"."];
            [strArr removeObject:@""];
             NSLog(@"长度%d",strArr.count);
            }
        if(numArr){
            [numArr removeObject:@""];
            }
        //计算
        int n=0;
        float num=0.0;
        if (strArr.count==0) {//运算符数组为说明没有输入运算符，直接返回输入结果不运算
                return [str floatValue];
            }
    
        for (NSString *str in strArr) {
                       if (n==0) {
                        num=[[numArr objectAtIndex:0] floatValue];
                    }
                if ([str isEqualToString:@"+"]) {
                        float ay=[[numArr objectAtIndex:n+1] floatValue];
                        num=num+ay;
                    }
                if ([str isEqualToString:@"-"]) {
                        float ay=[[numArr objectAtIndex:n+1] floatValue];
                        num=num-ay;
                    }
        
                n++;
            }
        return num;
}
//要删除的字符是汉字的话，出现bug
+(NSString *) stringDeleteString:(NSString *)deleteStr fromStr:(NSString *)oldStr
{
        
        NSMutableString *str1 = [NSMutableString stringWithString:oldStr];
        for (int i = 0; i < str1.length; i++) {
                unichar c = [str1 characterAtIndex:i];
                unichar delete_C=[deleteStr characterAtIndex:0];
                NSRange range = NSMakeRange(i, 1);
                if ( c == delete_C) { //此处可以是任何字符
                        [str1 deleteCharactersInRange:range];
                        --i;
                    }
            }
        NSString *newstr = [NSString stringWithString:str1];
        return newstr;
}
+(NSString *) stringDeleteStringArr:(NSArray *)deleteStrArr fromStr:(NSString *)oldStr
{
        NSString *newstr=oldStr;
        for (int i=0; i<deleteStrArr.count; i++) {
                NSString *deleteStr=deleteStrArr[i];
            
            NSMutableString *str1 = [NSMutableString stringWithString:newstr];
            for (int i = 0; i < str1.length; i++) {
                    unichar c = [str1 characterAtIndex:i];
                    unichar delete_C=[deleteStr characterAtIndex:0];
                    NSRange range = NSMakeRange(i, 1);
                    if ( c == delete_C) { //此处可以是任何字符
                            [str1 deleteCharactersInRange:range];
                            --i;
                        }
                }
               newstr = [NSString stringWithString:str1];
            }
        return newstr;
    
}
+(NSString *)getDayOfTheWeekFromDate:(NSString *)date{//20160101
        int nian=[[date substringWithRange:NSMakeRange(0,4)] intValue];
    //    int yue=[[date substringWithRange:NSMakeRange(4,2)] intValue];
    //    int ri=[[date substringWithRange:NSMakeRange(6,2)] intValue];
    //    int cha_nian=nian-1-1;//与公元1年夹着多少年
        int runNian_shu=0;
        int pingNian_shu=0;
        //中间的闰年，平年分别多少个
        for (int i=1902; i<=nian-1; i++) {
                if ([self isRunNian:i]) {
                        runNian_shu++;//闰年数累计加1
                    }
                else{
                        pingNian_shu++;
                    }
            }
        
        //中间的天数
        int day_shu=runNian_shu*366+pingNian_shu*365;
        //公元元年的剩余天数
        int day_yuannian=364;
        
        //传入年份 已经度过的天数
        NSLog(@"runNian_shu %d",runNian_shu);
        NSLog(@"pingNian_shu %d",pingNian_shu);
        
        int day_duguo=[self DiJiTian:date];
        NSLog(@"day_shu %d",day_shu);
        NSLog(@"day_yuannian %d",day_yuannian);
        NSLog(@"day_duguo %d",day_duguo);
        int jieguo=day_duguo+day_yuannian+day_shu;
        NSLog(@"%d",jieguo);
        NSArray *week=@[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
        int xingqi=(2+jieguo)%7;//1901年1月1日星期2;
        return week[xingqi];
}
//输入日期返回，这是本年第几天
+(int)DiJiTian:(NSString *)date{
        int nian=[[date substringWithRange:NSMakeRange(0,4)] intValue];
        int yue=[[date substringWithRange:NSMakeRange(4,2)] intValue];
        int ri=[[date substringWithRange:NSMakeRange(6,2)] intValue];
        int diJIday=0;
        int day_runnian[]={0,31,29,31,30,31,30,31,31,30,31,30,31};
        int day_pingnian[]={0,31,28,31,30,31,30,31,31,30,31,30,31};
        //第几天
        if ([self isRunNian:nian]) {
                for (int i=1; i<=yue; i++) {
                        if (i==yue) {
                                diJIday=diJIday+ri;
                            }
                        else{
                             diJIday=diJIday+day_runnian[i];
                            }
                    }
            }
        else{
                for (int i=1; i<=yue; i++) {
                        if (i==yue) {
                                diJIday=diJIday+ri;
                            }
                        else{
                                diJIday=diJIday+day_pingnian[i];
                            }
                    }
            }
        
        return diJIday;
}
+(NSString *)getColorStrFromcolor:(UIColor *)clolor_lk{
        CGColorRef cgColor = clolor_lk.CGColor;
        const CGFloat *cs=CGColorGetComponents(cgColor);
        //获取颜色的3个数值，分别是数组CS【0】对应红,1对应蓝，2对应绿....
        //可以看到输出0.968627 0.968627 0.968627，就是对应的数值了
    //    NSLog(@"%f%f%f",cs[0],cs[1],cs[2]);
        NSString *str=[NSString stringWithFormat:@"%f,%f,%f",cs[0],cs[1],cs[2]];
        return str;
}
//是否为闰年
+(BOOL)isRunNian:(int)nian2
{   //int nian2=[nian intValue];
        if((nian2%4==0&&nian2%100!=0)||nian2%400==0)
                return YES;
        else
                return NO;
}
//将时间转化成距离当前时间的格式，几分钟几小时，几天
+(NSString * )changeToRangeWithString:(NSString *)str
{
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * d = [dateFormatter dateFromString:str];
        
        NSTimeInterval late = [d timeIntervalSince1970]*1;
        
        NSString * timeString = nil;
        
        NSDate * dat = [NSDate dateWithTimeIntervalSinceNow:0];
        
        NSTimeInterval now = [dat timeIntervalSince1970]*1;
        
        NSTimeInterval cha = now - late;
        if (cha/3600 < 1) {
                
                timeString = [NSString stringWithFormat:@"%f", cha/60];
                
                timeString = [timeString substringToIndex:timeString.length-7];
                
                int num= [timeString intValue];
                
                if (num <= 1) {
                        
                        timeString = [NSString stringWithFormat:@"刚刚..."];
                        
                    }else{
                            
                            timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
                            
                        }
                
            }
        
        if (cha/3600 > 1 && cha/86400 < 1) {
                
                timeString = [NSString stringWithFormat:@"%f", cha/3600];
                
                timeString = [timeString substringToIndex:timeString.length-7];
                
                timeString = [NSString stringWithFormat:@"%@小时前", timeString];
                
            }
        
        if (cha/86400 > 1)
                
            {
                    
                    timeString = [NSString stringWithFormat:@"%f", cha/86400];
                    
                    timeString = [timeString substringToIndex:timeString.length-7];
                    
                    int num = [timeString intValue];
                    
                    if (num < 2) {
                            
                            timeString = [NSString stringWithFormat:@"昨天"];
                            
                        }else if(num == 2){
                                
                                timeString = [NSString stringWithFormat:@"前天"];
                                
                            }else if (num > 2 && num <7){
                                    
                                    timeString = [NSString stringWithFormat:@"%@天前", timeString];
                                    
                                }else if (num >= 7 && num <= 30) {
                                        
                                        timeString = [NSString stringWithFormat:@"%d周前",num/7];
                                        
                                    }else if(num > 30 && num <= 100){
                                            
                                            timeString = [NSString stringWithFormat:@"%d月前",num / 30];
                                            
                                        }else if (num>100) {
                                                //timeString = str;
                                                //如果时间距离现在太长久的话，直接提取原来字符串中空格号前面的字符串，即下面方法
                                                NSArray * arr = [str componentsSeparatedByString:@" "];
                                                timeString = arr[0];
                                            }
                    
                }
        
        return timeString;
}




/**
  *  为了正常的显示汉字
  *
  *  @param dic
  */
+(void)logDic:(NSDictionary *)dic
{
        NSString *tempStr1 = [[dic description] stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
        NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
        NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
        NSString *str = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
        NSLog(@"dic:%@",str);
}




/**
  *  单例
  *
  *  @return 单例
  */
//+(AFHTTPSessionManager *)initSingle_AFHTTPSessionManager{
//        static AFHTTPSessionManager *manager=nil;
//        if (manager==nil) {
//                 manager=[[AFHTTPSessionManager alloc]init];
//            }
//            //4。严格的单例 （防止被继承）
//            NSString *classStr=NSStringFromClass([manager class]);
//        NSLog(@"%@",classStr);
//            //如果不是它本身类就让它崩溃
//    //        if (![classStr isEqualToString:@"AFHTTPSessionManager"]) {
//    //           NSLog(@"你可能对AFHTTPSessionManager进行了继承，这导致了崩溃。单例方法不允许这样做");
//    //           NSParameterAssert(nil);
//    //        }
//            
//    return manager;
//}


/**
  *  创建单例队列
  */
+(dispatch_queue_t)createlukeQueue{
        static dispatch_queue_t my_queue=nil;
        if (my_queue==nil) {
                my_queue = dispatch_queue_create("lukeQueue", DISPATCH_QUEUE_SERIAL);
            }
        
        return my_queue;
}




/**
  *  机型的判断
  *
  *  @return
  */
+(int)iPhoneStyle{
        if (HEIGHT_lk==480) {
                return iPhone4;
            }
        else if (HEIGHT_lk==568) {
                return iPhone5;
            }
        else if (HEIGHT_lk==667)
                return iPhone6;
        else if (HEIGHT_lk==736){
                return iPhone6p;
            }
        else if (HEIGHT_lk==1024){
                return iPadAir;
            }
        else if (HEIGHT_lk==1366){
                return iPadPro;
            }
        else{
                return -1;
            }
}



/**
  *  通过在钥匙串存放“设备号”，来达到一个设备始终只有一个设备号的目的  就是类似  UUID
  *
  *
  *  @return  LK_UUID
  */
#pragma mark 钥匙串存密码
//+(NSString *)getLK_UUID{
//        NSString *SERVICE_NAME=@"YiHuo";
//        //4、取设备号
//        NSString *passWord =  [SFHFKeychainUtils getPasswordForUsername:@"iphone"
//                                                                                    andServiceName:SERVICE_NAME
//                                                                                    error:nil];
//        NSLog(@"%@",passWord);
//        if (passWord.length<1||passWord==nil){//如果没取到 创建 我的UUID
//                
//                //创建 我的UUID
//                NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
//                NSTimeInterval time=[date timeIntervalSince1970]*1000;
//                NSString *timeString = [NSString stringWithFormat:@"%f", time];//转为字符型
//                NSLog(@"%@",timeString);
//                
//                
//                //拼接随机数，减少重复出现的可能
//                int x = arc4random() % 10000;
//                NSLog(@"%d",x);
//                NSString *LK_UUID=[NSString stringWithFormat:@"%@LK%d",timeString,x];
//                NSLog(@"%@",LK_UUID);
//                
//                //新“设备号”写入钥匙串
//                [SFHFKeychainUtils storeUsername:@"iphone"
//                                              andPassword:LK_UUID
//                                           forServiceName:SERVICE_NAME
//                                           updateExisting:1
//                                                    error:nil];
//                passWord = [SFHFKeychainUtils getPasswordForUsername:@"iphone"
//                                                                          andServiceName:SERVICE_NAME
//                                                                                   error:nil];
//            }
//        
//    
//        // 5、删除用户：
//        // [SFHFKeychainUtils deleteItemForUsername:@"dd" andServiceName:SERVICE_NAME error:nil];
//        return passWord;
//}
+(void)setView_X:(CGFloat)x andView:(UIView *)view{
    view.frame = CGRectMake(x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
}
+(void)setView_Y:(CGFloat)y andView:(UIView *)view{
    view.frame = CGRectMake(view.frame.origin.x, y, view.frame.size.width, view.frame.size.height);
}
+(void)setView_Width:(CGFloat)width andView:(UIView *)view{
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,width, view.frame.size.height);
}
+(void)setView_Height:(CGFloat)height andView:(UIView *)view{
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,view.frame.size.width,height);
}
+(void)setView_CenterX:(CGFloat)centerX andView:(UIView *)view{
    view.frame = CGRectMake(centerX-view.frame.size.width/2, view.frame.origin.y,view.frame.size.width,view.frame.size.height);
}
+(void)setView_CenterY:(CGFloat)centerY andView:(UIView *)view{
    view.frame = CGRectMake(view.frame.origin.x, centerY-view.frame.size.height/2,view.frame.size.width,view.frame.size.height);
}
@end
