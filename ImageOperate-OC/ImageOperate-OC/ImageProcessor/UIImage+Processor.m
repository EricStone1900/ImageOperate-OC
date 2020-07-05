//
//  UIImage+Processor.m
//  ImageOperate-OC
//
//  Created by song on 2020/7/1.
//  Copyright © 2020 ericstone. All rights reserved.
//
#import "UIImage+Processor.h"
#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )

@implementation UIImage (Processor)

- (UIImage *)processUsingPixels:(UIImage *)backImage frontImage:(UIImage *)frontImage; {
    // 1. Get the raw pixels of the image
    UInt32 * backPixels;

    CGImageRef backCGImage = [backImage CGImage];
    NSUInteger backWidth = CGImageGetWidth(backCGImage);
    NSUInteger backHeight = CGImageGetHeight(backCGImage);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    NSUInteger bytesPerPixel = 4;
    NSUInteger bitsPerComponent = 8;

    NSUInteger backBytesPerRow = bytesPerPixel * backWidth;

    backPixels = (UInt32 *)calloc(backHeight * backWidth, sizeof(UInt32));

    CGContextRef context = CGBitmapContextCreate(backPixels, backWidth, backHeight,
                                                 bitsPerComponent, backBytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    CGContextDrawImage(context, CGRectMake(0, 0, backWidth, backHeight), backCGImage);

    // 2. Blend the pattern onto the image
//    UIImage *oofrontImage = [UIImage imageNamed:@"Razewarelogo_1024"];
    CGImageRef frontCGImage = [frontImage CGImage];

    // 2.1 Calculate the size & position of the pattern
    CGFloat frontImageAspectRatio = frontImage.size.width / frontImage.size.height;
    NSInteger targetFrontWidth = backWidth * 0.25;
    CGSize frontSize = CGSizeMake(targetFrontWidth, targetFrontWidth / frontImageAspectRatio);
//    CGPoint frontOrigin = CGPointMake(backWidth * 0.5, backHeight * 0.2);
        CGPoint frontOrigin = CGPointMake(0, 0);

    // 2.2 Scale & Get pixels of the pattern
    NSUInteger frontBytesPerRow = bytesPerPixel * frontSize.width;

    UInt32 *frontPixels = (UInt32 *)calloc(frontSize.width * frontSize.height, sizeof(UInt32));

    CGContextRef frontContext = CGBitmapContextCreate(frontPixels, frontSize.width, frontSize.height,
                                                      bitsPerComponent, frontBytesPerRow, colorSpace,
                                                      kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    CGContextDrawImage(frontContext, CGRectMake(0, 0, frontSize.width, frontSize.height),frontCGImage);

    // 2.3 Blend each pixel
    NSUInteger offsetPixelCountForInput = frontOrigin.y * backWidth + frontOrigin.x;
    for (NSUInteger j = 0; j < frontSize.height; j++) {
        for (NSUInteger i = 0; i < frontSize.width; i++) {
            UInt32 *backPixel = backPixels + j * backWidth + i + offsetPixelCountForInput;
            UInt32 backColor = *backPixel;

            UInt32 * frontPixel = frontPixels + j * (int)frontSize.width + i;
            UInt32 frontColor = *frontPixel;

            // Blend the pattern with 50% alpha
//            CGFloat frontAlpha = 0.5f * (A(frontColor) / 255.0);
            CGFloat frontAlpha = 1.0f * (A(frontColor) / 255.0);
            UInt32 newR = R(backColor) * (1 - frontAlpha) + R(frontColor) * frontAlpha;
            UInt32 newG = G(backColor) * (1 - frontAlpha) + G(frontColor) * frontAlpha;
            UInt32 newB = B(backColor) * (1 - frontAlpha) + B(frontColor) * frontAlpha;

            //Clamp, not really useful here :p
            newR = MAX(0,MIN(255, newR));
            newG = MAX(0,MIN(255, newG));
            newB = MAX(0,MIN(255, newB));

            *backPixel = RGBAMake(newR, newG, newB, A(backColor));
        }
    }

    // 3. Convert the image to Black & White
    for (NSUInteger j = 0; j < backHeight; j++) {
        for (NSUInteger i = 0; i < backWidth; i++) {
            UInt32 * currentPixel = backPixels + (j * backWidth) + i;
            UInt32 color = *currentPixel;

            // Average of RGB = greyscale
            UInt32 averageColor = (R(color) + G(color) + B(color)) / 3.0;

            *currentPixel = RGBAMake(averageColor, averageColor, averageColor, A(color));
        }
    }

    // 4. Create a new UIImage
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage * processedImage = [UIImage imageWithCGImage:newCGImage];

    // 5. Cleanup!
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGContextRelease(frontContext);
    free(backPixels);
    free(frontPixels);

    return processedImage;
}

- (UIImage *)processUsingCoreGraphics:(UIImage *)backImage frontImage:(UIImage *)frontImage; {
  CGRect imageRect = {CGPointZero,backImage.size};
  NSInteger backWidth = CGRectGetWidth(imageRect);
  NSInteger backHeight = CGRectGetHeight(imageRect);
  
  // 1. Blend the pattern onto our image
  CGFloat frontImageAspectRatio = frontImage.size.width / frontImage.size.height;
  
  NSInteger targetFrontWidth = backWidth * 0.25;
  CGSize frontSize = CGSizeMake(targetFrontWidth, targetFrontWidth / frontImageAspectRatio);
//  CGPoint frontOrigin = CGPointMake(backWidth * 0.5, backHeight * 0.2);
  CGPoint frontOrigin = CGPointMake(0, 0);
  
  CGRect frontRect = {frontOrigin, frontSize};
  
  UIGraphicsBeginImageContext(backImage.size);
  CGContextRef context = UIGraphicsGetCurrentContext();

  // flip drawing context
  CGAffineTransform flip = CGAffineTransformMakeScale(1.0, -1.0);
  CGAffineTransform flipThenShift = CGAffineTransformTranslate(flip,0,-backHeight);
  CGContextConcatCTM(context, flipThenShift);
  
  // 1.1 Draw our image into a new CGContext
  CGContextDrawImage(context, imageRect, [backImage CGImage]);
  
  // 1.2 Set Alpha to 0.5 and draw our pattern on
  CGContextSetBlendMode(context, kCGBlendModeSourceAtop);
  CGContextSetAlpha(context,0.5);
  CGRect transformedpatternRect = CGRectApplyAffineTransform(frontRect, flipThenShift);
  CGContextDrawImage(context, transformedpatternRect, [frontImage CGImage]);
  
  UIImage * imageWithFront = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
    
  // 2. Convert our image to Black and White
  
  // 2.1 Create a new context with a gray color space
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
  context = CGBitmapContextCreate(nil, backWidth, backHeight,
                           8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
  
  // 2.2 Draw our image into the new context
  CGContextDrawImage(context, imageRect, [imageWithFront CGImage]);
  
  // 2.3 Get our new B&W Image
  CGImageRef imageRef = CGBitmapContextCreateImage(context);
  UIImage * finalImage = [UIImage imageWithCGImage:imageRef];
  
  // Cleanup
  CGColorSpaceRelease(colorSpace);
  CGContextRelease(context);
  CFRelease(imageRef);
  
  return finalImage;
}

- (UIImage *)processUsingCoreImage:(UIImage *)backImage frontImage:(UIImage *)frontImage {
  CIImage * backCIImage = [[CIImage alloc] initWithImage:backImage];
  
  // 1. Create a grayscale filter
  CIFilter * grayFilter = [CIFilter filterWithName:@"CIColorControls"];
  [grayFilter setValue:@(0) forKeyPath:@"inputSaturation"];
  
  // 2. Create our pattern filter
  
  // Cheat: create a larger pattern image
  UIImage * patternFrontImage = [self createPaddedPatternImageWithSize:backImage.size pattern:frontImage];
  CIImage * frontCIImage = [[CIImage alloc] initWithImage:patternFrontImage];

  CIFilter * alphaFilter = [CIFilter filterWithName:@"CIColorMatrix"];
//  CIVector * alphaVector = [CIVector vectorWithX:0 Y:0 Z:0.5 W:0];
      CIVector * alphaVector = [CIVector vectorWithX:0 Y:0 Z:1.0 W:0];
  [alphaFilter setValue:alphaVector forKeyPath:@"inputAVector"];
  
  CIFilter * blendFilter = [CIFilter filterWithName:@"CISourceAtopCompositing"];
  
  // 3. Apply our filters
  [alphaFilter setValue:frontCIImage forKeyPath:@"inputImage"];
  frontCIImage = [alphaFilter outputImage];

  [blendFilter setValue:frontCIImage forKeyPath:@"inputImage"];
  [blendFilter setValue:backCIImage forKeyPath:@"inputBackgroundImage"];
  CIImage * blendOutput = [blendFilter outputImage];
  
  [grayFilter setValue:blendOutput forKeyPath:@"inputImage"];
  CIImage * outputCIImage = [grayFilter outputImage];
  
  // 4. Render our output image
  CIContext * context = [CIContext contextWithOptions:nil];
  CGImageRef outputCGImage = [context createCGImage:outputCIImage fromRect:[outputCIImage extent]];
  UIImage * outputImage = [UIImage imageWithCGImage:outputCGImage];
  CGImageRelease(outputCGImage);
  
  return outputImage;
}

- (UIImage *)createPaddedPatternImageWithSize:(CGSize)containerSize pattern:(UIImage *)pattern{
//  UIImage * patternImage = [UIImage imageNamed:@"pattern.png"];
  CGFloat patternImageAspectRatio = pattern.size.width / pattern.size.height;
  
  NSInteger targetPatternWidth = containerSize.width * 0.25;
  CGSize patternSize = CGSizeMake(targetPatternWidth, targetPatternWidth / patternImageAspectRatio);
//  CGPoint patternOrigin = CGPointMake(containerSize.width * 0.5, containerSize.height * 0.2);
  CGPoint patternOrigin = CGPointMake(0, 0);
  
  CGRect patternRect = {patternOrigin, patternSize};
  
  UIGraphicsBeginImageContext(containerSize);
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGRect containerRect = {CGPointZero, containerSize};
  CGContextClearRect(context, containerRect);

  CGAffineTransform flip = CGAffineTransformMakeScale(1.0, -1.0);
  CGAffineTransform flipThenShift = CGAffineTransformTranslate(flip,0,-containerSize.height);
  CGContextConcatCTM(context, flipThenShift);
  CGRect transformedPatternRect = CGRectApplyAffineTransform(patternRect, flipThenShift);
  CGContextDrawImage(context, transformedPatternRect, [pattern CGImage]);
  
  UIImage * paddedpattern = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return paddedpattern;
}


#undef RGBAMake
#undef R
#undef G
#undef B
#undef A
#undef Mask8
#pragma mark Helpers
@end
