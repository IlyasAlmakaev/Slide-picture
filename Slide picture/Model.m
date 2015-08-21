//
//  Model.m
//  Slide picture
//
//  Created by intent on 15/08/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "Model.h"
#import "AFNetworking.h"
#import "PicturesInfo.h"
#import "AppDelegate.h"

@implementation Model

- (void)dataPictures
{

        // Выгрузка данных из json-файла
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Pictures" ofType:@"json"];// Получение адреса json-файла
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    AppDelegate *appDelegate = [AppDelegate new];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"PicturesInfo"];
    NSMutableArray *countPicture = [[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"array check %@", countPicture);
    // Проверка на содержание базы данных
    if ([countPicture count] == 0)
        {

        // Проверка на ошибку
        if ([NSJSONSerialization isValidJSONObject:json])
            {

            NSArray *dataPics = [json objectForKey:@"picture"]; // Все данные из json-файла


            [dataPics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) // Перебор массива данных
             {

             // метод загрузки картинок из интернета
             [self loadPictureFromUrl:[obj objectForKey:@"url"] idPicture:[obj objectForKey:@"id"] numberPicture:[obj objectForKey:@"number"]];

             }];
            //    NSLog(@"id info %@ number info %@ Url info %@", idPics, numberPics, urlPics);
            }
        else
            {
            NSLog(@"Json error %@", error.description); // описание ошибки
            }
    }
NSLog(@"data picture go");
}

    // Загрузка картинок из интернета
- (void)loadPictureFromUrl:(NSString *)urlAddress idPicture:(NSNumber *)idPict numberPicture:(NSNumber *)numberPict
{

    AppDelegate *appDelegate =[AppDelegate new];
    PicturesInfo *picturesInfo = [NSEntityDescription insertNewObjectForEntityForName:@"PicturesInfo"
                                                               inManagedObjectContext:appDelegate.managedObjectContext];

    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlAddress]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    requestOperation.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
    NSLog(@"Url info %@", urlAddress);
        // Добавление в картинки в базу данных
        NSData *imageData = UIImagePNGRepresentation(responseObject);
    NSError *error;
        [picturesInfo setValue:idPict forKey:@"idPicture"];
        [picturesInfo setValue:numberPict forKey:@"number"];
        [picturesInfo setValue:imageData forKey:@"picture"];
        NSLog(@"Response: %@", imageData);
    [appDelegate.managedObjectContext save:&error];
    if (error)
    {
        NSLog(@"Managed object context error: %@", error.description);  // описание ошибки
    }
    dispatch_semaphore_signal(sema);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Image error: %@", error.description);  // описание ошибки
    dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    [requestOperation start];

}

@end
