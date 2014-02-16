
#import <Foundation/Foundation.h>

@interface MGMGridManager : NSObject

+ (NSArray*) rectsForRows:(NSUInteger)rows columns:(NSUInteger)columns size:(CGFloat)size count:(NSUInteger)count;

@end
