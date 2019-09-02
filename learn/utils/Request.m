//
//  Request.m
//  myapp
//
//  Created by justin on 2019/3/30.
//  Copyright © 2019年 justin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

@implementation NewRequest : NSObject

- (void)get:(NSString *)requesUrl callBack:(void (^)(NSDictionary *data))callBack {
    //创建URL对象
    NSURL *url = [[NSURL alloc] initWithString:requesUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        if(res.statusCode == 200 && error == nil){
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];//用一个字典接收返回来的数据
            callBack(dic);
        }else{
            callBack(@{@"code":@"error"});
        }
    }];
    [dataTask resume];
}

- (void)post:(NSString *)requestUrl param:(NSDictionary *)setParam callBack:(void (^)(NSDictionary *data))callBack
{
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    NSURL *url = [NSURL URLWithString:requestUrl];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //4.修改请求方法为POST
    request.HTTPMethod = @"POST";
    request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};
    
    NSDictionary *body = setParam;
    
    NSData *dd = [NSJSONSerialization dataWithJSONObject:body options:kNilOptions error:nil];
    
    //    [[NSString alloc]initWithData:dd encoding:NSUTF8StringEncoding];
    
    //5.设置请求体
    request.HTTPBody = [[[NSString alloc]initWithData:dd encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding];
    
    //6.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        //NSLog(@"%ld====code",(long)res.statusCode);
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];//用一个字典接收返回来的数据
        if(res.statusCode == 200 && error == nil){
            callBack(dic);
        }else{
            callBack(dic);
        }
        
        //8.解析数据
        // NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        //NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]); 
    }];
    
    //7.执行任务
    [dataTask resume];
}


@end

