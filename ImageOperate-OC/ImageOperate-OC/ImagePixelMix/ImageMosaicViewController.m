//
//  ImageMosaicViewController.m
//  ImageOperate-OC
//
//  Created by song on 2020/7/1.
//  Copyright © 2020 ericstone. All rights reserved.
//

#import "ImageMosaicViewController.h"
#import "UIImage+PixelMix.h"
@interface ImageMosaicViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageOriView;

@end

@implementation ImageMosaicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)lengthSlider:(UISlider *)sender {
    NSLog(@"sender value: %f",sender.value);
    NSInteger size = ceilf(sender.value);
    NSLog(@"size value: %ld",(long)size);
    UIImage *new = [_imageOriView.image imageToMosaic:size];
    _imageOriView.image = new;
}

@end
