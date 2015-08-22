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
#import "AppDelegate.h"
#import "SettingsViewController.h"

@interface PictureViewController ()

@property NSUInteger countPictures;
@property (assign, nonatomic) NSInteger indexCurrent;
@property (nonatomic) NSString *animationMode;
@property (nonatomic) NSTimer *timePic;
@property (nonatomic) NSMutableArray *pictureContent;
@property (nonatomic) NSManagedObject *pictureManagedObject;
@property (nonatomic) AppDelegate *appDelegate;
@property (nonatomic) ShowViewController *showViewController;


@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"work");

    self.appDelegate = [AppDelegate new];
    self.showViewController = [ShowViewController new];

    Model *m = [Model new];
    [m dataPictures];

    // Кнопки Navigation bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(settingsUser)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\ue00e" style:UIBarButtonItemStylePlain target:self action:@selector(addFavourite)];

   // [self pageViewStart]; // Создание Page View Controller

 //   _countPictures = [initialViewController.pictureContent count]; // количество картинок в базе данных
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self getCount]; // Получение количества картинок

    [self pageViewStart]; // Создание Page View Controller

 //   self.indexCurrent = initialViewController.index;

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    [self pageViewReload]; // Обновление PageViewController

    // Остановка таймера
    [self.timePic invalidate];
    self.timePic = nil;
    
    if ([settings boolForKey:@"automaticSlide"])
    // Запуск таймера
    self.timePic = [NSTimer scheduledTimerWithTimeInterval:[settings integerForKey:@"timeInterval"]
                                                   target:self
                                                 selector:@selector(nextShowViewController)
                                                 userInfo:nil
                                                  repeats:YES];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = ((ShowViewController *)viewController).index;

    if ((index == 0) || (index == NSNotFound))
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

    if ((index + 1 > _countPictures) || (index == NSNotFound))
        {
        return nil;
        }

    return [self viewControllerAtIndex:index];
}

- (ShowViewController *)viewControllerAtIndex:(NSUInteger *)index
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if ([settings boolForKey:@"showCertain"] && _countPictures)
        {
        index = (arc4random() % _countPictures);
        }
    ShowViewController *showViewController = [[ShowViewController alloc] initWithNibName:@"ShowViewController" bundle:nil];
    showViewController.index = index;
    NSLog(@"index current %i", (int)index);
   // self.indexCurrent = index;

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

// Обработчик нажатия кнопок в AlertView
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        {
        self.indexCurrent = [[self.pageController.viewControllers lastObject] index];
        NSLog(@"index alertView 1 %i", (int)self.indexCurrent);
        NSString *test = [[alertView textFieldAtIndex:0] text]; // комментарий пользователя
        NSError *error;
        self.pictureManagedObject = [self.pictureContent objectAtIndex:self.indexCurrent];

        [self.pictureManagedObject setValue:@YES forKey:@"favourite"]; // Добавление картинки в favourite
        NSLog(@"bool test %@",[self.pictureManagedObject valueForKey:@"favourite"]);

        // Проверка на пустое поле
        if (test && test.length > 0 && [test stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
            {
            [self.pictureManagedObject setValue:test forKey:@"comment"]; // Добавление комментария для картинки

            NSLog(@"text alert view core data %@", [self.pictureManagedObject valueForKey:@"comment"]);
            }

        [self.appDelegate.managedObjectContext save:&error]; // Сохранение данных в базу

        if (error)
            {
            NSLog(@"Managed object context error: %@", error.description);  // описание ошибки сохранения в базу
            }

        // Обновление комментария
        [self pageViewReload];
        }
    
}

// Метод добавления картинки в favourites
- (void)addFavourite
{
    UIAlertView *alertViewChangeName = [[UIAlertView alloc]initWithTitle:@"Добавить картинку в favorites?"
                                                               message:@"Вы можете прокомментировать."
                                                              delegate:self
                                                     cancelButtonTitle:@"Да"
                                                     otherButtonTitles:@"Нет", nil];

    alertViewChangeName.alertViewStyle = UIAlertViewStylePlainTextInput;

    [alertViewChangeName show];
}

// Метод перехода в окно настроек
- (void)settingsUser
{
    // Остановка автоматической смены картинок
    [self.timePic invalidate];
    self.timePic = nil;

    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];

    UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    settingsNavigationController.navigationBar.translucent = NO;
    [self.navigationController presentViewController:settingsNavigationController
                                            animated:YES
                                          completion:nil];
}

// Метод перехода на следующую картинку
- (void)nextShowViewController
{
    if (self.indexCurrent + 1 == _countPictures )
    {
    self.indexCurrent = 0;
    
    }
    ShowViewController *initialViewController = [self viewControllerAtIndex:self.indexCurrent + 1];

    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.indexCurrent++;
}

// Получение количества картинок
- (void)getCount
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    // Запрос данных из базы
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


    NSLog(@"count viewWillApear massive %i", (int)[self.pictureContent count]);
    _countPictures = (int)[self.pictureContent count];
}

// Создание Page View Controller
- (void)pageViewStart
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    if ([settings boolForKey:@"showAnimation"])
        self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    else
        self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    self.pageController.dataSource = self;

    [[self.pageController view] setFrame:[[self view] bounds]];

    [self pageViewReload];

    [self addChildViewController:_pageController];
    [self.view addSubview:_pageController.view];
    [self.pageController didMoveToParentViewController:self];

}

// Обновление Page View Controller
- (void)pageViewReload
{
    ShowViewController *initialViewController = [self viewControllerAtIndex:self.indexCurrent];

    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];

    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    NSLog(@"count testobject %i", (int)[initialViewController.pictureContent count]);
    NSLog(@"index log %i", (int)initialViewController.index);
}

@end
