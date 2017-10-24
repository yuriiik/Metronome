//
//  MTRViewController.m
//  Metronome
//
//  Created by kupratsevich@gmail.com on 10/24/2017.
//  Copyright (c) 2017 kupratsevich@gmail.com. All rights reserved.
//

#import "MTRViewController.h"
#import "MTRMetronomeViewController.h"

@interface MTRViewController ()

@property (strong, nonatomic) MTRMetronomeViewController *metronome;

@end

@implementation MTRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.metronome = [[MTRMetronomeViewController alloc] initWithMinBPM:10 maxBPM:100 currentBPM:50];
    [self.view addSubview:self.metronome.view];
    self.metronome.view.frame = self.view.bounds;
}

@end
