//
//  ShowViewController.h
//  Slide picture
//
//  Created by intent on 17/08/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ShowViewController : UIViewController

@property (nonatomic) NSMutableArray *pictureContent;
@property (nonatomic) NSManagedObject *pictureManagedObject;
@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet UILabel *labelComment;

@end
