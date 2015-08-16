//
//  Model.m
//  Slide picture
//
//  Created by intent on 15/08/15.
//  Copyright (c) 2015 intent. All rights reserved.
//

#import "Model.h"
#import "AFNetworking.h"

@implementation Model

- (void)dataPictures
{
        // Выгрузка данных из json-файла
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Pictures" ofType:@"json"];// Получение адреса json-файла
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        // Проверка на ошибку
    if ([NSJSONSerialization isValidJSONObject:json])
        {
        NSArray *dataPics = [json objectForKey:@"picture"]; // Все данные из json-файла
        NSMutableArray *idPics = [NSMutableArray new];      // массив для id
        NSMutableArray *numberPics = [NSMutableArray new];  // массив для номеров картинок
        NSMutableArray *urlPics = [NSMutableArray new];     // массив для url картинок
                                                            // Перебор массива данных
        [dataPics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             // Группировка данных для массивов
         [idPics addObject:[obj objectForKey:@"id"]];
         [numberPics addObject:[obj objectForKey:@"number"]];
         [urlPics addObject:[obj objectForKey:@"url"]];

         NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[obj objectForKey:@"url"]]];
         AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
         requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
         [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"Response: %@", responseObject);
                 //          _imageView.image = responseObject;

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Image error: %@", error);
         }];
         [requestOperation start];


         }];
        NSLog(@"id info %@ number info %@ Url info %@", idPics, numberPics, urlPics);
        }
    else
        {
        NSLog(@"Error %@", error.description); // описание ошибки
        }
}

@end
