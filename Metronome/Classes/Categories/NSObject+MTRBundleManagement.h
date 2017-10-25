//
//  NSObject+MTRBundleManagement.h
//  Metronome
//
//  Created by Yurii Kupratsevich on 10/25/17.
//

#import <Foundation/Foundation.h>

@interface NSObject (MTRBundleManagement)

- (NSBundle *)bundleForName:(NSString *)bundleName;

@end
