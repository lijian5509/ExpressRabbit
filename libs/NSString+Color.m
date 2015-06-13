//
//  NSString+Color.m
//  ExpressRabbit
//
//  Created by kuaiditu on 15-3-9.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "NSString+Color.h"

@implementation NSString (Color)
-(NSAttributedString *)selfFont:(CGFloat)sfont
                      selfColor:(UIColor *)selfColor
                      LightText:(NSString *)text
                      LightFont:(CGFloat)lfont
                     LightColor:(UIColor *)lightColor
{
    NSString *temp = self;
    
    NSRange range = [self rangeOfString:text];
    
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:temp];
    
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:sfont] range:NSMakeRange(0,self.length)];
    
    [attributeStr addAttribute:NSForegroundColorAttributeName value:selfColor range:NSMakeRange(0,self.length)];
    
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:lfont] range:NSMakeRange(range.location,range.length)];
    
    [attributeStr addAttribute:NSForegroundColorAttributeName value:lightColor range:NSMakeRange(range.location,range.length)];
    
    return attributeStr;
}

@end
