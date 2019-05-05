//
//  INImageListViewController.h
//  INImagePickerControllerDemo
//
//  Created by Yuuki on 16/9/2.
//  Copyright © 2016年 Yuuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INPickerBaseViewController.h"
/**
 *  列表控制器
 */
@interface INImageListViewController : INPickerBaseViewController
/**
 *  刷新数据
 */
-(void)reloadData;

@end
