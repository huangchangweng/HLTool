//
//  HLView.h
//  HLUIKit
//
//  Created by JJB_iOS on 2022/6/2.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface HLView : UIView
@property (nonatomic, assign) IBInspectable BOOL masksToBounds;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;   ///< 圆角半径.
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;    ///< 边框宽度.
@property (nonatomic, strong) IBInspectable UIColor *borderColor;   ///< 边框颜色.

@property (nonatomic, strong) IBInspectable UIColor *shadowColor;
@property (nonatomic, assign) IBInspectable CGSize shadowOffset;
@property (nonatomic, assign) IBInspectable CGFloat shadowRadius;
@property (nonatomic, assign) IBInspectable CGFloat shadowOpacity;
@end
