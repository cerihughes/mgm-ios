//
//  MGMCompletion.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 17/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

typedef void (^VOID_COMPLETION)(NSError*);
typedef void (^CREATION_COMPLETION)(id, NSError*);
typedef void (^FETCH_MANY_COMPLETION)(NSArray*, NSError*);
typedef CREATION_COMPLETION FETCH_COMPLETION;
