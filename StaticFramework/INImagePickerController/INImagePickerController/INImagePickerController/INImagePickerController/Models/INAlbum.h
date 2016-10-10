//
//  INAlbum.h
//  INImagePickerControllerDemo
//
//  Created by MaMingkun on 16/9/5.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface INAlbum : NSObject

@property (nonatomic, strong) id collection;

@property (nonatomic, strong) UIImage *thumbnail;

@property (nonatomic, assign) NSInteger countOfImage;

@property (nonatomic, strong) NSString *title;

@end
