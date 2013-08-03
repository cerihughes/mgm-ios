//
//  MGMLogging.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 03/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "TestFlight.h"

#define NSLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
