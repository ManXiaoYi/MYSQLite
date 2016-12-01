//
//  MYSQLiteTool.m
//  FMDBDemo
//
//  Created by 满孝意 on 2016/11/30.
//  Copyright © 2016年 满孝意. All rights reserved.
//

#import "MYSQLiteTool.h"

static MYSQLiteTool *sharedInstance = nil;

@implementation MYSQLiteTool

#pragma mark -
#pragma mark - 单例
+ (MYSQLiteTool *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [super allocWithZone:zone];
        }
    });
    return sharedInstance;
}

#pragma mark -
#pragma mark - 创建数据库
- (FMDatabase *)createDataBaseWithDBName:(NSString *)dbName {
    //    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    //    NSString *filePath = [cachePath stringByAppendingPathComponent:dbName];
    //    NSLog(@"filePath -- %@", filePath);
    
    NSString *filePath = [@"/Users/manxiaoyi/Desktop/HHH" stringByAppendingPathComponent:dbName];
    NSLog(@"filePath -- %@", filePath);
    
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    if (![db open]) {
        NSLog(@"获取数据库错误，请确认数据库后缀是否添加 .sqlite");
        return nil;
    }
    
    return db;
}

#pragma mark -
#pragma mark - 给指定数据库 建表
- (void)DataBase:(FMDatabase *)db createTable:(NSString *)tableName keyTypes:(NSDictionary *)keyTypes {
    if ([self isOpenDatabese:db]) {
        NSString *prefixStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (", tableName];
        NSMutableString *sqlStr = [[NSMutableString alloc] initWithString:prefixStr];
        
        int count = 0;
        for (NSString *key in keyTypes) {
            count++;
            [sqlStr appendFormat:@"%@ %@", key, keyTypes[key]];
            if (count != keyTypes.count) {
                [sqlStr appendString:@", "];
            }
        }
        [sqlStr appendString:@")"];
        
        NSLog(@"sqlStr -- %@", sqlStr);
        
        [db executeUpdate:sqlStr];
    }
}

#pragma mark -
#pragma mark - 给指定数据库的表 添加值
- (void)DataBase:(FMDatabase *)db table:(NSString *)tableName insertKeyValues:(NSDictionary *)keyValues {
    if ([self isOpenDatabese:db]) {
        NSString *prefixStr = [NSString stringWithFormat:@"INSERT INTO %@ (", tableName];
        NSMutableString *sqlStr = [[NSMutableString alloc] initWithString:prefixStr];
        
        int count = 0;
        NSMutableString *formStr = [[NSMutableString alloc] init];
        for (NSString *key in keyValues.allKeys) {
            count++;
            [sqlStr appendString:key];
            [formStr appendString:@"?"];
            if (count != keyValues.allKeys.count) {
                [sqlStr appendString:@", "];
                [formStr appendString:@", "];
            }
        }
        
        [sqlStr appendFormat:@"%@%@%@", @") VALUES (", formStr, @")"];
        
        NSLog(@"sqlStr -- %@", sqlStr);
        
        [db executeUpdate:sqlStr withArgumentsInArray:keyValues.allValues];
    }
}

#pragma mark -
#pragma mark - 指定数据库中 清理数据
- (void)DataBase:(FMDatabase *)db clearDataForTable:(NSString *)tableName {
    if ([self isOpenDatabese:db]) {
        [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@", tableName]];
    }
}

#pragma mark -
#pragma mark - 给指定数据库的表 更新值
- (void)DataBase:(FMDatabase *)db table:(NSString *)tableName updateKeyValues:(NSDictionary *)keyValues {
    if ([self isOpenDatabese:db]) {
        for (NSString *key in keyValues) {
            NSString *sqlStr = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?", tableName, key];
            [db executeUpdate:sqlStr, keyValues[key]];
        }
    }
}

#pragma mark -
#pragma mark - 给指定数据库的表 更新值(条件更新)
- (void)DataBase:(FMDatabase *)db table:(NSString *)tableName updateKeyValues:(NSDictionary *)keyValues whereCondition:(NSDictionary *)condition {
    if ([self isOpenDatabese:db]) {
        for (NSString *key in keyValues) {
            NSString *sqlStr = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?", tableName, key, condition.allKeys[0]];
            [db executeUpdate:sqlStr, keyValues[key], keyValues[condition.allKeys[0]]];
        }
    }
}

#pragma mark -
#pragma mark - 给指定数据库的表 查询值
- (NSArray *)DataBase:(FMDatabase *)db table:(NSString *)tableName selectKeyTypes:(NSDictionary *)keyTypes {
    FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ LIMIT 10",tableName]];
    return [self getArrayWithFMResultSet:result keyTypes:keyTypes];
}

#pragma mark -
#pragma mark - 给指定数据库的表 查询值(条件查询)
- (NSArray *)DataBase:(FMDatabase *)db table:(NSString *)tableName selectKeyTypes:(NSDictionary *)keyTypes whereCondition:(NSDictionary *)condition {
    if ([self isOpenDatabese:db]) {
        FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? LIMIT 10", tableName, condition.allKeys[0]], condition[condition.allKeys[0]]];
        return [self getArrayWithFMResultSet:result keyTypes:keyTypes];
    }
    return nil;
}

#pragma mark -
#pragma mark - 模糊查询 - 字符串为前缀的字段
- (NSArray *)DataBase:(FMDatabase *)db table:(NSString *)tableName selectKeyTypes:(NSDictionary *)keyTypes whereKey:(NSString *)key beginStr:(NSString *)beginStr {
    if ([self isOpenDatabese:db]) {
        FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIKE '%@%%' LIMIT 10", tableName, key, beginStr]];
        return [self getArrayWithFMResultSet:result keyTypes:keyTypes];
    }
    return nil;
}

#pragma mark -
#pragma mark - 模糊查询 - 字符串为包含的字段
- (NSArray *)DataBase:(FMDatabase *)db table:(NSString *)tableName selectKeyTypes:(NSDictionary *)keyTypes whereKey:(NSString *)key containStr:(NSString *)containStr {
    if ([self isOpenDatabese:db]) {
        FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIKE '%%%@%%' LIMIT 10", tableName, key, containStr]];
        return [self getArrayWithFMResultSet:result keyTypes:keyTypes];
    }
    return nil;
}

#pragma mark -
#pragma mark - 模糊查询 - 字符串为后缀的字段
- (NSArray *)DataBase:(FMDatabase *)db table:(NSString *)tableName selectKeyTypes:(NSDictionary *)keyTypes whereKey:(NSString *)key endStr:(NSString *)endStr {
    if ([self isOpenDatabese:db]) {
        FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIKE '%%%@' LIMIT 10", tableName, key, endStr]];
        return [self getArrayWithFMResultSet:result keyTypes:keyTypes];
    }
    return nil;
}

#pragma mark -
#pragma mark - Method
- (NSArray *)getArrayWithFMResultSet:(FMResultSet *)result keyTypes:(NSDictionary *)keyTypes {
    NSMutableArray *tempArr = [NSMutableArray array];
    while ([result next]) {
        
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        for (int i = 0; i < keyTypes.count; i++) {
            NSString *key = keyTypes.allKeys[i];
            NSString *value = keyTypes[key];
            
            if ([value isEqualToString:@"text"]) { // 字符串
                [tempDic setValue:[result stringForColumn:key] forKey:key];
            }
            else if ([value isEqualToString:@"blob"]) { // 二进制对象
                [tempDic setValue:[result dataForColumn:key] forKey:key];
            }
            else if ([value isEqualToString:@"integer"]) { // 带符号整数类型
                [tempDic setValue:[NSNumber numberWithInt:[result intForColumn:key]] forKey:key];
            }
            else if ([value isEqualToString:@"boolean"]) { // BOOL型
                [tempDic setValue:[NSNumber numberWithBool:[result boolForColumn:key]] forKey:key];
            }
            else if ([value isEqualToString:@"date"]) { //  date
                [tempDic setValue:[result dateForColumn:key] forKey:key];
            }
        }
        
        [tempArr addObject:tempDic];
    }
    
    return tempArr;
}

- (BOOL)isOpenDatabese:(FMDatabase *)db {
    if (![db open]) {
        [db open];
    }
    return YES;
}

@end
