//
//  HLUtils.m
//  HLUtils
//
//  Created by JJB_iOS on 2022/5/23.
//

#import "HLUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CoreGraphics/CoreGraphics.h>
#include <sys/mount.h>

@implementation HLUtils

/// 获取pp版本
+ (NSString *)appVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

/// 随机颜色
+ (UIColor *)randomColor
{
    CGFloat red = (CGFloat)(arc4random() % 255)/255.0;
    CGFloat green = (CGFloat)(arc4random() % 255)/255.0;
    CGFloat blue = (CGFloat)(arc4random() % 255)/255.0;
    
    UIColor *color = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:0.5];
    return color;
}

/// 获取字符串高度
+ (float)heightForString:(NSString *)value
                    font:(UIFont *)font
                   width:(float)width
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGSize textSize;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                   options:(NSStringDrawingUsesLineFragmentOrigin |
                                            NSStringDrawingTruncatesLastVisibleLine)
                                attributes:attributes
                                   context:nil].size;
    return ceil(textSize.height);
}

/// 获取字符串高度
+ (float)heightForString:(NSString *)value
                    font:(UIFont *)font
                   width:(float)width
             lineSpacing:(CGFloat)lineSpacing
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGSize textSize;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.lineSpacing  = lineSpacing;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                   options:(NSStringDrawingUsesLineFragmentOrigin |
                                            NSStringDrawingTruncatesLastVisibleLine)
                                attributes:attributes
                                   context:nil].size;
    return ceil(textSize.height);
}

/// 获取字符串宽度
+ (float)widthForString:(NSString *)value
                   font:(UIFont *)font
                 height:(float)height
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGSize textSize;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                   options:(NSStringDrawingUsesLineFragmentOrigin |
                                            NSStringDrawingTruncatesLastVisibleLine)
                                attributes:attributes
                                   context:nil].size;
    return ceil(textSize.width);
}

/// md5 加密
+ (NSString *)md5:(NSString *)str
{
    if (!str) return nil;
    
    const char *cStr = str.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *md5Str = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str;
    
}

/// 正则表达式
+ (BOOL)checkContent:(NSString *)content regex:(NSString *)regex
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:content];
}

/// 空字符串判断
+ (BOOL)isNullOrEmpty:(NSString *)string
{
    return string == nil
    || [string isEqual: (id)[NSNull null]]
    || [string isKindOfClass:[NSString class]] == NO
    || [@"" isEqualToString:string]
    || [[string stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0U
    || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0U;
}

/// date 格式化为 string
+ (NSString *)stringFromFomate:(NSDate*)date
                       formate:(NSString*)formate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

/// string 格式化为 date
+ (NSDate *)dateFromFomate:(NSString *)datestring
                   formate:(NSString*)formate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:datestring];
    return date;
}

/// 时间戳转时间
+ (NSDate *)dateFromTimestamp:(NSNumber *)timestamp
{
    if ((!timestamp) || (![timestamp isKindOfClass:[NSNumber class]])) {
        return nil;
    }
        
    NSString *timestampString = [NSString stringWithFormat:@"%@", timestamp];
    if (timestampString.length > 11) {
        timestampString = [timestampString substringToIndex:10];
    }
    
    NSTimeInterval time = [timestampString longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    return date;
}

/// 时间戳转指定格式字符串
+ (NSString *)dateStringWithTimestamp:(NSNumber *)timestamp
                              formate:(NSString *)formate
{
    NSDate *docDate = [HLUtils dateFromTimestamp:timestamp];
    NSString *dateString = [HLUtils stringFromFomate:docDate formate:formate];
    return dateString;
}

/// 获取keyWindow，兼容iOS13
+ (UIWindow *)getKeyWindow
{
    if([[[UIApplication sharedApplication] delegate] window]){
        return [[[UIApplication sharedApplication] delegate] window];
    }else {
        if (@available(iOS 13.0,*)) {
            NSArray *arr = [[[UIApplication sharedApplication] connectedScenes] allObjects];
            UIWindowScene *windowScene =  (UIWindowScene *)arr[0];
            UIWindow *mainWindow = [windowScene valueForKeyPath:@"delegate.window"];
            if(mainWindow){
                return mainWindow;
            }else{
                return [UIApplication sharedApplication].windows.lastObject;
            }
        } else {
            return [UIApplication sharedApplication].keyWindow;
        }
    }
}

/// 当前viewController
+ (UIViewController *)topViewController
{
    UIViewController *rootViewController = [HLUtils getKeyWindow].rootViewController;
    return [self topVisibleViewControllerOfViewControlller:rootViewController];
}

+ (UIViewController *)topVisibleViewControllerOfViewControlller:(UIViewController *)vc {
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)vc;
        return [self topVisibleViewControllerOfViewControlller:tabBarController.selectedViewController];
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)vc;
        return [self topVisibleViewControllerOfViewControlller:navigationController.visibleViewController];
        
    } else if (vc.presentedViewController) {
        return [self topVisibleViewControllerOfViewControlller:vc.presentedViewController]; }
    else if (vc.childViewControllers.count > 0){
        return [self topVisibleViewControllerOfViewControlller:vc.childViewControllers.lastObject];
        
    }
    return vc;
}

/// 电话号码中间填充“xxxx”
+ (NSString *)phoneScarf:(NSString *)phone
{
    if ([HLUtils checkContent:phone regex:REGEX_PHONE]) {
        NSString *numberString = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"xxxx"];
        return numberString;
    }
    return phone;
}

/// 根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

/// 拨打电话
+ (void)callPhone:(NSString *)phone
{
    if ([HLUtils isNullOrEmpty:phone]) {
        return;
    }
    
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

/// #开头颜色获取
+ (UIColor *)colorWithHexString:(NSString *)color
{
    if ([HLUtils isNullOrEmpty:color]) {
        return [UIColor blackColor];
    }
    
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
   
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
   
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
   
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
   
    //r
    NSString *rString = [cString substringWithRange:range];
   
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
   
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
   
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
   
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

/// 价格格式化
+ (NSString *)priceFormat:(CGFloat)price
{
    if (price == 0) {
        return @"免费";
    } else {
        return [NSString stringWithFormat:@"¥%.2f", price];
    }
}

/// 电话、身份证格式化 (0.电话 1.身份证)
+ (NSString *)desensitization:(NSString *)number
                         type:(HLDesensitizationType)type
{
    if ([self isNullOrEmpty:number]) {
        return @"";
    }
    
    if (type == 0 && (![HLUtils checkContent:number regex:REGEX_PHONE])) {
        return number;
    }
    
    if (type == 1 && (![HLUtils checkContent:number regex:REGEX_ID_CARD])) {
        return number;
    }
    
    NSInteger toIndex = type==0?3:6;
    NSString *str = number;
    NSString *fStr = [number substringToIndex:toIndex];
    NSString *lStr = [number substringFromIndex:number.length-4];
    if (type == HLDesensitizationTypePhone) {
        str = [NSString stringWithFormat:@"%@****%@", fStr, lStr];
    } else {
        str = [NSString stringWithFormat:@"%@**********%@", fStr, lStr];
    }
    
    return str;
}

/// 64base字符串转图片
+ (UIImage *)stringToImage:(NSString *)str
{
    if ([HLUtils isNullOrEmpty:str]) {
        return nil;
    }
    if ([str containsString:@","]) {
        NSArray *arr = [str componentsSeparatedByString:@","];
        str = arr[1];
    }
    
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *photo = [UIImage imageWithData:imageData ];
    return photo;
}

/// 安全转换URL（解决url中带中文）
+ (NSURL *)safeURL:(NSString *)url
{
    if ([HLUtils isNullOrEmpty:url]) {
        url = @"";
    }
    NSURL *rUrl = [NSURL URLWithString:url];
    if (rUrl) {
        return rUrl;
    }
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    return [NSURL URLWithString:url];
}

/// 根据下标获取对应大写字母
+ (NSString *)letterWithIndex:(NSInteger)index
{
    NSArray *letterArr = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    if (letterArr.count <= index) {
        return @"Z";
    }
    
    return letterArr[index];
}

/// 图片压缩
/// @param  sourceImage 图片
/// @param  maxSize     最大尺寸（KB）
+ (NSData *)resetSizeOfImageData:(UIImage *)sourceImage
                         maxSize:(NSInteger)maxSize
{
    //先判断当前质量是否满足要求，不满足再进行压缩
    __block NSData *finallImageData = UIImageJPEGRepresentation(sourceImage,1.0);
    NSUInteger sizeOrigin   = finallImageData.length;
    NSUInteger sizeOriginKB = sizeOrigin / 1000;
    
    if (sizeOriginKB <= maxSize) {
        return finallImageData;
    }
    
    //获取原图片宽高比
    CGFloat sourceImageAspectRatio = sourceImage.size.width/sourceImage.size.height;
    //先调整分辨率
    CGSize defaultSize = CGSizeMake(1024, 1024/sourceImageAspectRatio);
    UIImage *newImage = [self newSizeImage:defaultSize image:sourceImage];
    
    finallImageData = UIImageJPEGRepresentation(newImage,1.0);
    
    //保存压缩系数
    NSMutableArray *compressionQualityArr = [NSMutableArray array];
    CGFloat avg   = 1.0/250;
    CGFloat value = avg;
    for (int i = 250; i >= 1; i--) {
        value = i*avg;
        [compressionQualityArr addObject:@(value)];
    }
    
    /*
     调整大小
     说明：压缩系数数组compressionQualityArr是从大到小存储。
     */
    //思路：使用二分法搜索
    finallImageData = [self halfFuntion:compressionQualityArr image:newImage sourceData:finallImageData maxSize:maxSize];
    //如果还是未能压缩到指定大小，则进行降分辨率
    while (finallImageData.length == 0) {
        //每次降100分辨率
        CGFloat reduceWidth = 100.0;
        CGFloat reduceHeight = 100.0/sourceImageAspectRatio;
        if (defaultSize.width-reduceWidth <= 0 || defaultSize.height-reduceHeight <= 0) {
            break;
        }
        defaultSize = CGSizeMake(defaultSize.width-reduceWidth, defaultSize.height-reduceHeight);
        UIImage *image = [self newSizeImage:defaultSize
                                      image:[UIImage imageWithData:UIImageJPEGRepresentation(newImage,[[compressionQualityArr lastObject] floatValue])]];
        finallImageData = [self halfFuntion:compressionQualityArr image:image sourceData:UIImageJPEGRepresentation(image,1.0) maxSize:maxSize];
    }
    return finallImageData;
}

/// 剪裁图片
/// @param  sourceImage 图片
/// @param  size        剪裁后尺寸
+ (UIImage *)newSizeImage:(CGSize)size
                    image:(UIImage *)sourceImage
{
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/// 二分法
+ (NSData *)halfFuntion:(NSArray *)arr
                  image:(UIImage *)image
             sourceData:(NSData *)finallImageData
                maxSize:(NSInteger)maxSize
{
    NSData *tempData = [NSData data];
    NSUInteger start = 0;
    NSUInteger end = arr.count - 1;
    NSUInteger index = 0;
    
    NSUInteger difference = NSIntegerMax;
    while(start <= end) {
        index = start + (end - start)/2;
        
        finallImageData = UIImageJPEGRepresentation(image,[arr[index] floatValue]);
        
        NSUInteger sizeOrigin = finallImageData.length;
        NSUInteger sizeOriginKB = sizeOrigin / 1024;
        NSLog(@"当前降到的质量：%ld", (unsigned long)sizeOriginKB);
        NSLog(@"\nstart：%zd\nend：%zd\nindex：%zd\n压缩系数：%lf", start, end, (unsigned long)index, [arr[index] floatValue]);
        
        if (sizeOriginKB > maxSize) {
            start = index + 1;
        } else if (sizeOriginKB < maxSize) {
            if (maxSize-sizeOriginKB < difference) {
                difference = maxSize-sizeOriginKB;
                tempData = finallImageData;
            }
            if (index<=0) {
                break;
            }
            end = index - 1;
        } else {
            break;
        }
    }
    return tempData;
}

/// 秒转时间
/// 例：125 -> 02:05
+ (NSString *)timeStrWithSecond:(NSInteger)time
{
    if (time > 3600) {
        return [NSString stringWithFormat:@"%zd:%02zd:%02zd", time/3600, time%3600/60, time%3600%60];
    } else if (time > 60) {
        return [NSString stringWithFormat:@"%02zd:%02zd", time/60, time%60];
    } else {
        return [NSString stringWithFormat:@"00:%02zd", time];
    }
}

/// 高亮字符串中的部分文字
+ (NSMutableAttributedString *)attStr:(NSString *)text
                          normalColor:(UIColor *)normalColor
                       highlightTexts:(NSArray<NSString *> *)highlightTexts
                      highlightColors:(NSArray<UIColor *> *)highlightColors
                          lineSpacing:(CGFloat)lineSpacing
                                 font:(UIFont *)font
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text
                                                                               attributes:@{NSForegroundColorAttributeName: normalColor}];
    if (lineSpacing > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpacing];
        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    }
    [attStr addAttributes:@{NSFontAttributeName: font ? : [UIFont systemFontOfSize:15]} range:NSMakeRange(0, [text length])];
    
    [highlightTexts enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [text rangeOfString:obj];
        UIColor *color = [UIColor blueColor];
        if (highlightColors.count == highlightTexts.count) {
            color = highlightColors[idx];
        } else if (highlightColors.count == 1) {
            color = highlightColors.firstObject;
        }
        [attStr addAttributes:@{NSForegroundColorAttributeName: color} range:range];
    }];

    return attStr;
}

/// 格式化CGFloat（去除多余的0）
/// 例：0.20 -> 0.2、1.00 -> 1
+ (NSString *)floatToStr:(CGFloat)num
{
    return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", num]].stringValue;
}

/// 获取URL中的参数
+ (NSDictionary *)paramerWithURL:(NSURL *)url
{
    NSMutableDictionary *paramer = [[NSMutableDictionary alloc]init];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [paramer setObject:obj.value forKey:obj.name];

    }];
    return paramer;
}

/// 复制字符串到剪切板
+ (void)copyStrToPasteboard:(NSString *)str
{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:str];
}

/// 随机获取数组中一个元素
+ (id)randomWithArray:(NSArray *)arr
{
    if (!arr || arr.count == 0) {
        return nil;
    }
    NSInteger index = arc4random() % arr.count;
    NSString *object = arr[index];
    return object;
}

/// base64编码
+ (NSString *)base64Encode:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

/// base64解码
+ (NSString *)base64Decode:(NSString *)str
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/// 获取文件／文件夹大小
/// @param fileName 文件／文件夹路径
/// @return 大小
+ (int64_t)fileSizeWithFileName:(NSString *)fileName
{
     //文件管理者
     NSFileManager *mgr = [NSFileManager defaultManager];
     //判断字符串是否为文件/文件夹
     BOOL dir = NO;
     BOOL exists = [mgr fileExistsAtPath:fileName isDirectory:&dir];
    //文件/文件夹不存在
    if (exists == NO) return 0;
    //self是文件夹
    if (dir){
         //遍历文件夹中的所有内容
         NSArray *subpaths = [mgr subpathsAtPath:fileName];
         //计算文件夹大小
        int64_t totalByteSize = 0;
         for (NSString *subpath in subpaths){
                  //拼接全路径
                   NSString *fullSubPath = [fileName stringByAppendingPathComponent:subpath];
               //判断是否为文件
                BOOL dir = NO;
                [mgr fileExistsAtPath:fullSubPath isDirectory:&dir];
                 if (dir == NO){//是文件
                    NSDictionary *attr = [mgr attributesOfItemAtPath:fullSubPath error:nil];
                    totalByteSize += [attr[NSFileSize] integerValue];
                }
            }
         return totalByteSize;
        
    } else{//是文件
        NSDictionary *attr = [mgr attributesOfItemAtPath:fileName error:nil];
        return [attr[NSFileSize] floatValue];
    }
}

/// 通过文件大小获取显示字符串
+ (NSString *)sizeStringWithFileSize:(int64_t)fileSize
{
    CGFloat kb = (CGFloat)fileSize / 1024;
    CGFloat mb = kb / 1024;
    CGFloat gb = mb / 1024;
    if (fileSize < 1024) {// < 1KB
        return [NSString stringWithFormat:@"%@B", @(fileSize)];
    } else if (mb < 1) {// < 1MB
        return [NSString stringWithFormat:@"%.2fK", kb];
    } else if (gb < 1) {// < 1GB
        return [NSString stringWithFormat:@"%.2fM", mb];
    } else { // >= 1GB
        return [NSString stringWithFormat:@"%.2fG", gb];
    }
}

/// 设备剩余空间大小
+ (int64_t)deviceFreeSpace
{
    struct statfs buf;
    int64_t freeSpace = -1;
    if (statfs("/private/var", &buf) >= 0) {
        freeSpace = (int64_t)buf.f_bsize * buf.f_bfree;
    }
    return freeSpace;
}

/// 设备空间总大小
+ (int64_t)deviceTotalSpace
{
    struct statfs buf;
    int64_t totalSpace = -1;
    if (statfs("/private/var", &buf) >= 0) {
        totalSpace = (int64_t)buf.f_bsize * buf.f_blocks;
    }
    return totalSpace;
}

/// 清除字符中串空格
+ (NSString *)clearStringSpace:(NSString *)str
{
    NSString *newStr = [[str stringByReplacingOccurrencesOfString:@"  " withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newStr;
}

@end
