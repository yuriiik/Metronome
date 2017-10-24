//
//  MTRMetronome.m
//  Metronome
//
//  Created by Yurii Kupratsevich on 10/24/17.
//

#import "MTRMetronome.h"
#import "NSObject+MTRBundleManagement.h"

@import AVFoundation;

static double const kSampleRate = 44100.0;

typedef NS_ENUM(NSUInteger, MTRMetronomeState) {
    MTRMetronomeRunning,
    MTRMetronomeStopped,
    MTRMetronomeRestarting,
};

@interface MTRMetronome ()

@property (strong, nonatomic) AVAudioEngine *engine;
@property (strong, nonatomic) AVAudioPlayerNode *player;
@property (strong, nonatomic) dispatch_queue_t syncQueue;
@property (strong, nonatomic) AVAudioFile *file;
@property (strong, nonatomic) NSTimer *restartTimer;
@property (atomic) double nextBeatSampleTime;
@property (atomic) BOOL playerStarted;
@property (atomic) MTRMetronomeState state;

@end

@implementation MTRMetronome

#pragma mark - Private Methods

- (void)scheduleBeats {
    if (self.state != MTRMetronomeRunning) {
        return;
    }
    double secondsPerBeat = 60 / (double)self.tempo;
    double samplesPerBeat = secondsPerBeat * kSampleRate;
    AVAudioFramePosition beatSampleTime = (AVAudioFramePosition)self.nextBeatSampleTime;
    AVAudioTime *playerBeatTime = [[AVAudioTime alloc] initWithSampleTime:beatSampleTime atRate:kSampleRate];
    [self.player scheduleFile:self.file atTime:playerBeatTime completionHandler:^{
        dispatch_sync(self.syncQueue, ^{
            [self scheduleBeats];
        });
    }];
    if (!self.playerStarted) {
        [self.player play];
        self.playerStarted = YES;
    }
    self.nextBeatSampleTime += samplesPerBeat;
}

- (void)startByRestartTimer:(NSTimer *)timer {
    [self start];
}

- (void)restart {
    self.state = MTRMetronomeRestarting;
    [self.restartTimer invalidate];
    self.restartTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startByRestartTimer:) userInfo:nil repeats:NO];
}

#pragma mark - Public Methods

- (void)start {
    if (self.state == MTRMetronomeRunning) {
        return;
    }
    NSError *error = nil;
    [self.engine startAndReturnError:&error];
    if (!error) {
        self.state = MTRMetronomeRunning;
        self.nextBeatSampleTime = 0;
        dispatch_sync(self.syncQueue, ^{
            [self scheduleBeats];
        });
    }
}

- (void)stop {
    self.state = MTRMetronomeStopped;
    [self.player stop];
    [self.player reset];
    [self.engine stop];
    self.playerStarted = NO;
}

- (void)setTempo:(NSUInteger)tempo {
    if (_tempo != tempo) {
        _tempo = tempo;
        switch (self.state) {
            case MTRMetronomeRunning: {
                [self stop];
                [self restart];
                break;
            }
            case MTRMetronomeRestarting: {
                [self restart];
                break;
            }
            default:
            break;
        }
    }
}

- (BOOL)running {
    return (self.state == MTRMetronomeRunning);
}

#pragma mark - NSObject

- (instancetype)init {
    self = [super init];
    if (self) {
        _engine = [[AVAudioEngine alloc] init];
        _player = [[AVAudioPlayerNode alloc] init];
        [_engine attachNode:_player];
        [_engine connect:_player
                      to:_engine.outputNode
                 fromBus:0
                   toBus:0
                  format:nil];
        _syncQueue = dispatch_queue_create(NULL, nil);
        NSURL *fileURL = [[self bundleForName:@"Metronome"] URLForResource:@"metronome_click" withExtension:@"mp3"];
        _file = [[AVAudioFile alloc] initForReading:fileURL error:nil];
        _state = MTRMetronomeStopped;
    }
    return self;
}

@end
