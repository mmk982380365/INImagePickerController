//
//  INImageAsset.h
//  INImagePickerControllerDemo
//
//  Created by Yuuki on 16/9/2.
//  Copyright © 2016年 Yuuki. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

@interface INImageAsset : NSObject

@property (nonatomic, strong) id imageAsset;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, strong) UIImage *thumbnail;

@property (nonatomic, assign) float imageWidth;

@property (nonatomic, assign) float imageHeight;

@end
