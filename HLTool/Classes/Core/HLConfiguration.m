//
//  HLConfiguration.m
//  HLTool
//
//  Created by feige on 2023/4/11.
//

#import "HLConfiguration.h"

@implementation HLConfiguration

+ (void)languageType:(HLLanguageType)languageType {
    [[NSUserDefaults standardUserDefaults] setValue:@(languageType) forKey:HLLanguageTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [NSBundle hlResetLanguage];
}

+ (HLLanguageType)getLanaguage {
    HLLanguageType type = [[[NSUserDefaults standardUserDefaults] valueForKey:HLLanguageTypeKey] integerValue];
    return type;
}

@end
