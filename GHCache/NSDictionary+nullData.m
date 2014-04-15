//
//  NSDictionary+nullData.m
//  fanfan
//
//  Created by Ren Guohua on 14-3-1.
//  Copyright (c) 2014年 yunfen. All rights reserved.
//

#import "NSDictionary+nullData.h"

@implementation NSDictionary (nullData)

-(BOOL)writeToPlistFile:(NSString*)filepath{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
    
    BOOL didWriteSuccessfull = [data writeToFile:filepath atomically:YES];
    return didWriteSuccessfull;
}

+(NSDictionary*)readFromPlistFile:(NSString*)filePath{
    
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    return  [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
@end
