//
//  UIImage+GPUFliter.m
//  ImageOperate-OC
//
//  Created by song on 2020/7/1.
//  Copyright © 2020 ericstone. All rights reserved.
//

#import "UIImage+GPUFliter.h"
#import <GPUImage/GPUImage.h>
#import "UIImage+Processor.h"

@implementation UIImage (GPUFliter)

- (UIImage *)processUsingGPUImage:(UIImage *)backImage frontImage:(UIImage *)frontImage {
    
    // 1. Create our GPUImagePictures
    GPUImagePicture * backGPUImage = [[GPUImagePicture alloc] initWithImage:backImage];
    
    UIImage *fliterImage = [self createPaddedPatternImageWithSize:backImage.size pattern:frontImage];
    GPUImagePicture * frontGPUImage = [[GPUImagePicture alloc] initWithImage:fliterImage];
    
    // 2. Setup our filter chain
    GPUImageAlphaBlendFilter * alphaBlendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    alphaBlendFilter.mix = 0.5;
    
    [backGPUImage addTarget:alphaBlendFilter atTextureLocation:0];
    [frontGPUImage addTarget:alphaBlendFilter atTextureLocation:1];
    
    GPUImageGrayscaleFilter * grayscaleFilter = [[GPUImageGrayscaleFilter alloc] init];
    
    [alphaBlendFilter addTarget:grayscaleFilter];
    
    // 3. Process & grab output image
    [backGPUImage processImage];
    [frontGPUImage processImage];
    [grayscaleFilter useNextFrameForImageCapture];
    
    UIImage * output = [grayscaleFilter imageFromCurrentFramebuffer];
    
    return output;
}

@end
