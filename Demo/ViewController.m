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

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)showPicker:(id)sender {
    INImagePickerController *picker = [[INImagePickerController alloc] init];
    picker.delegate = self;
    picker.edit = YES;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

- (void)INImagePickerControllerDidCancel:(INImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)INImagePickerController:(INImagePickerController *)picker didFinishPickingMediaWithArray:(NSArray *)imageArray {
    NSLog(@"%@", imageArray);
    NSDictionary *info = imageArray.firstObject;
    self.imageView.image = info[INImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
