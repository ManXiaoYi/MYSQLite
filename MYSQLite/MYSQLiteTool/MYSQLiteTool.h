//
//  MYSQLiteTool.h
//  FMDBDemo
//
//  Created by 满孝意 on 2016/11/30.
//  Copyright © 2016年 满孝意. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface MYSQLiteTool : NSObject

#pragma mark -
#pragma mark - 初始化
/**
 数据库工具单例
 
 @return 数据库工具对象
 */
+ (MYSQLiteTool *)sharedInstance;


/**
 创建数据库
 
 @param dbName 数据库名称
 @return 数据库（需要加后缀  .sqlite）
 */
- (FMDatabase *)createDataBaseWithDBName:(NSString *)dbName;


/**
 给指定数据库 建表
 
 @param db 指定数据库对象
 @param tableName 表名
 @param keyTypes 字段 及 对应字段类型
 */
- (void)DataBase:(FMDatabase *)db createTable:(NSString *)tableName keyTypes:(NSDictionary *)keyTypes;


#pragma mark -
#pragma mark - 增
/**
 给指定数据库的表 添加值
 
 @param db 指定数据库对象
 @param tableName 表名
 @param keyValues 字段 及 对应值
 */
- (void)DataBase:(FMDatabase *)db table:(NSString *)tableName insertKeyValues:(NSDictionary *)keyValues;


#pragma mark -
#pragma mark - 删
/**
 指定数据库中 清理数据
 
 @param db 指定数据库对象
 @param tableName 表名
 */
- (void)DataBase:(FMDatabase *)db clearDataForTable:(NSString *)tableName;


#pragma mark -
#pragma mark -改
/**
 给指定数据库的表 更新值
 
 @param db 指定数据库对象
 @param tableName 表名
 @param keyValues 字段 及 对应值
 */
- (void)DataBase:(FMDatabase *)db table:(NSString *)tableName updateKeyValues:(NSDictionary *)keyValues;


/**
 给指定数据库的表 更新值(条件更新)
 
 @param db 指定数据库对象
 @param tableName 表名
 @param keyValues 字段 及 对应字段类型
 @param condition 筛选条件
 */
- (void)DataBase:(FMDatabase *)db table:(NSString *)tableName updateKeyValues:(NSDictionary *)keyValues whereCondition:(NSDictionary *)condition;


#pragma mark -
#pragma mark - 查
/**
 给指定数据库的表 查询值
 
 @param db 指定数据库对象
 @param tableName 表名
 @param keyTypes 字段 及 对应字段类型
 @return 查询结果
 */
- (NSArray *)DataBase:(FMDatabase *)db table:(NSString *)tableName selectKeyTypes:(NSDictionary *)keyTypes;


/**
 给指定数据库的表 查询值(条件查询)
 
 @param db 指定数据库对象
 @param tableName 表名
 @param keyTypes 字段 及 对应字段类型
 @param condition 筛选条件
 @return 查询结果
 */
- (NSArray *)DataBase:(FMDatabase *)db table:(NSString *)tableName selectKeyTypes:(NSDictionary *)keyTypes whereCondition:(NSDictionary *)condition;


/**
 模糊查询 - 字符串为前缀的字段
 
 @param db 指定数据库对象
 @param tableName 表名
 @param keyTypes 字段 及 对应字段类型
 @param key 条件字段
 @param beginStr 前缀字符串
 @return 查询结果
 */
- (NSArray *)DataBase:(FMDatabase *)db table:(NSString *)tableName selectKeyTypes:(NSDictionary *)keyTypes whereKey:(NSString *)key beginStr:(NSString *)beginStr;


/**
 模糊查询 - 字符串为包含的字段
 
 @param db 指定数据库对象
 @param tableName 表名
 @param keyTypes 字段 及 对应字段类型
 @param key 条件字段
 @param containStr 包含字符串
 @return 查询结果
 */
- (NSArray *)DataBase:(FMDatabase *)db table:(NSString *)tableName selectKeyTypes:(NSDictionary *)keyTypes whereKey:(NSString *)key containStr:(NSString *)containStr;


/**
 模糊查询 - 字符串为后缀的字段
 
 @param db 指定数据库对象
 @param tableName 表名
 @param keyTypes 字段 及 对应字段类型
 @param key 条件字段
 @param endStr 后缀字符串
 @return 查询结果
 */
- (NSArray *)DataBase:(FMDatabase *)db table:(NSString *)tableName selectKeyTypes:(NSDictionary *)keyTypes whereKey:(NSString *)key endStr:(NSString *)endStr;

@end
