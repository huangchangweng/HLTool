//
//  HLConfiguration.h
//  HLTool
//
//  Created by feige on 2023/4/11.
//

#import <Foundation/Foundation.h>
#import "HLDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLConfiguration : NSObject

+ (void)languageType:(HLLanguageType)type;

+ (HLLanguageType)getLanaguage;

@end

NS_ASSUME_NONNULL_END
