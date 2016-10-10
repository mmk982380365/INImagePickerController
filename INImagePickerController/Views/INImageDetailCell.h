//
//  INImageDetailCell.h
//  INImagePickerControllerDemo
//
//  Created by MaMingkun on 16/9/5.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kPickerUpdateStringNotification = @"kPickerUpdateStringNotification";

@interface INImageDetailCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;

@end
