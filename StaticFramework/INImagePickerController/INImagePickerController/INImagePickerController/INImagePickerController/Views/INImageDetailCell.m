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

@interface INImageDetailCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation INImageDetailCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        
    }
    return self;
}

- (void)dealloc
{
    self.imageView.image = nil;
    self.image = nil;
}

#pragma mark - setter

-(void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
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

@end
