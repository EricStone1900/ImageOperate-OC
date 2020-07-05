//
//  UIImage+PixelMix.h
//  ImageOperate-OC
//
//  Created by song on 2020/7/1.
//  Copyright © 2020 ericstone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (PixelMix)

//1、浮点算法：R = G = B = 0.3*R + 0.59*G + 0.11*B
//2、平均值法：R = G = B = (R+G+B)/3
//3、任取一个分量色：R = G = B = R或G或B

- (UIImage *)imageToGray:(NSInteger)type;

//按比例修改色值，可以修改一下直接修改指定像素位或区域的色值
- (UIImage *)imageToRGB:(CGFloat)rk g:(CGFloat)gk b:(CGFloat)bk;



//设置马赛克
//马赛克就是让图片看上去模糊不清。将特定区域的像素点设置为同一种颜色，整体就会变得模糊，区域块越大越模糊，越小越接近于原始像素。
//同样使用强制解压缩操作，操作像素点，马赛克部分实际操作
//1、设置区域大小；
//2、在该区域获取一个像素点（第一个）作为整个区域的取色；
//3、将取色设置到区域中；
//4、取下一个区域同上去色设置区域

- (UIImage *)imageToMosaic:(NSInteger)size;
@end

NS_ASSUME_NONNULL_END
