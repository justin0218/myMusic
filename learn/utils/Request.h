//
//  Request.h
//  myapp
//
//  Created by justin on 2019/3/30.
//  Copyright © 2019年 justin. All rights reserved.
//

@interface NewRequest : NSObject{
    //私有
}

- (void)get:(NSString *)requesUrl callBack:(void (^)(NSDictionary *data))callBack;
- (void)post:(NSString *)requestUrl param:(NSDictionary *)setParam callBack:(void (^)(NSDictionary *data))callBack;
@end

