//
//  CYThirdCell.m
//  聪颖不聪颖
//
//  Created by 葛聪颖 on 15/11/6.
//  Copyright © 2015年 gecongying. All rights reserved.
//

#import "CYThirdCell.h"

@implementation CYThirdCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.text = @"第三种cell";
        self.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:[[UISwitch alloc] init]];
    }
    return self;
}
@end
