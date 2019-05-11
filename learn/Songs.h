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
    @property(nonatomic,strong)NSString *url;
    @property(nonatomic)NSNumber *songId;
    @property(nonatomic)NSString *singer;

    -(id)initWithName:(NSString *)name Phone:(NSString *)phone Url:(NSString *)url SongId:(NSNumber *)songId Singer:(NSString *)singer;
@end

#endif /* Songs_h */
