//
//  SettingsViewController.m
//  Slide picture
//
//  Created by intent on 18/08/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *automaticSlide;
@property (weak, nonatomic) IBOutlet UISwitch *showPicture;
@property (weak, nonatomic) IBOutlet UISwitch *showRandom;
@property (weak, nonatomic) IBOutlet UISwitch *showAnimation;
@property (weak, nonatomic) IBOutlet UILabel *labelAutomaticSlide;
@property (weak, nonatomic) IBOutlet UILabel *labelShowPicture;
@property (weak, nonatomic) IBOutlet UILabel *labelShowRandom;
@property (weak, nonatomic) IBOutlet UILabel *labelShowAnimation;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeInterval;
@property (weak, nonatomic) IBOutlet UIStepper *stepperOutlet;
- (IBAction)switchPressed:(id)sender;
- (IBAction)stepperAction:(id)sender;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Кнопки
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(save)];
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    self.stepperOutlet.value = [settings integerForKey:@"timeInterval"];
    self.labelTimeInterval.text = [NSString stringWithFormat:@"Через %i секунд(ы)", (int)self.stepperOutlet.value];
}

// Сохранение настроек
- (void)save
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:self.automaticSlide.isOn forKey:@"automaticSlide"];
    [settings setInteger:(NSInteger)self.stepperOutlet.value forKey:@"timeInterval"];
    //[settings setBool:self.automaticSlide.isOn forKey:@"automaticSlide"];
    [settings synchronize];
}

// Выход
- (void)back
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)switchPressed:(id)sender
{
    if (self.automaticSlide.on)
        {
        self.labelAutomaticSlide.text = @"Вкл. авт. смены картинок";
        self.stepperOutlet.enabled = true;
        self.labelTimeInterval.enabled = true;
        self.labelTimeInterval.text = [NSString stringWithFormat:@"Через %i секунд(ы)", (int)self.stepperOutlet.value];
        }
    else
        {
        self.labelAutomaticSlide.text = @"Выкл. авт. смены картинок";
        self.stepperOutlet.enabled = false;
        self.labelTimeInterval.enabled = false;
        self.labelTimeInterval.text = @"Время не доступно";
        }
}

- (IBAction)stepperAction:(id)sender
{
    self.labelTimeInterval.text = [NSString stringWithFormat:@"Через %i секунд(ы)", (int)self.stepperOutlet.value];
}
@end
