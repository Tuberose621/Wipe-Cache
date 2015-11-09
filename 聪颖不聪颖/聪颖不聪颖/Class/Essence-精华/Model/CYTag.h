//
//  CYTag.h
//  聪颖不聪颖
//
//  Created by 葛聪颖 on 15/10/9.
//  Copyright © 2015年 gecongying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYTag : NSObject
/** 图片 */
@property (nonatomic, copy) NSString *image_list;
/** 订阅数 */
@property (nonatomic, assign) NSInteger sub_number;
/** 名字 */
@property (nonatomic, copy) NSString *theme_name;

@end
