//
//  WBBooksManager.h
//  Lebang
//
//  Created by 熊良军 on 15/1/9.
//  Copyright (c) 2015年 熊良军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBBooksManager : NSObject
+ (WBBooksManager *)sharedInstance;
//获得plist路径
-(NSString*)getPlistPath;
//判断沙盒中名为plistname的文件是否存在
-(BOOL) isPlistFileExists;
-(void)initPlist;
//判断key的书是否存在
-(BOOL)isBookExistsForKey:(NSString*)key;
//根据key值删除对应书籍
-(void)removeBookWithKey:(NSString *)key;
//删除plistPath路径对应的文件
-(void)deletePlist;
//将dictionary写入plist文件，前提：dictionary已经准备好
-(void)writePlist:(NSMutableDictionary*)dictionary forKey:(NSString *)key;
//
-(NSMutableDictionary*)readPlist;
//读取plist文件内容复制给dictionary   备用
-(void)readPlist:(NSMutableDictionary **)dictionary;
//更改一条数据，就是把dictionary内key重写
-(void)replaceDictionary:(NSMutableDictionary *)newDictionary withDictionaryKey:(NSString *)key;
-(NSInteger)getBooksCount;
@end
