//
//  NSBundle+HLTool.m
//  HLTool
//
//  Created by feige on 2023/4/11.
//

#import "NSBundle+HLTool.h"
#import "HLDefine.h"

@implementation NSBundle (HLTool)

+ (instancetype)hlResourceBundle
{
    static NSBundle *hlBundle = nil;
    if (hlBundle == nil) {
        NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"HLConfiguration")];
        NSURL *bundleURL = [bundle URLForResource:@"HLTool" withExtension:@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
        if (!resourceBundle) {
            NSString *bundlePath = [bundle.resourcePath stringByAppendingPathComponent:@"HLTool.bundle"];
            resourceBundle = [NSBundle bundleWithPath:bundlePath];
        }
        hlBundle = resourceBundle ?: bundle;
    }
    return hlBundle;
}

+ (UIImage *)imageForHLTool:(NSString *)name
{
    NSString *path = [[[NSBundle hlResourceBundle] resourcePath] stringByAppendingPathComponent:name];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (!image) {
        image = [UIImage imageNamed:path];
    }
    return image;
}

+ (NSString *)getToolFilePath:(NSString *)name type:(NSString *)type {
    return [[NSBundle hlResourceBundle] pathForResource:name ofType:type];
}

static NSBundle *bundle = nil;

+ (void)hlResetLanguage {
    bundle = nil;
}

+ (NSString *)hlLocalizedStringForKey:(NSString *)key {
    return [self hlLocalizedStringForKey:key value:nil];
}

+ (NSString *)hlLocalizedStringForKey:(NSString *)key value:(NSString *)value {
    if (bundle == nil) {
        // 从bundle中查找资源
        bundle = [NSBundle bundleWithPath:[[NSBundle hlResourceBundle] pathForResource:[self getLanguage] ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

+ (NSString *)getLanguage {
    HLLanguageType type = [[[NSUserDefaults standardUserDefaults] valueForKey:HLLanguageTypeKey] integerValue];
    
    NSString *language = nil;
    switch (type) {
        case HLLanguageSystem: {
            language = [NSLocale preferredLanguages].firstObject;
            if ([language hasPrefix:@"en"]) {
                language = @"en";
            } else if ([language hasPrefix:@"zh"]) {
                if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                    language = @"zh-Hans"; // 简体中文
                } else { // zh-Hant\zh-HK\zh-TW
                    language = @"zh-Hant"; // 繁體中文
                }
            } else if ([language hasPrefix:@"ja"]) {
                language = @"ja-US";
            } else {
                language = @"en";
            }
        }
            break;
        case HLLanguageChineseSimplified:
            language = @"zh-Hans";
            break;
        case HLLanguageChineseTraditional:
            language = @"zh-Hant";
            break;
        case HLLanguageEnglish:
            language = @"en";
            break;
        case HLLanguageJapanese:
            language = @"ja-US";
            break;
    }
    return language;
}

+ (NSInteger)getLanguageType {
    HLLanguageType type = [[[NSUserDefaults standardUserDefaults] valueForKey:HLLanguageTypeKey] integerValue];
    if (type != HLLanguageSystem) {
        return type;
    }
    
    NSString *language = [NSLocale preferredLanguages].firstObject;
    if ([language hasPrefix:@"en"]) {
        return HLLanguageEnglish;
    } else if ([language hasPrefix:@"zh"]) {
        if ([language rangeOfString:@"Hans"].location != NSNotFound) {
            return HLLanguageChineseSimplified;
        } else { // zh-Hant\zh-HK\zh-TW
            return HLLanguageChineseTraditional;
        }
    } else if ([language hasPrefix:@"ja"]) {
        return HLLanguageJapanese;
    } else {
        return HLLanguageEnglish;
    }
    return HLLanguageEnglish;
}

@end
