//
//  GHCache.m
//  GHCache
//
//  Created by Ren Guohua on 14-2-12.
//  Copyright (c) 2014年 ghren. All rights reserved.
//

#import "GHCache.h"

static  NSMutableDictionary *memoryCache;
static  NSMutableArray *recentlyAccessedKeys;
static int kCacheMemoryLimit;
static GHCache *instance = nil;

@implementation GHCache

/**
 *  单例，静态初始化方法
 *
 *  @return 返回一个单例
 */
+ (GHCache*)shareCache{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

/**
 *  初始化方法,增加相关通知，并判断应用的版本信息来确定缓存数据是否要清除
 *
 *  @return self
 */
- (id)init
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveMemoryCacheToDisk:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveMemoryCacheToDisk:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveMemoryCacheToDisk:) name:UIApplicationWillTerminateNotification object:nil];
        
        [self clearCacheDependOnVersion];
        
    }
    return self;
}

/**
 *  在应用结束、退回到后台、收到内存告警的时候将内存缓存中的数据存储到磁盘上
 *
 *  @param notification 收到的通知
 */
- (void)saveMemoryCacheToDisk:(NSNotification*)notification
{
    for (NSString *fileName in [memoryCache allKeys])
    {
        NSString *filePath = [self getFilePahtOfCacheWithFileName:fileName];
        NSData *data = [memoryCache objectForKey:fileName];
        [data writeToFile:filePath atomically:YES];
    }
    
    [memoryCache removeAllObjects];
}

/**
 *  获取在NSCachesDirectory下文件的路径
 *
 *  @param fileName 文件的名称
 *
 *  @return 文件的路径
 */
- (NSString*)getFilePahtOfCacheWithFileName:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:fileName];
    
    return path;
}


/**
 *  获取所有缓存文件的路径
 *
 *  @return 返回缓存文件路径的数组
 */
- (NSMutableArray*)getAllFilePathsOfCaches
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *fileList =[fileManager contentsOfDirectoryAtPath:cachePath error:NULL];
    
    NSMutableArray *filePathArray = [[NSMutableArray alloc] init];
    for (NSString *file in fileList) {
        
        NSString *path =[cachePath stringByAppendingPathComponent:file];
        [filePathArray addObject:path];
    }
    return filePathArray;
}

/**
 *  删除所有缓存里的文件,清除缓存
 */
- (void)clearCache
{
    NSMutableArray *filePathArray = [self getAllFilePathsOfCaches];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
    for (NSString *path in filePathArray)
    {
        [fileManager removeItemAtPath:path error:nil];
    }
    [memoryCache removeAllObjects];
}

/**
 *  从info.plist文件中获取该应用的版本号
 *
 *  @return 该应用版本号的字符串
 */
- (NSString *)appVersion
{
    CFStringRef versStr = (CFStringRef)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey);
    NSString *version = [NSString stringWithUTF8String:CFStringGetCStringPtr(versStr,kCFStringEncodingMacRoman)];

    return version;
}
/**
 *  增加应用版本升级时候的缓存实效功能，缓存失效的时候会被清除
 */
- (void)clearCacheDependOnVersion
{
    double lastSavedCacheVersion = [[NSUserDefaults standardUserDefaults] doubleForKey:@"CACHE_VERSION"];
    double currentAppVersion = [[self appVersion] doubleValue];
    
    if (lastSavedCacheVersion == 0.0f || lastSavedCacheVersion != currentAppVersion)
    {
        [self clearCache];
        [[NSUserDefaults standardUserDefaults] setDouble:currentAppVersion forKey:@"CACHE_VERSION"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/**
 *  将数据透明的缓存到内存缓存中，如果内存缓存超出大小限制，就采取最近最不经常使用算法将其存储到磁盘上
 *
 *  @param data     数据
 *  @param fileName 文件名称
 */
- (void)cacheData:(NSData*)data tofile:(NSString*)fileName
{
    if (memoryCache == nil)
    {
        memoryCache = [[NSMutableDictionary alloc] init];
    }
    if (recentlyAccessedKeys == nil)
    {
        recentlyAccessedKeys = [[NSMutableArray alloc] init];
    }
    if (kCacheMemoryLimit == 0)
    {
        kCacheMemoryLimit = 10;
    }
    
    [memoryCache setObject:data forKey:fileName];
    
    if ([recentlyAccessedKeys containsObject:fileName])
    {
        [recentlyAccessedKeys  removeObject:fileName];
    }
    [recentlyAccessedKeys insertObject:fileName atIndex:0];

    if ([recentlyAccessedKeys count] > kCacheMemoryLimit)
    {
        NSString *leastRecentlyUsedFilename = [recentlyAccessedKeys lastObject];
        NSData *leastRecentlyUsedData = [memoryCache objectForKey:leastRecentlyUsedFilename];
        NSString *filePath = [self getFilePahtOfCacheWithFileName:fileName];
        [leastRecentlyUsedData writeToFile:filePath atomically:YES];
        [recentlyAccessedKeys removeLastObject];
        [memoryCache removeObjectForKey:leastRecentlyUsedFilename];
    }
    
}
/**
 *  从内存缓存中透明的获取缓存数据，如果内存缓存中没有该数据，则从磁盘中获取，如果都没有，返回nil；
 *
 *  @param fileName 文件名称
 *
 *  @return 返回获取到的数据，如果获取不到数据，返回nil
 */
- (NSData*)dataFromFile:(NSString*)fileName
{
    NSData *data = [memoryCache objectForKey:fileName];
    if (data)
    {
        return data;
    }
    
    NSString *filePath = [self getFilePahtOfCacheWithFileName:fileName];
    data = [NSData dataWithContentsOfFile:filePath];
    if (data && data.length > 0)
    {
        [self cacheData:data tofile:fileName];
        return data;
    }
    return nil;
}

- (void)dealloc
{

    memoryCache = nil;
    
    recentlyAccessedKeys = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

@end
