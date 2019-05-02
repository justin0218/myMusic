//
//  Songs.h
//  learn
//
//  Created by justin on 2019/4/30.
//  Copyright © 2019年 justin. All rights reserved.
//
#import <Foundation/Foundation.h>
#ifndef Songs_h
#define Songs_h

@interface UserEntity : NSObject
    @property(nonatomic,strong)NSString *name;
    @property(nonatomic,strong)NSString *phone;
    -(id)initWithName:(NSString *)name Phone:(NSString *)phone;
@end

#endif /* Songs_h */
