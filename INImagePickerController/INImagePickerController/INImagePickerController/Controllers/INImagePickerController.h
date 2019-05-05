//
//  INImagePickerController.h
//  INImagePickerControllerDemo
//
//  Created by Yuuki on 16/9/2.
//  Copyright © 2016年 Yuuki. All rights reserved.
//


/**
 *
 */

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"

#import <UIKit/UIKit.h>
#import "INImageManager.h"

@class INImagePickerController;


#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
/**
 *  选中的图片
 */
extern NSString * const INImagePickerControllerOriginalImage;
/**
 *  图片定位信息
 */
extern NSString * const INImagePickerControllerLocation;
/**
 *  编辑后的图片
 */
extern NSString *const INImagePickerControllerEditedImage;

/**
 *  图片选择器的代理
 */
@protocol INImagePickerControllerDelegate <NSObject>
/**
 *  选中图片后的回调 
 *  数组结构:
 *  @[@{INImagePickerControllerOriginalImage:image,INImagePickerControllerLocation:location}]
 *
 *  @param picker     选择器
 *  @param imageArray 结果数组
 */
- (void)INImagePickerController:(INImagePickerController *)picker didFinishPickingMediaWithArray:(NSArray *)imageArray;
/**
 *  取消的代理
 *
 *  @param picker 选择器
 */
- (void)INImagePickerControllerDidCancel:(INImagePickerController *)picker;

@end

@interface INImagePickerController : UINavigationController
//图片管理器
@property (nonatomic, strong, readonly) INImageManager *manager;
//设置最大可选择数量
@property (nonatomic, assign) NSInteger maxCount;
//设置是否只显示含有定位的图片
@property (nonatomic, assign) BOOL onlyLocations;
//截取图片
@property (nonatomic, assign) BOOL edit;
//代理回调
@property (nonatomic, weak) id<UINavigationControllerDelegate,INImagePickerControllerDelegate> delegate;

@end
#pragma clang diagnostic pop
