//
//  PictureViewController.m
//  Slide picture
//
//  Created by intent on 16/08/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "PictureViewController.h"
#import "Model.h"
#import "ShowViewController.h"

@interface PictureViewController ()

@property NSUInteger countPictures;

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Model *m = [Model new];
    [m dataPictures];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(settingsUser)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\ue00e" style:UIBarButtonItemStylePlain target:self action:@selector(addFavourite)];


    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    self.pageController.dataSource = self;

    [[self.pageController view] setFrame:[[self view] bounds]];

    ShowViewController *initialViewController = [self viewControllerAtIndex:0];

    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    [self addChildViewController:_pageController];
    [self.view addSubview:_pageController.view];
    [self.pageController didMoveToParentViewController:self];

    _countPictures = [initialViewController.pictureContent count];
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = ((ShowViewController *)viewController).index;

    if ((_countPictures == 0) || (index >= _countPictures) || index == NSNotFound)
    {
        return nil;
    }

    index--;

    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = ((ShowViewController *)viewController).index;

    index++;
    
    if (index == NSNotFound)
        {
        return nil;
        }



    if (index == _countPictures)
        {
        return nil;
        }



    return [self viewControllerAtIndex:index];
}

- (ShowViewController *)viewControllerAtIndex:(NSUInteger *)index
{
    ShowViewController *showViewController = [[ShowViewController alloc] initWithNibName:@"ShowViewController" bundle:nil];
    showViewController.index = index;

    

    return showViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return _countPictures;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
