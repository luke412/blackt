//
//  QueueManger.m
//  BlackT2017
//
//  Created by 鲁柯 on 2017/3/10.
//  Copyright © 2017年 鲁柯. All rights reserved.
//

#import "QueueManger.h"

@implementation QueueManger
//
//-(void)addQueueWithMacName:(NSString *)queueName{
//    const char * myQueueName =[queueName UTF8String];
//    dispatch_queue_t queue = dispatch_queue_create(myQueueName, DISPATCH_QUEUE_SERIAL);
//    if (!self.queueDictionary) {
//         self.queueDictionary = [[NSMutableDictionary alloc]init];
//    }
//}
//-(void)saveQueueToDictionary:(dispatch_queue_t)Queue{
//    NSMutableData *data = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [archiver encodeObject:Queue forKey:@"luke"];//这个相当于秘钥
//    [archiver finishEncoding];
//    
//    
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//    dispatch_queue_t queue = [unarchiver decodeObjectForKey:@"luke"];
//    [unarchiver finishDecoding];
//}
@end
