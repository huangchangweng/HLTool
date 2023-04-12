//
//  UIColor+HHTool.h
//  HLTool
//
//  Created by feige on 2023/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HLTool)

+ (UIColor *)hl_fromShortHexValue:(NSUInteger)hex;
+ (UIColor *)hl_fromShortHexValue:(NSUInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)hl_fromHexValue:(NSUInteger)hex;
+ (UIColor *)hl_fromHexValue:(NSUInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)hl_colorWithString:(NSString *)string;

+ (UIColor *)hl_colorWithHex:(long)hex;
+ (UIColor *)hl_colorWithIntegerRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

+ (UIColor *)hl_colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;

@end

NS_ASSUME_NONNULL_END
