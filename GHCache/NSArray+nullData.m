//
//  NSArray+nullData.m
//  ChaoFanZhuangShi
//
//  Created by Ren Guohua on 14-1-10.
//  Copyright (c) 2014年 Ren Guohua. All rights reserved.
//

#import "NSArray+nullData.h"

@implementation NSArray (nullData)


-(BOOL)writeToPlistFile:(NSString*)filepath{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
   
    BOOL didWriteSuccessfull = [data writeToFile:filepath atomically:YES];
    return didWriteSuccessfull;
}

+(NSArray*)readFromPlistFile:(NSString*)filePath{
    
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    if (data == nil)
    {
        return nil;
    }
    return  [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
@end
