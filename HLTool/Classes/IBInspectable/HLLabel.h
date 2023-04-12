//
//  HLLabel.h
//  HLUIKit
//
//  Created by JJB_iOS on 2022/6/2.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface HLLabel : UILabel
@property (nonatomic, assign) IBInspectable BOOL masksToBounds;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;   ///< 圆角半径.
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;    ///< 边框宽度.
@property (nonatomic, strong) IBInspectable UIColor *borderColor;   ///< 边框颜色.
@end
