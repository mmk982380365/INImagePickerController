//
//  INAlbumCell.h
//  INImagePickerControllerDemo
//
//  Created by MaMingkun on 16/9/5.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INAlbumCell : UITableViewCell

@property (nonatomic, strong) UIImage *albumImage;

@property (nonatomic, strong) NSString *albumName;

@property (nonatomic, assign) NSInteger albumImageCount;

@end
