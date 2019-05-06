//
//  INImageDetailViewController.m
//  INImagePickerControllerDemo
//
//  Created by Yuuki on 16/9/2.
//  Copyright © 2016年 Yuuki. All rights reserved.
//

#import "INImageDetailViewController.h"
#import "INImagePickerController.h"
#import "INImageDetailCell.h"
#import "INAlbum.h"
#import "INImageAsset.h"

#define MarginOfCell 30

@interface INImageDetailViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIBarButtonItem *selectBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) INImageAsset *currentAsset;

@property (nonatomic, strong) UIBarButtonItem *confirmButton;

@property (nonatomic, assign) BOOL canHideStatusBar;

@property (nonatomic, assign) BOOL hideStatusBar;

@end

@implementation INImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if ([UIApplication sharedApplication].statusBarHidden == YES) {
        self.canHideStatusBar = NO;
    }else{
        self.canHideStatusBar = YES;
    }
    self.view.clipsToBounds = YES;
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.4392 green:0.8902 blue:0.9569 alpha:1.0];
    
    [self.view addSubview:self.collectionView];
    
    self.navigationItem.rightBarButtonItem = self.selectBtn;
    
    if (self.selectedIndexPath) {
        [self.collectionView selectItemAtIndexPath:self.selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        INImageAsset *asset = [(INImagePickerController *)self.navigationController manager].showedArray[self.selectedIndexPath.item];
        self.currentAsset = asset;
    }
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.toolbarItems = @[flex,self.confirmButton,fix];
    
    NSArray *selectArr = [(INImagePickerController *)self.navigationController manager].selectedArray;
    
    if (selectArr.count > 0) {
        NSString *showedString = [NSString stringWithFormat:@"确定 (%ld)",selectArr.count];
        self.confirmButton.title = showedString;
        self.confirmButton.enabled = YES;
    }else{
        NSString *showedString = [NSString stringWithFormat:@"确定"];
        self.confirmButton.enabled = NO;
        self.confirmButton.title = showedString;
    }
    
}

-(void)confirmToSelect:(id)sender{
    [[(INImagePickerController *)self.navigationController manager] requestSelectedImages:^(NSArray *resultArray) {
        if ([(INImagePickerController *)self.navigationController delegate] && [[(INImagePickerController *)self.navigationController delegate] conformsToProtocol:@protocol(INImagePickerControllerDelegate)] && [[(INImagePickerController *)self.navigationController delegate] respondsToSelector:@selector(INImagePickerController:didFinishPickingMediaWithArray:)]) {
            [[(INImagePickerController *)self.navigationController delegate] INImagePickerController:(INImagePickerController *)self.navigationController didFinishPickingMediaWithArray:resultArray];
            
        }
    }];
}

-(void)clickAction:(id)sender{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    animation.duration = 0.2;
    [self.rightBtn.layer addAnimation:animation forKey:@"s"];
    
    [[(INImagePickerController *)self.navigationController manager] selectImage:self.currentAsset result:^(NSArray *reloadedIndexPaths) {
        self.rightBtn.selected = self.currentAsset.selected;
        [self.rightBtn setTitle:[NSString stringWithFormat:@"%ld",self.currentAsset.num] forState:UIControlStateSelected];
        
        NSArray *selectArr = [(INImagePickerController *)self.navigationController manager].selectedArray;
        
        if (selectArr.count > 0) {
            NSString *showedString = [NSString stringWithFormat:@"确定 (%ld)",selectArr.count];
            self.confirmButton.title = showedString;
            self.confirmButton.enabled = YES;
        }else{
            NSString *showedString = [NSString stringWithFormat:@"确定"];
            self.confirmButton.enabled = NO;
            self.confirmButton.title = showedString;
        }
        
        
        if (self.reloadedBlock) {
            self.reloadedBlock(reloadedIndexPaths);
        }
        
    } failedCallback:^(NSString *errorMsg) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVc animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVc dismissViewControllerAnimated:YES completion:^{
                    
                }];
            });
        }];
    }];
}



#pragma mark - collectionView delegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    INImageDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    cell.pickerController = (INImagePickerController *)self.navigationController;
    
    INImageAsset *asset = [(INImagePickerController *)self.navigationController manager].showedArray[indexPath.item];
    
    cell.imageAsset = asset;
    
    
    __weak typeof(self) ws = self;
    cell.singleClickAct = ^(){
        //隐藏状态栏要修改
        if (ws.navigationController.navigationBarHidden == NO) {
            if (ws.canHideStatusBar) {
                
                ws.hideStatusBar = YES;
                
                [ws setNeedsStatusBarAppearanceUpdate];
                
            }
            
            
            [ws.navigationController setNavigationBarHidden:YES animated:YES];
            [ws.navigationController setToolbarHidden:YES animated:YES];
            
        }else{
            if (ws.canHideStatusBar) {
                ws.hideStatusBar = NO;
                [ws setNeedsStatusBarAppearanceUpdate];
            }
            
            
            [ws.navigationController setNavigationBarHidden:NO animated:YES];
            [ws.navigationController setToolbarHidden:NO animated:YES];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPickerUpdateStringNotification object:nil];
    };
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [(INImagePickerController *)self.navigationController manager].showedArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:INImageDetailCell.class]) {
        [(INImageDetailCell *)cell resetZoom];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger pages = round(scrollView.contentOffset.x / (Screen_Width + self.layout.minimumLineSpacing));
    if (pages < 0) {
        pages = 0;
    }else if (pages > [(INImagePickerController *)self.navigationController manager].showedArray.count - 1){
        pages = [(INImagePickerController *)self.navigationController manager].showedArray.count - 1;
    }
    
    INImageAsset *asset = [(INImagePickerController *)self.navigationController manager].showedArray[pages];
    if (asset != self.currentAsset) {
        self.currentAsset = asset;
    }
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"%s",__func__);
    
}

-(BOOL)prefersStatusBarHidden{
    return self.hideStatusBar;
}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationFade;
}

#pragma mark - setter

-(void)setCurrentAsset:(INImageAsset *)currentAsset{
    _currentAsset = currentAsset;
    self.rightBtn.selected = currentAsset.selected;
    [self.rightBtn setTitle:[NSString stringWithFormat:@"%ld",currentAsset.num] forState:UIControlStateSelected];
}

#pragma mark - getter

-(UICollectionViewFlowLayout *)layout{
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = self.view.bounds.size;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = MarginOfCell;
        _layout.sectionInset = UIEdgeInsetsMake(0, MarginOfCell/2, 0, MarginOfCell/2);
    }
    return _layout;
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-MarginOfCell/2, 0, Screen_Width + MarginOfCell, Screen_Height) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.decelerationRate = 0;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[INImageDetailCell class] forCellWithReuseIdentifier:@"cellId"];
    }
    return _collectionView;
}

-(UIButton *)rightBtn{
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"INImagePickerController.bundle/picker_unselected"] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"INImagePickerController.bundle/picker_selected"] forState:UIControlStateSelected];
        _rightBtn.frame = CGRectMake(0, 0, 35, 35);
        _rightBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        _rightBtn.titleEdgeInsets = UIEdgeInsetsMake(5, -30, 5, -5);
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _rightBtn;
}

-(UIBarButtonItem *)selectBtn{
    if (_selectBtn == nil) {
        _selectBtn = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    }
    return _selectBtn;
}

-(UIBarButtonItem *)confirmButton{
    if (_confirmButton == nil) {
        _confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmToSelect:)];
        _confirmButton.tintColor = [UIColor whiteColor];
    }
    return _confirmButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
