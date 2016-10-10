//
//  INImageManager.h
//  INImagePickerControllerDemo
//
//  Created by MaMingkun on 16/9/2.
//  Copyright © 2016年 MaMingkun. All rights reserved.
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

@interface INImageManager : NSObject

@property (nonatomic, strong) NSMutableArray *albumArray;

-(void)fetchAlbums:(void (^)())result;

@property (nonatomic, strong) NSMutableArray *showedArray;

-(void)loadImagesWithAlbums:(INAlbum *)album result:(void (^)())resultBlock;

-(void)selectImage:(INImageAsset *)asset result:(INPickerRelodedBlock)result;

@property (nonatomic, assign) NSInteger maxNum;

@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, assign) NSInteger maxSelectedCount;

@property (nonatomic, assign) BOOL onlyLocations;

-(void)requestSelectedImages:(void (^)(NSArray *resultArray))resultBlock;

-(void)requestImageForAsset:(INImageAsset *)asset size:(CGSize)size resizeMode:(INImagePickerResizeMode)resizeMode completion:(void (^)(UIImage *result))completion;

@end
