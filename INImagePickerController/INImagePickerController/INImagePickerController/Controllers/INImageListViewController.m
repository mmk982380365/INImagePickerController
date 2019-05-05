//
//  INImageListViewController.m
//  INImagePickerControllerDemo
//
//  Created by Yuuki on 16/9/2.
//  Copyright © 2016年 Yuuki. All rights reserved.
//

#import "INImageListViewController.h"
#import "INImagePickerController.h"
#import "INAlbumSelectTitle.h"
#import "INAlbumSelectCell.h"
#import "INAlbumCell.h"
#import "INImageDetailViewController.h"
#import "INImageEditViewController.h"
#import "INAlbum.h"
#import "INImageAsset.h"

#define margin 3

@interface INImageListViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) INAlbumSelectTitle *albumTitle;

@property (nonatomic, strong) UITableView *albumTableView;

@property (nonatomic, strong) UIBarButtonItem *cancelButton;

@property (nonatomic, strong) UIBarButtonItem *previewButton;

@property (nonatomic, strong) UIBarButtonItem *confirmButton;

@property (nonatomic, assign) BOOL hide;

@property (nonatomic, strong) INImageAsset *editSelectedAsset;

@end

@implementation INImageListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    //设置导航栏标题的视图
    self.navigationItem.titleView = self.albumTitle;
    
    //图片列表
    [self.view addSubview:self.collectionView];
    //相册列表
    [self.view addSubview:self.albumTableView];
    
    //取消按钮
    self.navigationItem.rightBarButtonItem = self.cancelButton;
    
    //设置工具栏按钮
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    INImagePickerController *picker = (INImagePickerController *)self.navigationController;
    if (picker.edit) {
        self.toolbarItems = @[flex,self.confirmButton,fix];
    }else{
        self.toolbarItems = @[fix,self.previewButton,flex,self.confirmButton,fix];
    }
    
    
    
    
    //默认显示相机胶卷  无数据则显示第一个相册
    BOOL isFind = NO;
    INAlbum *collection = nil;
    for (INAlbum *album in [(INImagePickerController *)self.navigationController manager].albumArray) {
        if ([album.title isEqualToString:@"相机胶卷"]) {
            isFind = YES;
            collection = album;
            break;
        }
    }
    if (isFind == NO && [(INImagePickerController *)self.navigationController manager].albumArray.count > 0) {
        collection = [(INImagePickerController *)self.navigationController manager].albumArray.firstObject;
    }
    //设置标题
    self.albumTitle.title = collection.title;
    [self loadAlbums:collection];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellClicked:) name:kINAlbumSelectCellClickNotification object:nil];
    
}

-(void)sendToEditView{
    INImageEditViewController *edit = [[INImageEditViewController alloc] init];
    edit.asset = self.editSelectedAsset;
    [self.navigationController pushViewController:edit animated:YES];
}

//选择图片的通知回调
-(void)cellClicked:(NSNotification *)note{
    //选择的indexPath
    NSIndexPath *indexPath = note.object;
    //选择model
    INImageAsset *asset = [(INImagePickerController *)self.navigationController manager].showedArray[indexPath.item];
    
    //更改数组状态
    [[(INImagePickerController *)self.navigationController manager] selectImage:asset result:^(NSArray *reloadedIndexPaths) {
        [self.collectionView reloadItemsAtIndexPaths:reloadedIndexPaths];
    }];
    
    
    //更新toolBar按钮状态
    NSArray *selectArr = [(INImagePickerController *)self.navigationController manager].selectedArray;
    
    if (selectArr.count > 0) {
        NSString *showedString = [NSString stringWithFormat:@"确定 (%ld)",selectArr.count];
        self.confirmButton.title = showedString;
        self.confirmButton.enabled = YES;
        self.previewButton.enabled = YES;
    }else{
        NSString *showedString = [NSString stringWithFormat:@"确定"];
        self.confirmButton.enabled = NO;
        self.confirmButton.title = showedString;
        self.previewButton.enabled = NO;
    }
}

#pragma mark - data

-(void)reloadData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.albumTableView reloadData];
    });
}
/**
 *  选取相册
 *
 *  @param collection 要选择的相册
 */
-(void)loadAlbums:(INAlbum *)collection{
    //选择相册
    __weak typeof(self) ws = self;
    [[(INImagePickerController *)self.navigationController manager] loadImagesWithAlbums:collection result:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws.collectionView reloadData];
            //滚动视图到底部
            if ([(INImagePickerController *)self.navigationController manager].showedArray.count > 0) {
                [ws.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[(INImagePickerController *)self.navigationController manager].showedArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            }
        });
        
    }];
}

#pragma mark - btnAction
//取消选择
-(void)cancelSelect:(id)sender{
//    NSLog(@"取消");
    if ([(INImagePickerController *)self.navigationController delegate] && [[(INImagePickerController *)self.navigationController delegate] conformsToProtocol:@protocol(INImagePickerControllerDelegate)] && [[(INImagePickerController *)self.navigationController delegate] respondsToSelector:@selector(INImagePickerControllerDidCancel:)]) {
        [[(INImagePickerController *)self.navigationController delegate] INImagePickerControllerDidCancel:(INImagePickerController *)self.navigationController];
        
    }
    
}
//预览按钮
-(void)previewPhotos:(id)sender{
//    NSLog(@"预览");
    INImageDetailViewController *detail = [[INImageDetailViewController alloc] init];
    //进入后显示选中的图片
    if ([(INImagePickerController *)self.navigationController manager].selectedArray.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[[(INImagePickerController *)self.navigationController manager].showedArray indexOfObject:[(INImagePickerController *)self.navigationController manager].selectedArray.firstObject] inSection:0];
        detail.selectedIndexPath = indexPath;
    }
    //返回刷新toolBar状态
    detail.reloadedBlock = ^(NSArray *reloadedIndexPaths){
        [self.collectionView reloadItemsAtIndexPaths:reloadedIndexPaths];
        NSArray *selectArr = [(INImagePickerController *)self.navigationController manager].selectedArray;
        
        if (selectArr.count > 0) {
            NSString *showedString = [NSString stringWithFormat:@"确定 (%ld)",selectArr.count];
            self.confirmButton.title = showedString;
            self.confirmButton.enabled = YES;
            self.previewButton.enabled = YES;
        }else{
            NSString *showedString = [NSString stringWithFormat:@"确定"];
            self.confirmButton.enabled = NO;
            self.confirmButton.title = showedString;
            self.previewButton.enabled = NO;
        }
    };
    
    [self.navigationController pushViewController:detail animated:YES];
}
//确认事件
-(void)confirmToSelect:(id)sender{
    //请求选中的图片回送给调用的对象
    
    INImagePickerController *picker = (INImagePickerController *)self.navigationController;
    if (picker.edit) {
        NSArray *selectArr = [(INImagePickerController *)self.navigationController manager].selectedArray;
        self.editSelectedAsset = selectArr.lastObject;
        [self sendToEditView];
    }else{
        [[(INImagePickerController *)self.navigationController manager] requestSelectedImages:^(NSArray *resultArray) {
            if ([(INImagePickerController *)self.navigationController delegate] && [[(INImagePickerController *)self.navigationController delegate] conformsToProtocol:@protocol(INImagePickerControllerDelegate)] && [[(INImagePickerController *)self.navigationController delegate] respondsToSelector:@selector(INImagePickerController:didFinishPickingMediaWithArray:)]) {
                [[(INImagePickerController *)self.navigationController delegate] INImagePickerController:(INImagePickerController *)self.navigationController didFinishPickingMediaWithArray:resultArray];
                
            }
        }];
    }
    
    
    
}
//点击titleView的回调 动画
-(void)clickAction:(INAlbumSelectTitle *)sender{
    if (sender.isSelected == NO) {//选择
        sender.selected = YES;
        NSLog(@"选择");
        self.albumTableView.contentOffset = CGPointMake(0, -(self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height));
        [UIView animateWithDuration:0.2 animations:^{
            self.albumTableView.frame = self.view.bounds;
        }];
        
    }else{//取消选择
        sender.selected = NO;
        NSLog(@"取消选择");
        [UIView animateWithDuration:0.2 animations:^{
            self.albumTableView.frame = CGRectMake(0, 0, Screen_Width, 1);
        }];
    }
    
}

#pragma mark - tableView delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    INAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[INAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    //设置cell的
    NSArray *arr = [(INImagePickerController *)self.navigationController manager].albumArray;
    
    
    INAlbum *collection = arr[indexPath.row];
    
    cell.albumName = collection.title;
    

    cell.albumImageCount = collection.countOfImage;


    cell.albumImage = collection.thumbnail;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(INImagePickerController *)self.navigationController manager].albumArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    INAlbum *collection = [(INImagePickerController *)self.navigationController manager].albumArray[indexPath.row];
    self.albumTitle.title = collection.title;
    [self loadAlbums:collection];
    [self clickAction:self.albumTitle];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark - collectionView delegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    INAlbumSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    
    INImageAsset *asset = [(INImagePickerController *)self.navigationController manager].showedArray[indexPath.item];
    
    [[(INImagePickerController *)self.navigationController manager] requestImageForAsset:asset size:CGSizeMake(200, 200) resizeMode:INImagePickerResizeModeNone completion:^(UIImage *result) {
        cell.image = result;
    }];
    
    cell.clicked = asset.selected;
    cell.num = asset.num;
    
    
    cell.indexPath = indexPath;
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [(INImagePickerController *)self.navigationController manager].showedArray.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    INImagePickerController *picker = (INImagePickerController *)self.navigationController;
    
    if (picker.edit) {
        INImageAsset *asset = [(INImagePickerController *)self.navigationController manager].showedArray[indexPath.item];
        self.editSelectedAsset = asset;
        [self sendToEditView];
    }else{
        INImageDetailViewController *detail = [[INImageDetailViewController alloc] init];
        detail.selectedIndexPath = indexPath;
        detail.reloadedBlock = ^(NSArray *reloadedIndexPaths){
            [collectionView reloadItemsAtIndexPaths:reloadedIndexPaths];
            NSArray *selectArr = [(INImagePickerController *)self.navigationController manager].selectedArray;
            
            if (selectArr.count > 0) {
                NSString *showedString = [NSString stringWithFormat:@"确定 (%ld)",selectArr.count];
                self.confirmButton.title = showedString;
                self.confirmButton.enabled = YES;
                self.previewButton.enabled = YES;
            }else{
                NSString *showedString = [NSString stringWithFormat:@"确定"];
                self.confirmButton.enabled = NO;
                self.confirmButton.title = showedString;
                self.previewButton.enabled = NO;
            }
        };
        
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    
    
}

#pragma mark - getter

-(UICollectionViewFlowLayout *)layout{
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        
        CGFloat cellWidth = (Screen_Width - 4 * margin) / 3.0;
        
        _layout.itemSize = CGSizeMake(cellWidth, cellWidth);
        _layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        _layout.minimumInteritemSpacing = margin;
        _layout.minimumLineSpacing = margin;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
    }
    return _layout;
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        [_collectionView registerClass:[INAlbumSelectCell class] forCellWithReuseIdentifier:@"cellId"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

-(INAlbumSelectTitle *)albumTitle{
    if (_albumTitle == nil) {
        _albumTitle = [[INAlbumSelectTitle alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_albumTitle addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _albumTitle;
}

-(UITableView *)albumTableView{
    if (_albumTableView == nil) {
        _albumTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 1) style:UITableViewStylePlain];
        _albumTableView.dataSource = self;
        _albumTableView.delegate = self;
        _albumTableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        
        _albumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _albumTableView;
}

-(UIBarButtonItem *)cancelButton{
    if (_cancelButton == nil) {
        _cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSelect:)];
        _cancelButton.tintColor = [UIColor colorWithRed:0.4392 green:0.8902 blue:0.9569 alpha:1.0];
    }
    return _cancelButton;
}

-(UIBarButtonItem *)previewButton{
    if (_previewButton == nil) {
        _previewButton = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(previewPhotos:)];
        _previewButton.tintColor = [UIColor whiteColor];
        _previewButton.enabled = NO;
    }
    return _previewButton;
}

-(UIBarButtonItem *)confirmButton{
    if (_confirmButton == nil) {
        _confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmToSelect:)];
        _confirmButton.tintColor = [UIColor whiteColor];
        _confirmButton.enabled = NO;
    }
    return _confirmButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
