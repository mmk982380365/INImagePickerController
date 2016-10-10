//
//  INImageDetailCell.m
//  INImagePickerControllerDemo
//
//  Created by MaMingkun on 16/9/5.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "INImageDetailCell.h"
#import "INImagePickerController.h"
//#import "UIView+Position.h"

@interface INImageDetailCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation INImageDetailCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAct:)];
        [self.scrollView addGestureRecognizer:tap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAct:)];
        doubleTap.numberOfTapsRequired = 2;
        [self.scrollView addGestureRecognizer:doubleTap];
        
        [tap requireGestureRecognizerToFail:doubleTap];
        
    }
    return self;
}

-(void)tapAct:(UIGestureRecognizer *)recognizer{
    if (self.singleClickAct) {
        self.singleClickAct();
    }
}

-(void)doubleTapAct:(UIGestureRecognizer *)recognizer{
    if (self.scrollView.zoomScale > 1) {
        [self.scrollView setZoomScale:1 animated:YES];
    }else{
        CGPoint touchPoint = [recognizer locationInView:self.imageView];
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
    
}

- (void)dealloc
{
    self.imageView.image = nil;
    _image = nil;
}

#pragma mark - scrollView delegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}
#pragma mark - setter

-(void)setImage:(UIImage *)image{
    _image = image;
    
    self.scrollView.zoomScale = 1;
    self.imageView.image = image;
    
    
    
    float imageHeight = Screen_Width * (image.size.height / image.size.width);
    
    CGRect imageFrame = CGRectMake(0, 0, Screen_Width, imageHeight);
    
    if (image.size.width < Screen_Width && image.size.height < Screen_Height) {
        imageFrame.size = image.size;
    }
    
    self.imageView.frame = imageFrame;

    self.scrollView.contentSize = imageFrame.size;
    
    if (imageFrame.size.height < Screen_Height) {
        self.imageView.center = CGPointMake(Screen_Width * 0.5, Screen_Height * 0.5);
    }else{
        self.imageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5, self.scrollView.contentSize.height * 0.5);
    }
    
    
}

-(void)setImageAsset:(INImageAsset *)imageAsset{
    self.imageView.image = nil;
    if (imageAsset) {
        _imageAsset = imageAsset;
        float imageHeight = 1.8 * Screen_Width * (imageAsset.imageHeight / imageAsset.imageWidth);
        
        
        CGRect imageFrame = CGRectMake(0, (Screen_Height - imageHeight) * 0.5, Screen_Width, imageHeight);
        
        __weak typeof(self) ws = self;
        
        [self.pickerController.manager requestImageForAsset:imageAsset size:imageFrame.size resizeMode:INImagePickerResizeModeNone completion:^(UIImage *result) {
            ws.image = result;
        }];
        
        
    }
    
}

#pragma mark - getter

-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 7.0;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.scrollsToTop = NO;
    }
    return _scrollView;
}

@end
