//
//  Model.m
//  Slide picture
//
//  Created by intent on 15/08/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "Model.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFNetworking.h"
#import "PicturesInfo.h"
#import "AppDelegate.h"

@implementation Model

- (void)dataPictures
{
    // Выгрузка данных из json-файла
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Pictures" ofType:@"json"]; // Получение адреса json-файла
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    // Получение бд Core Data
    AppDelegate *appDelegate = [AppDelegate new];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"PicturesInfo"];
    NSMutableArray *countPicture = [[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"array check %@", countPicture);

    // Проверка на содержание бд
    if ([countPicture count] == 0)
    {
        // Проверка на ошибку
        if ([NSJSONSerialization isValidJSONObject:json])
        {
            NSArray *dataPics = [json objectForKey:@"picture"]; // Все данные из json-файла

            [dataPics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) // Перебор массива данных
             {
                [self loadPictureFromUrl:[obj objectForKey:@"url"] idPicture:[obj objectForKey:@"id"]]; // Метод загрузки картинок из интернета и сохраненение в бд
             }];
        }
        else
            NSLog(@"Json error %@", error.description); // описание ошибки при работе json
    }
}

    // Метод загрузки картинок из интернета и сохраненение в бд
- (void)loadPictureFromUrl:(NSString *)urlAddress idPicture:(NSNumber *)idPict
{
    // Получение бд Core Data
    AppDelegate *appDelegate =[AppDelegate new];
    PicturesInfo *picturesInfo = [NSEntityDescription insertNewObjectForEntityForName:@"PicturesInfo"
                                                               inManagedObjectContext:appDelegate.managedObjectContext];

    dispatch_semaphore_t sema = dispatch_semaphore_create(0); // Создание семафора с одним исполняемым потоком (загрузкой данных из интернета)

    // Инициализация работы AFNetworking для работы с интернетом
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlAddress]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    requestOperation.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    // Получение данных из интернета
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"Url info %@", urlAddress);

        [[SDImageCache sharedImageCache] storeImage:responseObject forKey:[idPict stringValue]]; // Добавление в картинки в кэш

        NSError *error;

        [picturesInfo setValue:idPict forKey:@"idPicture"]; // Добавление id картинки в бд

        [appDelegate.managedObjectContext save:&error]; // Сохранение бд

        if (error)
            NSLog(@"Managed object context error: %@", error.description);  // Описание ошибки при сохранении бд

        dispatch_semaphore_signal(sema); // Увеличение значение семафора
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Image error: %@", error.description);  // Описание ошибки при загрузке данных из интернета
    
        dispatch_semaphore_signal(sema); // Увеличение значения семафора
    }];

    [requestOperation start]; // Запуск метода получения данных из интернета
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER); // Ожидание потока, до тех пора пока он не выполнится
}

@end
