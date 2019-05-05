//
//  INAlbumSelectCell.h
//  INImagePickerControllerDemo
//
//  Created by Yuuki on 16/9/2.
//  Copyright © 2016年 Yuuki. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kINAlbumSelectCellClickNotification = @"kINAlbumSelectCellClickNotification";

typedef void(^AlbumSelectCellClickBlock)(NSIndexPath *indexPath);

@interface INAlbumSelectCell : UICollectionViewCell

@property (nonatomic, assign) BOOL clicked;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) AlbumSelectCellClickBlock clickBlock;

@end
