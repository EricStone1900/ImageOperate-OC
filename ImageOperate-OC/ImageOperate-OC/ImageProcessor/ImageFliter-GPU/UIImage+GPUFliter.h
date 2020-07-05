//
//  UIImage+GPUFliter.h
//  ImageOperate-OC
//
//  Created by song on 2020/7/1.
//  Copyright © 2020 ericstone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (GPUFliter)

- (UIImage *)processUsingGPUImage:(UIImage *)backImage frontImage:(UIImage *)frontImage;

@end

NS_ASSUME_NONNULL_END
