//
//  INAlbum.h
//  INImagePickerControllerDemo
//
//  Created by MaMingkun on 16/9/5.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface INAlbum : NSObject

@property (nonatomic, strong) PHAssetCollection *collection;

@property (nonatomic, strong) UIImage *thumbnail;

@property (nonatomic, assign) NSInteger countOfImage;

@end
