//
//  User.h
//  pinterestWithRealm
//
//  Created by Reshma on 01/04/15.
//  Copyright (c) 2015 ruvlmoon. All rights reserved.
//

#import "RLMObject.h"
#import <Realm/Realm.h>

RLM_ARRAY_TYPE(photoDetails)

@interface User : RLMObject
@property (nonatomic) NSString *UserId;
@property (nonatomic) RLMArray<photoDetails> *userPhoto;
@end
