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

@property (weak, nonatomic) IBOutlet UIImageView *imageContainer;
@property NSUInteger countPictures;

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Model *m = [Model new];
    [m dataPictures];



    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    self.pageController.dataSource = self;

    [[self.pageController view] setFrame:[[self view] bounds]];

    ShowViewController *initialViewController = [self viewControllerAtIndex:0];

    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

  //  self.pageController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);

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

    if (index == NSNotFound)
        {
        return nil;
        }



    if (index == _countPictures)
        {
        return nil;
        }

index++;

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
