//
//  MTRMetronomeViewController.h
//  Metronome
//
//  Created by Yurii Kupratsevich on 10/24/17.
//

#import <UIKit/UIKit.h>

@interface MTRMetronomeViewController : UIViewController

@property (nonatomic) NSUInteger minBPM;
@property (nonatomic) NSUInteger maxBPM;
@property (nonatomic) NSUInteger currentBPM;

- (instancetype)initWithMinBPM:(NSUInteger)minBPM
                        maxBPM:(NSUInteger)maxBPM
                    currentBPM:(NSUInteger)currentBPM;

@end

