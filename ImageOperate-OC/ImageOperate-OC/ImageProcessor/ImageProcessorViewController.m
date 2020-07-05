//
//  ImageProcessorViewController.m
//  ImageOperate-OC
//
//  Created by song on 2020/7/1.
//  Copyright © 2020 ericstone. All rights reserved.
//

#import "ImageProcessorViewController.h"
#import "UIImage+Processor.h"
#import "UIImage+GPUFliter.h"

@interface ImageProcessorViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageMerge;
@end

@implementation ImageProcessorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imageView1.image = [UIImage imageNamed:@"flower.jpg"];
    _imageView2.image = [UIImage imageNamed:@"Icon-2.png"];
}

- (IBAction)merge1:(UIButton *)sender {
    UIImage *new = [[UIImage alloc] init];
    UIImage *newblend = [new processUsingPixels:_imageView1.image frontImage:_imageView2.image];
//        UIImage *newblend = [new processUsingPixels:_imageView1.image];
    _imageMerge.image = newblend;
}

- (IBAction)merage2:(UIButton *)sender {
    UIImage *new = [[UIImage alloc] init];
    UIImage *newblend = [new processUsingCoreGraphics:_imageView1.image frontImage:_imageView2.image];
    _imageMerge.image = newblend;
}

- (IBAction)merge3:(UIButton *)sender {
    UIImage *new = [[UIImage alloc] init];
    UIImage *newblend = [new processUsingGPUImage:_imageView1.image frontImage:_imageView2.image];
    _imageMerge.image = newblend;
}

- (IBAction)merge4:(UIButton *)sender {
    UIImage *new = [[UIImage alloc] init];
//    UIImage *newblend = [new createPaddedPatternImageWithSize:CGSizeMake(200, 200) pattern:_imageView1.image];
//    _imageMerge.image = newblend;
//    _imageMerge.backgroundColor = [UIColor yellowColor];
    UIImage *newblend = [new processUsingCoreImage:_imageView1.image frontImage:_imageView2.image];
    _imageMerge.image = newblend;
}

@end
