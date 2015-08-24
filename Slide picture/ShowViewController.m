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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pictureContent = [[NSMutableArray alloc] init];
    self.appDelegate = [AppDelegate new];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults]; // Получение настроек пользователя

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"PicturesInfo"]; // Запрос в бд

    // Проверка на режим показа "Показывать всё/только favourite"
    if ([settings boolForKey:@"showPicture"])
    {
        NSPredicate *favouritesContent = [NSPredicate predicateWithFormat:@"favourite == YES"]; // Выборка данных со значением "только favourite"

        [fetchRequest setPredicate:favouritesContent];

        self.pictureContent = [[self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy]; // Получение бд
    }
    else
        self.pictureContent = [[self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy]; // Получение бд

    NSLog(@"count massive %i", (int)[self.pictureContent count]);

    // Проверка на содержание картинки в массиве
    if (![self.pictureContent count])
        self.labelComment.text = @"У вас нет картинок в favorites";
    else
        {
        self.pictureManagedObject = [self.pictureContent objectAtIndex:self.index];

        // Метод получения картинки из кэша
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:[[self.pictureManagedObject valueForKey:@"idPicture"] stringValue]
                                                         done:^(UIImage *image, SDImageCacheType cacheType)
        {
            if (image)
                self.imageView.image = image; // Отображение картинки
        }];

        NSLog(@"array content %@", self.pictureContent);
        self.labelComment.text = [self.pictureManagedObject valueForKey:@"comment"]; // Отображение комментария поверх картинки
        }
}

@end
