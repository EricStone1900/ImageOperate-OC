//
//  UIImage+Compress.m
//  ImageOperate-OC
//
//  Created by song on 2020/7/1.
//  Copyright © 2020 ericstone. All rights reserved.
//

#import "UIImage+Compress.h"
@implementation UIImage (Compress)

//按照质量压缩
- (UIImage *)compressWithQuality:(CGFloat)rate {
    NSData *data = UIImageJPEGRepresentation(self, rate);
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}

//按照尺寸压缩
- (UIImage *)compressWithSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

- (UIImage *)compressWithCycleQulity:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxLength) return self;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}

- (UIImage *)compressWithCycleSize:(NSInteger)maxLength {
    UIImage *resultImage = self;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        // Use image to draw (drawInRect:), image is larger but more compression time
        // Use result image to draw, image is smaller but less compression time
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    return resultImage;
}


- (UIImage *)compressWithQulitySize:(NSInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxLength) return self;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}

//图片处理-强制解压缩操作-把元数据绘制到当前的上下文-压缩图片
- (UIImage *)compressWithBitmap:(CGFloat)scale {
    //获取当前图片数据源
    CGImageRef imageRef = self.CGImage;
    //设置大小改变压缩图片
    NSUInteger width = CGImageGetWidth(imageRef)*scale;
    NSUInteger height = CGImageGetHeight(imageRef)*scale;
    //创建颜色空间
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    /*
     创建绘制当前图片的上下文
     CGBitmapContextCreate(void * __nullable data,
     size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow,
     CGColorSpaceRef cg_nullable space, uint32_t bitmapInfo)
     data：所需要的内存空间 传nil会自动分配
     width/height：当前画布的大小
     bitsPerComponent：每个颜色分量的大小 RGBA 每一个分量占1个字节
     bytesPerRow：每一行使用的字节数 4*width
     bitmapInfo：RGBA绘制的顺序
     */
    CGContextRef contextRef =
    CGBitmapContextCreate(nil,
                          width,
                          height,
                          8,
                          4*width,
                          colorSpace,
                          kCGImageAlphaNoneSkipLast);
    //根据数据源在上下文（画板）绘制图片
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);
    
    imageRef = CGBitmapContextCreateImage(contextRef);
    CGContextRelease(contextRef);
    return [UIImage imageWithCGImage:imageRef scale:self.scale orientation:UIImageOrientationUp];
}


@end
