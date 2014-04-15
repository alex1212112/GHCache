//
//  NSDictionary+nullData.h
//  fanfan
//
//  Created by Ren Guohua on 14-3-1.
//  Copyright (c) 2014年 yunfen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (nullData)

-(BOOL)writeToPlistFile:(NSString*)filepath;
+(NSDictionary*)readFromPlistFile:(NSString*)filePath;

@end
