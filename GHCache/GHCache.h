//
//  GHCache.h
//  GHCache
//
//  Created by Ren Guohua on 14-2-12.
//  Copyright (c) 2014年 ghren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHCache : NSObject

+ (GHCache*)shareCache;//单例，静态初始化方法

- (NSString*)getFilePahtOfCacheWithFileName:(NSString*)fileName;//获取在NSCachesDirectory下文件的路径

- (NSMutableArray*)getAllFilePathsOfCaches;//获取所有缓存文件的路径

- (void)clearCache;//删除所有缓存里的文件,清除缓存

- (NSString*)appVersion;//从info.plist文件中获取该应用的版本号

- (void)clearCacheDependOnVersion;//增加应用版本升级时候的缓存实效功能，缓存失效的时候会被清除

- (void)cacheData:(NSData*)data tofile:(NSString*)fileName;//将数据透明的缓存到内存缓存中，如果内存缓存超出大小限制，就采取最近最不经常使用算法将其存储到磁盘上

- (NSData*)dataFromFile:(NSString*)fileName;// 从内存缓存中透明的获取缓存数据，如果内存缓存中没有该数据，则从磁盘中获取，如果都没有，返回nil；

- (void)saveMemoryCacheToDisk:(NSNotification*)notification;//在应用结束、退回到后台、收到内存告警的时候将内存缓存中的数据存储到磁盘上

@end
