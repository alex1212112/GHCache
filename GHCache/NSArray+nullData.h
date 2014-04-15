//
//  NSArray+nullData.h
//  ChaoFanZhuangShi
//
//  Created by Ren Guohua on 14-1-10.
//  Copyright (c) 2014年 Ren Guohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (nullData)
-(BOOL)writeToPlistFile:(NSString*)filepath;
+(NSArray*)readFromPlistFile:(NSString*)filePath;
@end
