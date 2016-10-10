//
//  INAlbumSelectTitle.m
//  INImagePickerControllerDemo
//
//  Created by MaMingkun on 16/9/2.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "INAlbumSelectTitle.h"
#import "INImagePickerController.h"
//#import "UIView+Position.h"

@interface INAlbumSelectTitle ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation INAlbumSelectTitle
@dynamic title;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.arrowImageView];
        [self addSubview:self.titleLabel];
        
    }
    return self;
}



#pragma mark - setter

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if (selected) {
        [UIView animateWithDuration:0.2 animations:^{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
        }];
    }
}

-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.titleLabel.center.x, self.frame.size.height * 0.5);
    
    self.arrowImageView.frame = CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 3, self.arrowImageView.frame.origin.y, self.arrowImageView.frame.size.width, self.arrowImageView.frame.size.height);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.arrowImageView.frame.size.width + self.arrowImageView.frame.origin.x, self.frame.size.height);
    });
}
#pragma mark - getter

-(UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        _arrowImageView.center = CGPointMake(_arrowImageView.center.x, self.frame.size.height * 0.5);
        _arrowImageView.image = [UIImage imageNamed:@"INImagePickerController.bundle/picker_down"];
    }
    return _arrowImageView;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleLabel.center = CGPointMake(_arrowImageView.center.x, self.frame.size.height * 0.5);
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

-(NSString *)title{
    return self.titleLabel.text;
}

@end
