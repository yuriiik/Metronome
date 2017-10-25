//
//  NSObject+MTRBundleManagement.m
//  Metronome
//
//  Created by Yurii Kupratsevich on 10/25/17.
//

#import "NSObject+MTRBundleManagement.h"

@implementation NSObject (MTRBundleManagement)

- (NSBundle *)bundleForName:(NSString *)bundleName {
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    NSURL *bundleURL = [bundle URLForResource:bundleName withExtension:@"bundle"];
    return [NSBundle bundleWithURL:bundleURL];
}

@end
