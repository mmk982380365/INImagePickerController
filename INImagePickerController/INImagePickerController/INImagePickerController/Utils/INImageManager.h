//
//  INImageManager.h
//  INImagePickerControllerDemo
//
//  Created by Yuuki on 16/9/2.
//  Copyright © 2016年 Yuuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class INImageAsset;
@class INAlbum;

typedef NS_ENUM(NSInteger,INImagePickerResizeMode) {
    INImagePickerResizeModeNone,
    INImagePickerResizeModeFast,
    INImagePickerResizeModeExact,
};

typedef void(^INPickerRelodedBlock)(NSArray *reloadedIndexPaths);
typedef void(^INPickerRelodedFailedBlock)(NSString *errorMsg);

@interface INImageManager : NSObject

@property (nonatomic, strong) NSMutableArray *albumArray;

-(void)fetchAlbums:(void (^)(void))result;

@property (nonatomic, strong) NSMutableArray *showedArray;

-(void)loadImagesWithAlbums:(INAlbum *)album result:(void (^)(void))resultBlock;

-(void)selectImage:(INImageAsset *)asset result:(INPickerRelodedBlock)result failedCallback:(INPickerRelodedFailedBlock)failCallback;

@property (nonatomic, assign) NSInteger maxNum;

@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, assign) NSInteger maxSelectedCount;

@property (nonatomic, assign) BOOL onlyLocations;

@property (nonatomic, assign, class) CGSize maxImageSize;

-(void)requestSelectedImages:(void (^)(NSArray *resultArray))resultBlock;

-(void)requestImageForAsset:(INImageAsset *)asset size:(CGSize)size resizeMode:(INImagePickerResizeMode)resizeMode completion:(void (^)(UIImage *result))completion;

-(void)requestEditedImageWithAsset:(INImageAsset *)asset clipRect:(CGRect)rect result:(void (^)(NSArray *resultArray))resultBlock;

@end
