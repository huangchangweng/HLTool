//
//  HLUtils.h
//  HLUtils
//
//  Created by hcw on 2022/5/23.
//

#define REGEX_USER_PASSWORD @"^(?![0-9]+$)(?![a-z]+$)(?![A-Z]+$)(?!([^(0-9a-zA-Z)])+$).{8,}$" // 密码正则表达式
#define REGEX_PHONE @"[1]([3-9])[0-9]{9}$" // 匹配类容是否是电话号码
#define REGEX_CAR_NUM @"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$" // 车牌号
#define REGEX_ID_CARD @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)" // 身份证

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HLDesensitizationType) {
    HLDesensitizationTypePhone,    ///< 电话号码
    HLDesensitizationTypeIDCard,   ///< 身份证
};

@interface HLUtils : NSObject

/// 获取app版本
+ (NSString *)appVersion;

/// 随机颜色
+ (UIColor *)randomColor;

/// 获取字符串高度
+ (float)heightForString:(NSString *)value
                    font:(UIFont *)font
                   width:(float)width;

/// 获取字符串高度
+ (float)heightForString:(NSString *)value
                    font:(UIFont *)font
                   width:(float)width
             lineSpacing:(CGFloat)lineSpacing;

/// 获取字符串宽度
+ (float)widthForString:(NSString *)value
                   font:(UIFont *)font
                 height:(float)height;

/// MD5加密
+ (NSString *)md5:(NSString *)str;

/// 正则表达式
+ (BOOL)checkContent:(NSString *)content
               regex:(NSString *)regex;

/// 空字符串判断
+ (BOOL)isNullOrEmpty:(NSString *)string;

/// date 格式化为 string
+ (NSString *)stringFromFomate:(NSDate *)date
                       formate:(NSString *)formate;

/// string 格式化为 date
+ (NSDate *)dateFromFomate:(NSString *)datestring
                   formate:(NSString *)formate;

/// 时间戳转时间
+ (NSDate *)dateFromTimestamp:(NSNumber *)timestamp;

/// 时间戳转指定格式字符串
+ (NSString *)dateStringWithTimestamp:(NSNumber *)timestamp
                              formate:(NSString *)formate;

/// 获取keyWindow，兼容iOS13
+ (UIWindow *)getKeyWindow;

/// 当前viewController
+ (UIViewController *)topViewController;

/// 电话号码中间填充“xxxx”
+ (NSString *)phoneScarf:(NSString *)phone;

/// 根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGSize)size;

/// 拨打电话
+ (void)callPhone:(NSString *)phone;

/// #开头颜色获取
+ (UIColor *)colorWithHexString:(NSString *)color;

/// 价格格式化
+ (NSString *)priceFormat:(CGFloat)price;

/// 电话、身份证格式化 (0.电话 1.身份证)
+ (NSString *)desensitization:(NSString *)number
                         type:(HLDesensitizationType)type;

/// 64base字符串转图片
+ (UIImage *)stringToImage:(NSString *)str;

/// 安全转换URL（解决url中带中文）
+ (NSURL *)safeURL:(NSString *)url;

/// 根据下标获取对应大写字母
+ (NSString *)letterWithIndex:(NSInteger)index;

/// 图片压缩
/// @param  sourceImage 图片
/// @param  maxSize     最大尺寸（KB）
+ (NSData *)resetSizeOfImageData:(UIImage *)sourceImage
                         maxSize:(NSInteger)maxSize;

/// 剪裁图片
/// @param  sourceImage 图片
/// @param  size        剪裁后尺寸
+ (UIImage *)newSizeImage:(CGSize)size
                    image:(UIImage *)sourceImage;

/// 秒转时间
/// 例：125 -> 02:05
+ (NSString *)timeStrWithSecond:(NSInteger)time;

/// 高亮字符串中的部分文字
+ (NSMutableAttributedString *)attStr:(NSString *)text
                          normalColor:(UIColor *)normalColor
                       highlightTexts:(NSArray<NSString *> *)highlightTexts
                      highlightColors:(NSArray<UIColor *> *)highlightColors
                          lineSpacing:(CGFloat)lineSpacing
                                 font:(UIFont *)font;

/// 格式化CGFloat（去除多余的0）
/// 例：0.20 -> 0.2、1.00 -> 1
+ (NSString *)floatToStr:(CGFloat)num;

/// 获取URL中的参数
+ (NSDictionary *)paramerWithURL:(NSURL *)url;

/// 复制字符串到剪切板
+ (void)copyStrToPasteboard:(NSString *)str;

/// 随机获取数组中一个元素
+ (id)randomWithArray:(NSArray *)arr;

/// base64编码
+ (NSString *)base64Encode:(NSString *)str;

/// base64解码
+ (NSString *)base64Decode:(NSString *)str;

/// 获取文件／文件夹大小
/// @param fileName 文件／文件夹路径
/// @return 大小
+ (int64_t)fileSizeWithFileName:(NSString *)fileName;

/// 通过文件大小获取显示字符串
+ (NSString *)sizeStringWithFileSize:(int64_t)fileSize;

/// 设备剩余空间大小
+ (int64_t)deviceFreeSpace;

/// 设备空间总大小
+ (int64_t)deviceTotalSpace;

/// 清除字符中串空格
+ (NSString *)clearStringSpace:(NSString *)str;

@end
