//
//  ViewController.m
//  Demo
//
//  Created by Yuuki on 2019/5/5.
//  Copyright © 2019 Yuuki. All rights reserved.
//

#import "ViewController.h"
#import "INImagePickerController.h"

@interface ViewController () <INImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)showPicker:(id)sender {
    INImagePickerController *picker = [[INImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

- (void)INImagePickerControllerDidCancel:(INImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)INImagePickerController:(INImagePickerController *)picker didFinishPickingMediaWithArray:(NSArray *)imageArray {
    NSLog(@"%@", imageArray);
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
