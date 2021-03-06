//
//  INImageDetailViewController.h
//  INImagePickerControllerDemo
//
//  Created by Yuuki on 16/9/2.
//  Copyright © 2016年 Yuuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INPickerBaseViewController.h"
#import "INImagePickerController.h"

@interface INImageDetailViewController : INPickerBaseViewController

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, copy) INPickerRelodedBlock reloadedBlock;

@end
