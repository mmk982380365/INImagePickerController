//
//  INAlbumSelectCell.h
//  INImagePickerControllerDemo
//
//  Created by MaMingkun on 16/9/2.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INImageAsset.h"

static NSString * const kINAlbumSelectCellClickNotification = @"kINAlbumSelectCellClickNotification";

typedef void(^AlbumSelectCellClickBlock)(NSIndexPath *indexPath);

@interface INAlbumSelectCell : UICollectionViewCell

@property (nonatomic, assign) BOOL clicked;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) AlbumSelectCellClickBlock clickBlock;

@property (nonatomic, assign) int requestID;

@property (nonatomic, strong) INImageAsset *asset;

@property (nonatomic, assign) BOOL hideSelected;

@end
