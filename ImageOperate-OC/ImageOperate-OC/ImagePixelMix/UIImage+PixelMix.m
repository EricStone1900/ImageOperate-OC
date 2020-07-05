//
//  UIImage+PixelMix.m
//  ImageOperate-OC
//
//  Created by song on 2020/7/1.
//  Copyright © 2020 ericstone. All rights reserved.
//

#import "UIImage+PixelMix.h"

@implementation UIImage (PixelMix)
- (UIImage *)imageToGray:(NSInteger)type {
    CGImageRef imageRef = self.CGImage;
     //1、获取图片宽高
     NSUInteger width = CGImageGetWidth(imageRef);
     NSUInteger height = CGImageGetHeight(imageRef);
     //2、创建颜色空间
     CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
     //3、根据像素点个数创建一个所需要的空间
     UInt32 *imagePiexl = (UInt32 *)calloc(width*height, sizeof(UInt32));
     CGContextRef contextRef = CGBitmapContextCreate(imagePiexl, width, height, 8, 4*width, colorSpaceRef, kCGImageAlphaNoneSkipLast);
    
     //4、根据图片数据源绘制上下文
     CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), self.CGImage);
     //5、将彩色图片像素点重新设置颜色
     //取平均值 R=G=B=(R+G+B)/3
     for (int y=0; y<height; y++) {
         for (int x=0; x<width; x++) {
             //计算平均值重新存储像素点-直接操作像素点
             uint8_t *rgbPiexl = (uint8_t *)&imagePiexl[y*width+x];
             //rgbPiexl[0],rgbPiexl[1],rgbPiexl[2];
             //(rgbPiexl[0]+rgbPiexl[1]+rgbPiexl[2])/3;
             uint32_t gray = rgbPiexl[0]*0.3+rgbPiexl[1]*0.59+rgbPiexl[2]*0.11;
             if (type == 0) {
                 gray = rgbPiexl[1];
             }else if(type == 1) {
                 gray = (rgbPiexl[0]+rgbPiexl[1]+rgbPiexl[2])/3;
             }else if (type == 2) {
                 gray = rgbPiexl[0]*0.3+rgbPiexl[1]*0.59+rgbPiexl[2]*0.11;
             }
             rgbPiexl[0] = gray;
             rgbPiexl[1] = gray;
             rgbPiexl[2] = gray;
         }
     }
     //根据上下文绘制
     CGImageRef finalRef = CGBitmapContextCreateImage(contextRef);
     //释放用过的内存
     CGContextRelease(contextRef);
     CGColorSpaceRelease(colorSpaceRef);
     free(imagePiexl);
     return [UIImage imageWithCGImage:finalRef scale:self.scale orientation:UIImageOrientationUp];
    
}

- (UIImage *)imageToRGB:(CGFloat)rk g:(CGFloat)gk b:(CGFloat)bk {
    CGImageRef imageRef = self.CGImage;
    //1、获取图片宽高
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    //2、创建颜色空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //3、根据像素点个数创建一个所需要的空间
    UInt32 *imagePiexl = (UInt32 *)calloc(width*height, sizeof(UInt32));
    CGContextRef contextRef = CGBitmapContextCreate(imagePiexl, width, height, 8, 4*width, colorSpaceRef, kCGImageAlphaNoneSkipLast);
    //4、根据图片数据源绘制上下文
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);
    //5、将彩色图片像素点重新设置颜色
    //取平均值 R=G=B=(R+G+B)/3
    for (int y=0; y<height; y++) {
        for (int x=0; x<width; x++) {
            //操作像素点
            uint8_t *rgbPiexl = (uint8_t *)&imagePiexl[y*width+x];
            //该色值下不做处理
            if (rgbPiexl[0]>245&&rgbPiexl[1]>245&&rgbPiexl[2]>245) {
                NSLog(@"该色值下不做处理");
            }else{
                rgbPiexl[0] = rgbPiexl[0]*rk;
                rgbPiexl[1] = rgbPiexl[1]*gk;
                rgbPiexl[2] = rgbPiexl[2]*bk;
            }
        }
    }
    //根据上下文绘制
    CGImageRef finalRef = CGBitmapContextCreateImage(contextRef);
    //释放用过的内存
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpaceRef);
    free(imagePiexl);
    return [UIImage imageWithCGImage:finalRef scale:self.scale orientation:UIImageOrientationUp];
}

- (UIImage *)imageToMosaic:(NSInteger)size; {
    CGImageRef imageRef = self.CGImage;
    //1、获取图片宽高
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    //2、创建颜色空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //3、根据像素点个数创建一个所需要的空间
    UInt32 *imagePiexl = (UInt32 *)calloc(width*height, sizeof(UInt32));
    CGContextRef contextRef = CGBitmapContextCreate(imagePiexl, width, height, 8, 4*width, colorSpaceRef, kCGImageAlphaNoneSkipLast);
    //4、根据图片数据源绘制上下文
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);
    //5、获取像素数组
    UInt8 *bitmapPixels = CGBitmapContextGetData(contextRef);
    UInt8 *pixels[4] = {0};
    NSUInteger currentPixels = 0;//当前的像素点
    NSUInteger preCurrentPiexls = 0;//
    NSUInteger mosaicSize = size;//马赛克尺寸
    if (size == 0) return self;
    for (NSUInteger i = 0;  i < height - 1; i++) {
        for (NSUInteger j = 0 ; j < width - 1; j++) {
            currentPixels = i * width + j;
            if (i % mosaicSize == 0) {
                if (j % mosaicSize == 0) {
                    memcpy(pixels, bitmapPixels + 4 * currentPixels, 4);
                }else{
                    memcpy(bitmapPixels + 4 * currentPixels, pixels, 4);
                }
            }else{
                preCurrentPiexls = (i - 1) * width + j;
                memcpy(bitmapPixels + 4 * currentPixels, bitmapPixels + 4 * preCurrentPiexls, 4);
            }
        }
    }
    //根据上下文创建图片数据源
    CGImageRef finalRef = CGBitmapContextCreateImage(contextRef);
    //释放用过的内存
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpaceRef);
    free(imagePiexl);
    return [UIImage imageWithCGImage:finalRef scale:self.scale orientation:UIImageOrientationUp];
}


@end
