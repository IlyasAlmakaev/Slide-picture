//
//  ViewController.m
//  Slide picture
//
//  Created by intent on 15/08/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Model *m = [Model new];
    [m dataPictures];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
