//
//  CYSquareButton.h
//  聪颖不聪颖
//
//  Created by 葛聪颖 on 15/10/10.
//  Copyright © 2015年 gecongying. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CYSquare;

@interface CYSquareButton : UIButton
/** 方块模型 */
@property (nonatomic, strong) CYSquare *square;
@end

