//
//  INImageManager.h
//  INImagePickerControllerDemo
//
//  Created by MaMingkun on 16/9/2.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@class INImageAsset;
@class INAlbum;

typedef void(^INPickerRelodedBlock)(NSArray *reloadedIndexPaths);

@interface INImageManager : NSObject

@property (nonatomic, strong) NSMutableArray *albumArray;

-(void)fetchAlbums:(void (^)())result;

@property (nonatomic, strong) NSMutableArray *showedArray;

-(void)loadImagesWithAlbums:(PHAssetCollection *)album result:(void (^)())resultBlock;

-(void)selectImage:(INImageAsset *)asset result:(INPickerRelodedBlock)result;

@property (nonatomic, assign) NSInteger maxNum;

@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, assign) NSInteger maxSelectedCount;

@property (nonatomic, assign) BOOL onlyLocations;

-(void)requestSelectedImages:(void (^)(NSArray *resultArray))resultBlock;

@end
