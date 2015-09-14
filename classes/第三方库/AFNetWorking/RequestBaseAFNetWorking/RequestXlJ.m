//
//  RequestXlJ.m
//  时时投
//
//  Created by 熊良军 on 15/8/7.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "RequestXlJ.h"
#warning 该类仅用于“维度”APP

@implementation RequestXlJ
- (void)requestWithUrl:(NSString *)urlStr methed:(NSString *)get_or_Post  block:(Block)block{
    _block = block;
    if ([get_or_Post isEqualToString:@"get"]||[get_or_Post isEqualToString:@"GET"]||[get_or_Post isEqualToString:@"Get"]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSDictionary *dic = [responseObject objectForKey:@"data"];
                NSArray *array = [responseObject objectForKey:@"data"];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    _block(0,nil,dic,nil);
                }else{
                  _block(0,nil,nil,array);
                }
            }else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                _block(1,error,nil,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            _block(1,nil,nil,nil);
        
        }];
    }else if ([get_or_Post isEqualToString:@"post"]||[get_or_Post isEqualToString:@"POST"]||[get_or_Post isEqualToString:@"Post"]){
        AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"foo": @"bar"};
        [manager1 POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"JSON2: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSDictionary *dic = [responseObject objectForKey:@"data"];
                NSArray *array = [responseObject objectForKey:@"data"];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    _block(0,nil,dic,nil);
                }else{
                    _block(0,nil,nil,array);
                }
            }else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                _block(1,error,nil,nil);
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            _block(1,nil,nil,nil);
        }];
    
    }else{
        AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"foo": @"bar"};
        [manager1 POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"JSON2: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSDictionary *dic = [responseObject objectForKey:@"data"];
                NSArray *array = [responseObject objectForKey:@"data"];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    _block(0,nil,dic,nil);
                }else{
                    _block(0,nil,nil,array);
                }
            }else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                _block(1,error,nil,nil);
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
          
            _block(1,nil,nil,nil);
        }];
    
    }
    
}
- (void)requestWithUrlHead:(NSMutableString *)urlHead parameter:(NSArray *)paraArray  methed:(NSString *)get_or_Post  block:(Block)block{
    _block = block;
    NSMutableString *urlstr = urlHead;
    for (int i = 0;i < paraArray.count;i ++){
        NSString *str;
        if (i != paraArray.count - 1) {
            str = [NSString stringWithFormat:@"%@&",[paraArray objectAtIndex:i]];
        }else{
            str = [paraArray objectAtIndex:i];
        }
        [urlstr appendString:str];
    }
    NSLog(@"urlstr = %@",urlstr);
    
    if ([get_or_Post isEqualToString:@"get"]||[get_or_Post isEqualToString:@"GET"]||[get_or_Post isEqualToString:@"Get"]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlstr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSDictionary *dic = [responseObject objectForKey:@"data"];
                NSArray *array = [responseObject objectForKey:@"data"];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    _block(0,nil,dic,nil);
                }else{
                    _block(0,nil,nil,array);
                }
            }else if (![code isEqualToString:@"0"]){
                 NSString *error = [responseObject objectForKey:@"err"];
                _block(1,error,nil,nil);
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            _block(1,nil,nil,nil);
            
        }];
    }else if ([get_or_Post isEqualToString:@"post"]||[get_or_Post isEqualToString:@"POST"]||[get_or_Post isEqualToString:@"Post"]){
        AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
        //NSDictionary *parameters = @{@"foo": @"bar"};
        [manager1 POST:urlHead parameters:paraArray success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"JSON2: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSDictionary *dic = [responseObject objectForKey:@"data"];
                NSArray *array = [responseObject objectForKey:@"data"];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    _block(0,nil,dic,nil);
                }else{
                    _block(0,nil,nil,array);
                }
            }else if (![code isEqualToString:@"0"]){
                 NSString *error = [responseObject objectForKey:@"err"];
                _block(1,error,nil,nil);
            }
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            _block(1,nil,nil,nil);
        }];
        
    }else{
        AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
        //NSDictionary *parameters = @{@"foo": @"bar"};
        [manager1 POST:urlHead parameters:paraArray success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"JSON2: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSDictionary *dic = [responseObject objectForKey:@"data"];
                NSArray *array = [responseObject objectForKey:@"data"];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    _block(0,nil,dic,nil);
                }else{
                    _block(0,nil,nil,array);
                }
            }else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                _block(1,error,nil,nil);
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            _block(1,nil,nil,nil);
        }];
    }
}
@end
