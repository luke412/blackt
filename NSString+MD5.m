//
//  NSString+MD5.m
//  picturer
//
//  Created by BaiLinfeng on 16/7/4.
//  Copyright © 2016年 FR. All rights reserved.
//

#import "NSString+MD5.h"
#import "CommonCrypto/CommonDigest.h"
@implementation NSString (MD5)
+(NSString *)md5HexDigest:(NSString*)Des_str

{
    
    const char *original_str = [Des_str UTF8String];
    
    //unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
    
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
 
    
    for (int i = 0; i < 16; i++)
        
  
    {
        
        //x表示十六进制，X  意思是不足两位将用0补齐，如果多余两位则不影响
        
        [hash appendFormat:@"%02X", result[i]];
        
    }

    NSString *mdfiveString = [hash lowercaseString];

    // //NNSLog(@"md5加密输出：Encryption Result = %@",mdfiveString);
 
    return mdfiveString;

}
@end
