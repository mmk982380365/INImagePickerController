//
//  INAlbumSelectCell.m
//  INImagePickerControllerDemo
//
//  Created by MaMingkun on 16/9/2.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "INAlbumSelectCell.h"
#import "INImagePickerController.h"
//#import "UIView+Position.h"

@interface INAlbumSelectCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *maskImageView;

@property (nonatomic, strong) UIButton *clickButton;

@end

@implementation INAlbumSelectCell

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"%@ class dealloc",NSStringFromClass(self.class));
#endif
    self.imageView.image = nil;
    self.image = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        
        [self addSubview:self.imageView];
        [self addSubview:self.maskImageView];
        
        [self addSubview:self.clickButton];
        
    }
    return self;
}

-(void)btnClick:(id)sender{
    if (self.clickBlock) {
        self.clickBlock(self.indexPath);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kINAlbumSelectCellClickNotification object:self.indexPath];
}

-(void)setClicked:(BOOL)clicked{
    _clicked = clicked;
    self.clickButton.selected = clicked;
    if (clicked) {
        self.maskImageView.hidden = NO;
    }else{
        self.maskImageView.hidden = YES;
    }
}

-(void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
}

-(void)setNum:(NSInteger)num{
    _num = num;
    [_clickButton setTitle:[NSString stringWithFormat:@"%ld",num] forState:UIControlStateSelected];
}

#pragma mark - getter

-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

-(UIImageView *)maskImageView{
    if (_maskImageView == nil) {
        _maskImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _maskImageView.image = [UIImage imageNamed:@"INImagePickerController.bundle/picker_mask"];
    }
    return _maskImageView;
}

-(UIButton *)clickButton{
    if (_clickButton == nil) {
        _clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickButton.frame = CGRectMake(self.contentView.frame.size.width - 35 - 5, 5, 35, 35);
        _clickButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        _clickButton.titleEdgeInsets = UIEdgeInsetsMake(5, -30, 5, -5);
        [_clickButton setImage:[UIImage imageNamed:@"INImagePickerController.bundle/picker_unselected"] forState:UIControlStateNormal];
        [_clickButton setImage:[UIImage imageNamed:@"INImagePickerController.bundle/picker_selected"] forState:UIControlStateSelected];
        [_clickButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_clickButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _clickButton;
}

@end
