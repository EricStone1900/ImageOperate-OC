//
//  UIImage+Compress.h
//  ImageOperate-OC
//
//  Created by song on 2020/7/1.
//  Copyright © 2020 ericstone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Compress)
//1、简单压缩 分别按质量或尺寸直接压缩
//按照质量压缩
- (UIImage *)compressWithQuality:(CGFloat)rate;

//按照尺寸压缩
- (UIImage *)compressWithSize:(CGSize)size;

//2、更加精细的压缩：例如要求图片小于100K

//循环压缩图片质量直到图片稍小于指定大小。
//⚠️：注意：当图片质量低于一定程度时，继续压缩没有效果。默认压缩最多6次,通过二分法来优化循环次数多
//压缩图片质量的优点在于，尽可能保留图片清晰度，图片不会明显模糊；缺点在于，不能保证图片压缩后小于指定大小。
- (UIImage *)compressWithCycleQulity:(NSInteger)maxLength;

//循环逐渐减小图片尺寸，直到图片稍小于指定大小
//同样的问题是循环次数多，效率低，耗时长。可以用二分法来提高效率，具体代码省略。这里介绍另外一种方法，比二分法更好，压缩次数少，而且可以使图片压缩后刚好小于指定大小(不只是 < maxLength， > maxLength * 0.9)。

- (UIImage *)compressWithCycleSize:(NSInteger)maxLength;

//3、两种图片压缩方法结合 尽量兼顾质量和大小。以确保大小合适为标准
//如果要保证图片清晰度，建议选择压缩图片质量。如果要使图片一定小于指定大小，压缩图片尺寸可以满足。对于后一种需求，还可以先压缩图片质量，如果已经小于指定大小，就可得到清晰的图片，否则再压缩图片尺寸。
- (UIImage *)compressWithQulitySize:(NSInteger)maxLength;

//4、强制解压缩 按大小比例压缩sacle (0,1] - 也可放大,清晰度会受到影响；适用于需要快速显示图片的地方,例如tableCell，先把图片进行bitmap解码操作加入缓存
// 通过CGBitmapContextCreate 重绘图片，这种压缩的图片等于手动进行了一次解码，可以加快图片的展示
- (UIImage *)compressWithBitmap:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
