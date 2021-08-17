//
//  LRSViewController.m
//  LRSImagePreview
//
//  Created by 刘sama on 08/13/2021.
//  Copyright (c) 2021 刘sama. All rights reserved.
//

#import "LRSViewController.h"
#import <LRSImagePreview/LRSImagePreviewer.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import <BlocksKit/UIGestureRecognizer+BlocksKit.h>
#import <SDWebImage/SDAnimatedImageView.h>

@interface LRSViewController ()<TZImagePickerControllerDelegate, LRSImageViewerToastDelegate, LRSImageViewerDelegate>
@property (weak, nonatomic) IBOutlet SDAnimatedImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewRatio;

@end

@implementation LRSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        LRSImagePreviewModel *model = [[LRSImagePreviewModel alloc] init];
        model.placeholderImage = ((UIImageView *)sender.view).image;
        LRSImagePreviewModel *model2 = [[LRSImagePreviewModel alloc] init];
        model2.placeholderImage = ((UIImageView *)sender.view).image;
        LRSImagePreviewModel *model3 = [[LRSImagePreviewModel alloc] init];
        model3.placeholderImage = ((UIImageView *)sender.view).image;
        LRSImagePreviewer *view = [LRSImagePreviewer previewWithDelegate:self toastDelegate:self];
        [view showImageViewWithConfigures:@[model, model2, model3] selectedIndex:0 fromReact:sender.view.frame];
        [[UIApplication sharedApplication].delegate.window addSubview:view];
    }]];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)selectImages:(id)sender {
    TZImagePickerController *picker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    picker.allowPickingVideo = false;
    picker.didFinishPickingPhotosWithInfosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        UIImage *image = photos.firstObject;
        self.imageViewRatio.constant = image.size.height/image.size.width;
        self.imageView.image = image;
    };
    picker.didFinishPickingGifImageHandle = ^(UIImage *animatedImage, id sourceAssets) {
        self.imageViewRatio.constant = animatedImage.size.height/animatedImage.size.width;
        self.imageView.image = animatedImage;
    };
    [self presentViewController:picker animated:true completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
