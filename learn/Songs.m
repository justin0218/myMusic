//
//  Songs.m
//  learn
//
//  Created by justin on 2019/4/30.
//  Copyright © 2019年 justin. All rights reserved.
//

#import "Songs.h"

@implementation UserEntity

-(id)initWithName:(NSString *)name Phone:(NSString *)phone Url:(NSString *)url SongId:(NSNumber *)songId Singer:(NSString *)singer{
        self = [super init];
        if (self) {
            self.name = name;
            self.phone = phone;
            self.url = url;
            self.songId = songId;
            self.singer = singer;
        }
        return self;
}

@end
