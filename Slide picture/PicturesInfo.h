//
//  PicturesInfo.h
//  Slide picture
//
//  Created by intent on 23/08/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PicturesInfo : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * favourite;
@property (nonatomic, retain) NSNumber * idPicture;

@end
