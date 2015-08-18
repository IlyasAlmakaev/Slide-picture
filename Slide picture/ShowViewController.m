//
//  ShowViewController.m
//  Slide picture
//
//  Created by intent on 17/08/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "ShowViewController.h"

@interface ShowViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pictureContent = [[NSMutableArray alloc] init];
    self.appDelegate =[AppDelegate new];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"PicturesInfo"];
    self.pictureContent = [[self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    self.pictureManagedObject = [self.pictureContent objectAtIndex:self.index];
    self.imageView.image = [UIImage imageWithData:[self.pictureManagedObject valueForKey:@"picture"]];
    
}

@end
