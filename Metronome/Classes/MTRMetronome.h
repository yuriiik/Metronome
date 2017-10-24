//
//  MTRMetronome.h
//  Metronome
//
//  Created by Yurii Kupratsevich on 10/24/17.
//

#import <Foundation/Foundation.h>

@interface MTRMetronome : NSObject

@property (nonatomic) NSUInteger tempo;
@property (nonatomic, readonly) BOOL running;

- (void)start;
- (void)stop;

@end
