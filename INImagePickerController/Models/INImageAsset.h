//
//  INImageAsset.h
//  INImagePickerControllerDemo
//
//  Created by MaMingkun on 16/9/2.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface INImageAsset : NSObject

@property (nonatomic, strong) PHAsset *imageAsset;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) NSInteger num;

@end
