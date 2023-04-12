//
//  HLButton.m
//  HLUIKit
//
//  Created by JJB_iOS on 2022/6/2.
//

#import "HLButton.h"

@implementation HLButton

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

- (void)setShadowColor:(UIColor *)shadowColor {
    if (_shadowColor != shadowColor) {
        _shadowColor = shadowColor;
        self.layer.shadowColor = _shadowColor.CGColor;
    }
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    if (!CGSizeEqualToSize(_shadowOffset, shadowOffset)) {
        _shadowOffset = shadowOffset;
        self.layer.shadowOffset = _shadowOffset;
    }
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    if (_shadowRadius != shadowRadius) {
        _shadowRadius = shadowRadius;
        self.layer.shadowRadius = _shadowRadius;
    }
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    if (_shadowOpacity != shadowOpacity) {
        _shadowOpacity = shadowOpacity;
        self.layer.shadowOpacity = _shadowOpacity;
    }
}

@end
