//
//  INImageDetailCell.h
//  INImagePickerControllerDemo
//
//  Created by MaMingkun on 16/9/5.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INImageAsset.h"

@class INImagePickerController;

static NSString * const kPickerUpdateStringNotification = @"kPickerUpdateStringNotification";

@interface INImageDetailCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) INImageAsset *imageAsset;

@property (nonatomic, copy) void(^singleClickAct)();

@property (nonatomic, strong) INImagePickerController *pickerController;

@property (nonatomic, assign) int requestID;

@end
