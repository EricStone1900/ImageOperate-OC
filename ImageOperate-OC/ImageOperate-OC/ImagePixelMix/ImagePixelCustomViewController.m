//
//  ImagePixelCustomViewController.m
//  ImageOperate-OC
//
//  Created by song on 2020/7/1.
//  Copyright © 2020 ericstone. All rights reserved.
//

#import "ImagePixelCustomViewController.h"
#import "UIImage+PixelMix.h"

@interface ImagePixelCustomViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageOriView;
@property (assign, nonatomic) CGFloat rValue;
@property (assign, nonatomic) CGFloat gValue;
@property (assign, nonatomic) CGFloat bValue;

@end

@implementation ImagePixelCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _rValue = _gValue = _bValue = 1.0;
}

- (IBAction)RSlider:(UISlider *)sender {
    _rValue = sender.value;
    [self updateImage];
}
- (IBAction)GSlider:(UISlider *)sender {
    _gValue = sender.value;
    [self updateImage];
}
- (IBAction)BSlider:(UISlider *)sender {
    _bValue = sender.value;
    [self updateImage];
}


- (void)updateImage {
    NSLog(@"r = %lf, g = %lf, b = %f",_rValue,_gValue,_bValue);
//    UIImage *new = [_imageOriView.image setRGBImage:_rValue g:_gValue b:_bValue];
    UIImage *new = [_imageOriView.image imageToRGB:_rValue g:_gValue b:_bValue];
    _imageOriView.image = new;
}
@end
