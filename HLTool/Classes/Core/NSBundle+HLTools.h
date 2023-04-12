//
//  NSBundle+HLTools.h
//  HLTools
//
//  Created by feige on 2023/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (HLTools)

+ (instancetype)hlResourceBundle;

+ (UIImage *)imageForHLTools:(NSString *)name;

+ (NSString *)getToolFilePath:(NSString *)name type:(NSString *)type;

+ (void)hlResetLanguage;

+ (NSString *)hlLocalizedStringForKey:(NSString *)key;

+ (NSString *)hlLocalizedStringForKey:(NSString *)key value:(nullable NSString *)value;

+ (NSString *)getLanguage;

+ (NSInteger)getLanguageType;

@end

NS_ASSUME_NONNULL_END
