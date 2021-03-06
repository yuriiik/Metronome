//
//  MTRMetronomeViewController.m
//  Metronome
//
//  Created by Yurii Kupratsevich on 10/24/17.
//

#import "MTRMetronomeViewController.h"
#import "MTRMetronome.h"
#import "MTRMetronomeButton.h"
#import "NSObject+MTRBundleManagement.h"

@import AVFoundation;

static NSUInteger const kMinAllowedBPM = 10;
static NSUInteger const kMaxAllowedBPM = 500;

@interface MTRMetronomeViewController ()

@property (strong, nonatomic) MTRMetronome *metronome;
@property (weak, nonatomic) IBOutlet UISlider *BPMSlider;
@property (weak, nonatomic) IBOutlet UILabel *minBPMLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxBPMLabel;
@property (weak, nonatomic) IBOutlet MTRMetronomeButton *startMetronomeButton;

@end

@implementation MTRMetronomeViewController

#pragma mark - Public Methods

- (void)setMinBPM:(NSUInteger)minBPM {
    if (minBPM < self.maxBPM) {
        _minBPM = minBPM;
        self.BPMSlider.minimumValue = minBPM;
        self.minBPMLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)minBPM];
        if (self.currentBPM < minBPM) {
            self.currentBPM = minBPM;
        }
    }
}

- (void)setMaxBPM:(NSUInteger)maxBPM {
    if (maxBPM > self.minBPM) {
        _maxBPM = maxBPM;
        self.BPMSlider.maximumValue = maxBPM;
        self.maxBPMLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)maxBPM];
        if (self.currentBPM > maxBPM) {
            self.currentBPM = maxBPM;
        }
    }
}

- (void)setCurrentBPM:(NSUInteger)currentBPM {
    if ((currentBPM != _currentBPM) && [self isValidCurrentBPM:currentBPM]) {
        _currentBPM = currentBPM;
        self.metronome.tempo = currentBPM;
        self.BPMSlider.value = currentBPM;
        self.startMetronomeButton.displayedBPM = currentBPM;
    }
}

#pragma mark - Private Methods

- (BOOL)isValidCurrentBPM:(NSUInteger)currentBPM {
    return (currentBPM >= _minBPM &&
            currentBPM <= _maxBPM);
}

#pragma mark - Initializers

- (instancetype)initWithMinBPM:(NSUInteger)minBPM
                        maxBPM:(NSUInteger)maxBPM
                    currentBPM:(NSUInteger)currentBPM {
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:[self bundleForName:@"Metronome"]];
    if (self) {
        _minBPM = (minBPM >= kMinAllowedBPM) ? minBPM : kMinAllowedBPM;
        _maxBPM = (maxBPM <= kMaxAllowedBPM) && (maxBPM > minBPM) ? maxBPM : kMaxAllowedBPM;
        _currentBPM = [self isValidCurrentBPM:currentBPM] ? currentBPM : _minBPM;
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.BPMSlider.minimumValue = self.minBPM;
    self.BPMSlider.maximumValue = self.maxBPM;
    self.BPMSlider.value = self.currentBPM;
    
    self.minBPMLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.minBPM];
    self.maxBPMLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.maxBPM];
    self.startMetronomeButton.displayedBPM = self.currentBPM;
    
    self.metronome = [[MTRMetronome alloc] init];
    self.metronome.tempo = self.currentBPM;
}

#pragma mark - IBAction

- (IBAction)play:(MTRMetronomeButton *)sender {
    sender.on ? [self.metronome start] : [self.metronome stop];
}

- (IBAction)updateBPM:(UISlider *)sender {
    double roundedBPMValue = round(self.BPMSlider.value);
    self.metronome.tempo = roundedBPMValue;
    _currentBPM = roundedBPMValue;
    self.startMetronomeButton.displayedBPM = roundedBPMValue;
}

- (void)dealloc {
    [self.metronome stop];
    self.metronome = nil;
}

@end
