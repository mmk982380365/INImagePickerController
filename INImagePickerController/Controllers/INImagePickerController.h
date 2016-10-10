//
//  INImagePickerController.h
//  INImagePickerControllerDemo
//
//  Created by MaMingkun on 16/9/2.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//


/**
 *  
 */

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"

#import <UIKit/UIKit.h>
#import "INImageManager.h"

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

extern NSString * const INImagePickerControllerOriginalImage;
extern NSString * const INImagePickerControllerLocation;

@class INImagePickerController;
@protocol INImagePickerControllerDelegate <NSObject>

- (void)INImagePickerController:(INImagePickerController *)picker didFinishPickingMediaWithArray:(NSArray *)imageArray;
- (void)INImagePickerControllerDidCancel:(INImagePickerController *)picker;

@end
@interface INImagePickerController : UINavigationController

@property (nonatomic, strong, readonly) INImageManager *manager;

@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, assign) BOOL onlyLocations;

@property (nonatomic, weak) id<UINavigationControllerDelegate,INImagePickerControllerDelegate> delegate;

@end
#pragma clang diagnostic pop
