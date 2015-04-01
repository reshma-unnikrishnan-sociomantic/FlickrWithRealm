//
//  photoDetails.h
//  pinterestWithRealm
//
//  Created by Reshma on 01/04/15.
//  Copyright (c) 2015 ruvlmoon. All rights reserved.
//

#import "RLMObject.h"

@interface photoDetails : RLMObject
@property (nonatomic) NSString *title;
@property (nonatomic) BOOL isFamily;
@property (nonatomic) NSString *flickrPicture;

@end
