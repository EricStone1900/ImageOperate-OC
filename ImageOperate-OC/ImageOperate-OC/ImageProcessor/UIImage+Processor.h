//
//  UIImage+Processor.h
//  ImageOperate-OC
//
//  Created by song on 2020/7/1.
//  Copyright © 2020 ericstone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Processor)

//Pixels
- (UIImage *)processUsingPixels:(UIImage *)backImage frontImage:(UIImage *)frontImage;

//CoreGraphics
- (UIImage *)processUsingCoreGraphics:(UIImage *)backImage frontImage:(UIImage *)frontImage;

//CoreImage //滤镜功能 速度较慢
- (UIImage *)processUsingCoreImage:(UIImage *)backImage frontImage:(UIImage *)frontImage;

// 生成自定义的pattern图案
- (UIImage *)createPaddedPatternImageWithSize:(CGSize)containerSize pattern:(UIImage *)pattern;

@end

NS_ASSUME_NONNULL_END
