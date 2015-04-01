//
//  photoDetails.m
//  pinterestWithRealm
//
//  Created by Reshma on 01/04/15.
//  Copyright (c) 2015 ruvlmoon. All rights reserved.
//

#import "photoDetails.h"

@implementation photoDetails
-(NSString *)primaryKey {
    return @"title";
}

@end
RLM_ARRAY_TYPE(photoDetails)
