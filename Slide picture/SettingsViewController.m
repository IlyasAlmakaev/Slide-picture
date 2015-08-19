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
@property (weak, nonatomic) IBOutlet UITextField *timeIntervalField;
- (IBAction)switchPressed:(id)sender;

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
}

// Сохранение настроек
- (void)save
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:self.automaticSlide.isOn forKey:@"automaticSlide"];
    [settings setInteger:[self.timeIntervalField.text intValue] forKey:@"timeInterval"];
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
        self.timeIntervalField.enabled = true;
        self.labelTimeInterval.enabled = true;
        }
    else
        {
        self.labelAutomaticSlide.text = @"Выкл. авт. смены картинок";
        self.timeIntervalField.enabled = false;
        self.labelTimeInterval.enabled = false;
        }
}
@end
