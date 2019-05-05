//
//  INAlbumCell.m
//  INImagePickerControllerDemo
//
//  Created by Yuuki on 16/9/5.
//  Copyright © 2016年 Yuuki. All rights reserved.
//

#import "INAlbumCell.h"
#import "INImagePickerController.h"
//#import "UIView+Position.h"

@interface INAlbumCell ()

@property (nonatomic, strong) UIImageView *albumImageView;

@property (nonatomic, strong) UILabel *albumTitleLabel;

@property (nonatomic, strong) UILabel *albumCountLabel;

@end

@implementation INAlbumCell


- (void)dealloc
{
    self.albumImage = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        [self.contentView addSubview:self.albumImageView];
        [self.contentView addSubview:self.albumTitleLabel];
        [self.contentView addSubview:self.albumCountLabel];
        
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.albumImageView.image = self.albumImage;
    self.albumTitleLabel.text = self.albumName;
    self.albumCountLabel.text = [NSString stringWithFormat:@"%ld",self.albumImageCount];
}

#pragma mark - getter

-(UIImageView *)albumImageView{
    if (_albumImageView == nil) {
        _albumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        _albumImageView.clipsToBounds = YES;
        _albumImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _albumImageView;
}

-(UILabel *)albumTitleLabel{
    if (_albumTitleLabel == nil) {
        _albumTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.albumImageView.frame.size.width + self.albumImageView.frame.origin.x + 10, 5, Screen_Width - (self.albumImageView.frame.size.width + self.albumImageView.frame.origin.x) - 20 - 50, 30)];
        _albumTitleLabel.textColor = [UIColor whiteColor];
    }
    return _albumTitleLabel;
}

-(UILabel *)albumCountLabel{
    if (_albumCountLabel == nil) {
        _albumCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.albumImageView.frame.size.width + self.albumImageView.frame.origin.x + 10, self.albumTitleLabel.frame.origin.y + self.albumTitleLabel.frame.size.height , Screen_Width - (self.albumImageView.frame.size.width + self.albumImageView.frame.origin.x) - 20 - 50, 30)];
        _albumCountLabel.textColor = [UIColor whiteColor];
    }
    return _albumCountLabel;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
