//
//  HLDefine.h
//  HLTools
//
//  Created by feige on 2023/4/11.
//

#ifndef HLDefine_h
#define HLDefine_h

#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_SCORE    ([UIScreen mainScreen].bounds.size.width / 320.f)
#define WEAK_SELF       typeof(self) __weak weakSelf = self;
#define STRONG_SELF     typeof(weakSelf) __strong strongSelf = weakSelf;

#define kAPPDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

// corlor
#define RGB(r, g, b)                 [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBA(r, g, b, a)             [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define UIColorFromHEX(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromHEXA(rgbValue,a)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

//异性全面屏
#define kIsFullScreen ({\
BOOL isBangsScreen = NO; \
if (@available(iOS 11.0, *)) { \
UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
isBangsScreen = window.safeAreaInsets.bottom > 0; \
} \
isBangsScreen; \
})
// Status bar height.
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
// Navigation bar height.
#define kNavigationBarHeight 44.f
// Tabbar height.
#define kTabbarHeight (kIsFullScreen ? (49.f+34.f) : 49.f)
// Tabbar safe bottom margin.
#define kTabbarSafeBottomMargin (kIsFullScreen ? 34.f : 0.f)
// Status bar & navigation bar height.
#define kStatusBarAndNavigationBarHeight (kIsFullScreen ? 88.f : 64.f)

// debug log
#ifdef DEBUG
#   define HLLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] );
#else
#   define HLLog(...)
#endif

#import "NSBundle+HLTools.h"

typedef NS_ENUM(NSUInteger, HLLanguageType) {
    //跟随系统语言，默认
    HLLanguageSystem,
    //中文简体
    HLLanguageChineseSimplified,
    //中文繁体
    HLLanguageChineseTraditional,
    //英文
    HLLanguageEnglish,
    //日文
    HLLanguageJapanese,
};

#define HLLanguageTypeKey @"HLLanguageTypeKey"

static inline NSString *GetLocalLanguageTextValue(NSString *key) {
    return [NSBundle hlLocalizedStringForKey:key];
}

static inline UIImage *GetImageWithName(NSString *name) {
    return [NSBundle imageForHLTools:name];
}

static inline HLLanguageType GetLanguageType() {
    return (HLLanguageType)[NSBundle getLanguageType];
}

#endif /* HLDefine_h */
