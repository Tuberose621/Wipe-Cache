//
//  NSString+CYExtension.m
//  聪颖不聪颖
//
//  Created by 葛聪颖 on 15/11/3.
//  Copyright © 2015年 gecongying. All rights reserved.
//

#import "NSString+CYExtension.h"

@implementation NSString (CYExtension)
// 判断一个路径是文件夹 or 文件
//    [[mgr attributesOfItemAtPath:self error:nil].fileType isEqualToString:NSFileTypeDirectory];

- (NSInteger)fileSize
{
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 是否为文件夹
    BOOL isDirectory = NO;
    // 这个路径是否存在
    BOOL exists = [mgr fileExistsAtPath:self isDirectory:&isDirectory];
    // 路径不存在
    if (exists == NO) return 0;
    
    if (isDirectory) { // 文件夹
        // 总大小
        NSInteger size = 0;
        // 获得文件夹中的所有内容
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:self];
        for (NSString *subpath in enumerator) {
            // 获得全路径
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            // 获得文件属性
            size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
        return size;
    } else { // 文件
        return [mgr attributesOfItemAtPath:self error:nil].fileSize;
    }
}


@end
