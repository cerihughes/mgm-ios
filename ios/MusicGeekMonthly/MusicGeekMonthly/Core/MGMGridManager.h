
#import <Foundation/Foundation.h>

@interface MGMGridManager : NSObject

+ (NSArray*) rectsForRowSize:(NSUInteger)rowSize defaultRectSize:(CGFloat)defaultRectSize count:(NSUInteger)count;

@end
