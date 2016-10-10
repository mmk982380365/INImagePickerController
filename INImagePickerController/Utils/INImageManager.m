//
//  INImageManager.m
//  INImagePickerControllerDemo
//
//  Created by MaMingkun on 16/9/2.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "INImageManager.h"
#import <Photos/Photos.h>
#import "INImagePickerController.h"
#import "INImageAsset.h"
#import "INAlbum.h"

@implementation INImageManager
- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"%@ class dealloc",NSStringFromClass(self.class));
#endif
    
    [self.showedArray removeAllObjects];
    [self.albumArray removeAllObjects];
    [self.selectedArray removeAllObjects];
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.albumArray = [NSMutableArray arrayWithCapacity:0];
        self.showedArray = [NSMutableArray arrayWithCapacity:0];
        self.selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

-(void)fetchAlbums:(void (^)())result{
    
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

-(void)loadImagesWithAlbums:(PHAssetCollection *)album result:(void (^)())resultBlock{
    @synchronized(self.showedArray) {
        PHFetchResult *assetFetch = [PHAsset fetchAssetsInAssetCollection:album options:nil];
        [self.showedArray removeAllObjects];
        [self.selectedArray removeAllObjects];
        for (PHAsset *imageAsset in assetFetch) {
            
            
            if (self.onlyLocations == NO) {
                INImageAsset *asset = [[INImageAsset alloc] init];
                asset.imageAsset = imageAsset;
                asset.selected = NO;
                asset.num = 0;
                [self.showedArray addObject:asset];
            }else{
                if (imageAsset.location) {
                    INImageAsset *asset = [[INImageAsset alloc] init];
                    asset.imageAsset = imageAsset;
                    asset.selected = NO;
                    asset.num = 0;
                    [self.showedArray addObject:asset];
                }
            }
            
            
            
            
        }
    }
    if (resultBlock) {
        resultBlock();
    }
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
    
    
    if (resultBlock) {
        resultBlock([resultArray copy]);
    }
    [resultArray removeAllObjects];
    resultArray = nil;
}

@end
