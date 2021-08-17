//
//  LRSMutableImagesViewController.m
//  LRSMutableImagesViewController
//
//  Created by sama 刘 on 2021/8/16.
//  Copyright © 2021 刘sama. All rights reserved.
//

#import "LRSMutableImagesViewController.h"
#import "LRSMutableImageTableViewCell.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <LRSImagePreview/LRSImagePreviewer.h>
#import <BlocksKit/NSArray+BlocksKit.h>

@interface LRSMutableImagesViewController ()<UITableViewDataSource, UITableViewDelegate, TZImagePickerControllerDelegate, LRSImageViewerToastDelegate, LRSImageViewerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<UIImage *> *photos;
@end

@implementation LRSMutableImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)selectImages:(id)sender {
    TZImagePickerController *picker = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    picker.allowPickingVideo = false;
    picker.allowPickingGif = false;
    picker.didFinishPickingPhotosWithInfosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        [self.photos addObjectsFromArray:photos];
        [self.tableView reloadData];
    };
    [self presentViewController:picker animated:true completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LRSMutableImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LRSMutableImageTableViewCell" forIndexPath:indexPath];
    cell.image = self.photos[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LRSMutableImageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect rect = [UIApplication.sharedApplication.delegate.window convertRect:cell.imageIns.frame fromView:cell];
    LRSImagePreviewer *view = [LRSImagePreviewer previewWithDelegate:self toastDelegate:self];
    [view showImageViewWithConfigures:[self.photos bk_map:^id(id obj) {
        LRSImagePreviewModel *model = [[LRSImagePreviewModel alloc] init];
        model.placeholderImage = obj;
        return model;
    }] selectedIndex:indexPath.row fromReact:rect];
    [[UIApplication sharedApplication].delegate.window addSubview:view];
}

- (NSMutableArray<UIImage *> *)photos {
    if (!_photos) {
        _photos = [NSMutableArray arrayWithCapacity:0];
    }
    return _photos;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
