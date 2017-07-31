#import <Foundation/Foundation.h>
#import "AlbumObject.h"

@interface AlbumDelegateProxy : NSObject

@property(atomic,assign) id<AlbumDelegate> delegate;

@end
