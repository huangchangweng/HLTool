//
//  HLLabel.m
//  HLUIKit
//
//  Created by JJB_iOS on 2022/6/2.
//

#import "HLLabel.h"

@implementation HLLabel

#pragma mark - Setter

- (void)setMasksToBounds:(BOOL)masksToBounds {
    if (_masksToBounds != masksToBounds) {
        _masksToBounds = masksToBounds;
        self.layer.masksToBounds = _masksToBounds;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius != cornerRadius) {
        _cornerRadius = cornerRadius;
        self.layer.cornerRadius = _cornerRadius;
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    if (_borderWidth != borderWidth) {
        _borderWidth = borderWidth;
        self.layer.borderWidth = _borderWidth;
    }
}

- (void)setBorderColor:(UIColor *)borderColor {
    if (_borderColor != borderColor) {
        _borderColor = borderColor;
        self.layer.borderColor = _borderColor.CGColor;
    }
}

@end
