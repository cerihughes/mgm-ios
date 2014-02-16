//
//  MGMData.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGMData : NSObject

@property (strong) id data;
@property (strong) NSError* error;

- (id) initWithError:(NSError*)error;

@end
