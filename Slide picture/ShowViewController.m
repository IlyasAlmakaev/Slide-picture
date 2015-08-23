//
//  ShowViewController.m
//  Slide picture
//
//  Created by intent on 17/08/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "ShowViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ShowViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pictureContent = [[NSMutableArray alloc] init];
    self.appDelegate = [AppDelegate new];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"PicturesInfo"];

    if ([settings boolForKey:@"showPicture"])
        {
        NSPredicate *favouritesContent = [NSPredicate predicateWithFormat:@"favourite == YES"];

        [fetchRequest setPredicate:favouritesContent];

        self.pictureContent = [[self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];

        }
    else
        {
        self.pictureContent = [[self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        }

    NSLog(@"count massive %i", (int)[self.pictureContent count]);
    
    if (![self.pictureContent count])
        {
        self.labelComment.text = @"У вас нет картинок в favorites";
        }
    else
        {
        self.pictureManagedObject = [self.pictureContent objectAtIndex:self.index];
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:[[self.pictureManagedObject valueForKey:@"idPicture"] stringValue]
                                                         done:^(UIImage *image, SDImageCacheType cacheType)
        {
            if (image)
                {
                self.imageView.image = image;
                }
        }];

        NSLog(@"array content %@", self.pictureContent);
        self.labelComment.text = [self.pictureManagedObject valueForKey:@"comment"];
        }
}

@end
