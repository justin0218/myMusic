//
//  Songs.m
//  learn
//
//  Created by justin on 2019/4/30.
//  Copyright © 2019年 justin. All rights reserved.
//

#import "Songs.h"

@implementation UserEntity

    -(id)initWithName:(NSString *)name Phone:(NSString *)phone {
        self = [super init];
        if (self) {
            self.name = name;
            self.phone = phone;
        }
        return self;
    }

@end
