//
//  INImageManager.m
//  INImagePickerControllerDemo
//
//  Created by Yuuki on 16/9/2.
//  Copyright © 2016年 Yuuki. All rights reserved.
//

#import "INImageManager.h"

#ifdef __IPHONE_8_0

#import <Photos/Photos.h>

#else

#import <AssetsLibrary/AssetsLibrary.h>

#endif

#import <AssetsLibrary/AssetsLibrary.h>



#import "INImagePickerController.h"
#import "INImageAsset.h"
#import "INAlbum.h"

@interface INImageManager ()

//#ifndef __IPHONE_8_0

//#else
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
//#endif

@end

@implementation INImageManager
@dynamic maxImageSize;
- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"%@ class dealloc",NSStringFromClass(self.class));
#endif
    
    [self.showedArray removeAllObjects];
    [self.albumArray removeAllObjects];
    [self.selectedArray removeAllObjects];
    
//#ifndef __IPHONE_8_0
    self.assetsLibrary = nil;
//#endif
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        [self defineVersion];
       
//#ifndef __IPHONE_8_0
      
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
        
//#endif
        
        self.albumArray = [NSMutableArray arrayWithCapacity:0];
        self.showedArray = [NSMutableArray arrayWithCapacity:0];
        self.selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

//-(void)defineVersion{
//    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
//        isIos7 = NO;
//    }else{
//        isIos7 = YES;
//    }
//}

-(void)fetchAlbums:(void (^)(void))result{
 
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
            [self loadAlbumsIn7];
            if (result) {
                result();
            }
        }else{
            if (result) {
                result();
            }
        }
    }else{
        if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self loadAlbums];
                    if (result) {
                        result();
                    }
                }
            }];
        }else{
            [self loadAlbums];
            if (result) {
                result();
            }
        }
    }
#ifndef __IPHONE_8_0
    
#else
    
#endif
    
}

-(void)loadImagesWithAlbums:(INAlbum *)album result:(void (^)(void))resultBlock{
    @synchronized(self.showedArray) {
        
        if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
            ALAssetsGroup *group = album.collection;
            [self.showedArray removeAllObjects];
            [self.selectedArray removeAllObjects];
            
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (self.onlyLocations == NO) {
                    if (index < group.numberOfAssets) {
                        INImageAsset *asset = [[INImageAsset alloc] init];
                        asset.imageAsset = result;
                        asset.selected = NO;
                        asset.num = 0;
                        
                        asset.imageWidth = result.defaultRepresentation.dimensions.width;
                        asset.imageHeight = result.defaultRepresentation.dimensions.height;
                        
                        [self.showedArray addObject:asset];
                    }
                    
                }else{
                    CLLocation *location = [result valueForProperty:ALAssetPropertyLocation];
                    if (location) {
                        if (index < group.numberOfAssets) {
                            INImageAsset *asset = [[INImageAsset alloc] init];
                            asset.imageAsset = result;
                            asset.selected = NO;
                            asset.num = 0;
                            asset.imageWidth = result.defaultRepresentation.dimensions.width;
                            asset.imageHeight = result.defaultRepresentation.dimensions.height;
                            [self.showedArray addObject:asset];
                        }
                    }
                }
            }];
        }else{
            PHFetchResult *assetFetch = [PHAsset fetchAssetsInAssetCollection:album.collection options:nil];
            [self.showedArray removeAllObjects];
            [self.selectedArray removeAllObjects];
            for (PHAsset *imageAsset in assetFetch) {
                
                
                if (self.onlyLocations == NO) {
                    INImageAsset *asset = [[INImageAsset alloc] init];
                    asset.imageAsset = imageAsset;
                    asset.selected = NO;
                    asset.num = 0;
                    asset.imageWidth = imageAsset.pixelWidth;
                    asset.imageHeight = imageAsset.pixelHeight;
                    [self.showedArray addObject:asset];
                }else{
                    if (imageAsset.location) {
                        INImageAsset *asset = [[INImageAsset alloc] init];
                        asset.imageAsset = imageAsset;
                        asset.selected = NO;
                        asset.num = 0;
                        asset.imageWidth = imageAsset.pixelWidth;
                        asset.imageHeight = imageAsset.pixelHeight;
                        [self.showedArray addObject:asset];
                    }
                }
                
                
                
                
            }
        }
       
#ifndef __IPHONE_8_0
        
        
        
#else
        
        
        
#endif
    }

    if (resultBlock) {
        resultBlock();
    }
}

-(void)loadAlbumsIn7{
    __weak typeof(self) ws = self;
    
//#ifndef __IPHONE_8_0
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        __strong typeof(ws) self = ws;
        
        NSLog(@"%@",group);
        
        
        if (self.onlyLocations == NO) {
            //全部显示
            if (group.numberOfAssets > 0) {
                INAlbum *album = [[INAlbum alloc] init];
                album.collection = group;
                album.title = [group valueForProperty:ALAssetsGroupPropertyName];
                album.countOfImage = group.numberOfAssets;
                album.thumbnail = [UIImage imageWithCGImage:group.posterImage];
                [self.albumArray addObject:album];
            }
            
            
        }else{
            __block int countOfLocation = 0;
            __block UIImage *thumb = nil;
            //只显示定位
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                CLLocation *location = [result valueForProperty:ALAssetPropertyLocation];
                
                if (location) {
                    countOfLocation++;
                    thumb = [UIImage imageWithCGImage:result.thumbnail];
                }
                
            }];
            
            if (countOfLocation > 0) {
                INAlbum *album = [[INAlbum alloc] init];
                album.collection = group;
                album.title = [group valueForProperty:ALAssetsGroupPropertyName];
                album.countOfImage = countOfLocation;
                album.thumbnail = thumb;
                [self.albumArray addObject:album];
            }
            
        }
        
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Error with :%@",error);
    }];
    
//#endif
    
}

-(void)loadAlbums{
    PHFetchResult *regularFetch = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    PHFetchResult *smartFetch = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    for (PHAssetCollection *collection in regularFetch) {
        
        if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeAlbumMyPhotoStream) {
            continue;
        }
        
        INAlbum *album = [[INAlbum alloc] init];
        album.collection = collection;
        album.title = collection.localizedTitle;
        PHFetchResult *rs = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        
        
        if (rs.count > 0) {
            if (self.onlyLocations == NO) {
                [[PHImageManager defaultManager] requestImageForAsset:rs.firstObject targetSize:CGSizeMake(150, 150) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    album.thumbnail = result;
                }];
                album.countOfImage = rs.count;
                [self.albumArray addObject:album];
            }else{
                //显示定位图片
                
                //统计数量
                
                int countOfLocations = 0;
                PHAsset *thumb = nil;
                for (PHAsset *ass in rs) {
                    if (ass.location) {
                        countOfLocations++;
                        thumb = ass;
                    }
                }
                if (countOfLocations > 0) {
                    [[PHImageManager defaultManager] requestImageForAsset:thumb targetSize:CGSizeMake(150, 150) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        album.thumbnail = result;
                    }];
                    album.countOfImage = countOfLocations;
                    [self.albumArray addObject:album];
                }
                
            }
            
        }
        
        
    }
    
    for (PHAssetCollection *collection in smartFetch) {
        if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumVideos || collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden) {
            continue;
        }
        
        
        PHFetchResult *rs = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        INAlbum *album = [[INAlbum alloc] init];
        album.collection = collection;
        album.title = collection.localizedTitle;
        
        if (rs.count > 0) {
            
            
            if (self.onlyLocations == NO) {
                [[PHImageManager defaultManager] requestImageForAsset:rs.firstObject targetSize:CGSizeMake(150, 150) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    album.thumbnail = result;
                }];
                
                album.countOfImage = rs.count;
                [self.albumArray addObject:album];
            }else{
                //显示定位图片
                
                //统计数量
                
                int countOfLocations = 0;
                PHAsset *thumb = nil;
                for (PHAsset *ass in rs) {
                    if (ass.location) {
                        countOfLocations++;
                        thumb = ass;
                    }
                }
                if (countOfLocations > 0) {
                    [[PHImageManager defaultManager] requestImageForAsset:thumb targetSize:CGSizeMake(150, 150) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        album.thumbnail = result;
                    }];
                    album.countOfImage = countOfLocations;
                    [self.albumArray addObject:album];
                }
            }
            
        }
        
    }
}

-(void)selectImage:(INImageAsset *)asset result:(INPickerRelodedBlock)result{
    
    NSInteger nums = 0;
    NSMutableArray *indexPathArray = [NSMutableArray arrayWithCapacity:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.showedArray indexOfObject:asset] inSection:0];
    [indexPathArray addObject:indexPath];
    if (asset.selected == NO) {
        //查找选中最大num
        for (INImageAsset *a in self.showedArray) {
            if (a.num > nums) {
                nums = a.num;
            }
        }
        if (nums < self.maxSelectedCount || self.maxSelectedCount == 0) {
            asset.num = nums + 1;
            asset.selected = YES;
            [self.selectedArray addObject:asset];
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已超过最大图片选择数量" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alertView show];
                });
                
                sleep(1);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alertView dismissWithClickedButtonIndex:0 animated:YES];
                });
                
            });
            
        }
    }else{
        
        //将比这个num大的每个减1
        for (INImageAsset *a in self.showedArray) {
            if (a.num > asset.num) {
                a.num--;
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.showedArray indexOfObject:a] inSection:0];
                [indexPathArray addObject:indexPath];
            }
        }
        asset.num = 0;
        asset.selected = NO;
        [self.selectedArray removeObject:asset];
    }
    
    if (result) {
        result(indexPathArray);
    }
    
}

-(void)requestSelectedImages:(void (^)(NSArray *))resultBlock{
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        for (INImageAsset *selectAss in self.selectedArray) {
            ALAsset *asset = selectAss.imageAsset;
            
            UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage scale:asset.defaultRepresentation.scale orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
            CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
            if (location) {
                NSDictionary *dict = @{INImagePickerControllerOriginalImage:image,INImagePickerControllerLocation:location};
                [resultArray addObject:dict];
            }else{
                NSDictionary *dict = @{INImagePickerControllerOriginalImage:image};
                [resultArray addObject:dict];
            }
            
            
        }
    }else{
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.synchronous = YES;
        option.networkAccessAllowed = YES;
        for (INImageAsset *selectAss in self.selectedArray) {
            PHAsset *asset = selectAss.imageAsset;
            
            
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                UIImage *image = [UIImage imageWithData:imageData];
                
                if (asset.location) {
                    NSDictionary *dict = @{INImagePickerControllerOriginalImage:image,INImagePickerControllerLocation:asset.location};
                    [resultArray addObject:dict];
                }else{
                    NSDictionary *dict = @{INImagePickerControllerOriginalImage:image};
                    [resultArray addObject:dict];
                }
                
            }];
            
        }
    }
    
//#ifndef __IPHONE_8_0
    
//#else
    
    
//#endif
    
    if (resultBlock) {
        resultBlock([resultArray copy]);
    }

    [resultArray removeAllObjects];
    resultArray = nil;
}

-(void)requestImageForAsset:(INImageAsset *)asset size:(CGSize)size resizeMode:(INImagePickerResizeMode)resizeMode completion:(void (^)(UIImage *))completion{
    if ([asset.imageAsset isKindOfClass:[PHAsset class]]) {
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = (PHImageRequestOptionsResizeMode)resizeMode;
        options.networkAccessAllowed = YES;
        [[PHCachingImageManager defaultManager] requestImageForAsset:asset.imageAsset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (completion) {
                completion(result);
            }
        }];
        
    }else{
//#ifndef __IPHONE_8_0
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ALAsset *imageAsset = asset.imageAsset;
            UIImage *image;
            
            switch (resizeMode) {
                case INImagePickerResizeModeExact:
                {
                    image = [UIImage imageWithCGImage:imageAsset.defaultRepresentation.fullResolutionImage scale:imageAsset.defaultRepresentation.scale orientation:(UIImageOrientation)imageAsset.defaultRepresentation.orientation];
                }
                    break;
                case INImagePickerResizeModeFast:
                {
                    image = [UIImage imageWithCGImage:imageAsset.thumbnail];
                }
                    break;
                case INImagePickerResizeModeNone:
                {
                    image = [UIImage imageWithCGImage:imageAsset.thumbnail ];
                }
                    break;
                    
                default:
                    break;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(image);
                }
            });
            
        });
        

//#endif
    }
}

-(void)requestEditedImageWithAsset:(INImageAsset *)asset clipRect:(CGRect)rect result:(void (^)(NSArray *))resultBlock{
    
    NSLog(@"%@",NSStringFromCGRect(rect));
    
    [self requestImageForAsset:asset size:[[self class] maxImageSize] resizeMode:INImagePickerResizeModeExact completion:^(UIImage *result) {
        
        CGImageRef imgRef = result.CGImage;
        CGImageRef newRef = CGImageCreateWithImageInRect(imgRef, rect);
        UIImage *editedImage = [UIImage imageWithCGImage:newRef];
        CGImageRelease(newRef);
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict setObject:result forKey:INImagePickerControllerOriginalImage];
        [dict setObject:editedImage forKey:INImagePickerControllerEditedImage];
        
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            PHAsset *imageAsset = asset.imageAsset;
            if (imageAsset.location) {
                [dict setObject:imageAsset.location forKey:INImagePickerControllerLocation];
            }
        }else{
            ALAsset *imageAsset = asset.imageAsset;
            
            CLLocation *location = [imageAsset valueForProperty:ALAssetPropertyLocation];
            if (location) {
                [dict setObject:location forKey:INImagePickerControllerLocation];
            }
        }
        
        if (resultBlock) {
            resultBlock(@[dict]);
        }
    }];
}

+(CGSize)maxImageSize{
    return PHImageManagerMaximumSize;
}

@end
