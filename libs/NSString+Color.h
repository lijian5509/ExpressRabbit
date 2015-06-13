//
//  NSString+Color.h
//  ExpressRabbit
//
//  Created by kuaiditu on 15-3-9.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Color)
-(NSAttributedString *)selfFont:(CGFloat)sfont
                      selfColor:(UIColor *)selfColor
                      LightText:(NSString *)text
                      LightFont:(CGFloat)lfont
                     LightColor:(UIColor *)lightColor;

@end
