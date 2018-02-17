//
//  RecordingManager.m
//  TestmacOS
//
//  Created by Live on 2/15/18.
//  Copyright © 2018 Live. All rights reserved.
//

#import "RecordingManager.h"

@implementation RecordingManager
@synthesize session;

- (id) init {
    
    if (self = [super init]) {
        [self initilizeSession];
    }
    return self;
}

- (void) initilizeSession {
    
    session = [[AVCaptureSession alloc] init];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    id runtimeErrorObserver = [notificationCenter addObserverForName:AVCaptureSessionRuntimeErrorNotification object:self.session queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            NSLog(@"err: %@",[[note userInfo] objectForKey:AVCaptureSessionErrorKey]);
        });
    }];
    id didStartRunningObserver = [notificationCenter addObserverForName:AVCaptureSessionDidStartRunningNotification object:self.session queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        if (_verbose) { NSLog(@"did start running"); }
    }];
    id didStopRunningObserver = [notificationCenter addObserverForName:AVCaptureSessionDidStopRunningNotification object:self.session queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSLog(@"did stop running");
    }];
    id deviceWasConnectedObserver = [notificationCenter addObserverForName:AVCaptureDeviceWasConnectedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    }];
    id deviceWasDisconnectedObserver = [notificationCenter addObserverForName:AVCaptureDeviceWasDisconnectedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    }];
    observers = [[NSArray alloc] initWithObjects:runtimeErrorObserver, didStartRunningObserver, didStopRunningObserver, deviceWasConnectedObserver, deviceWasDisconnectedObserver, nil];
    
    audioFileOutput = [[AVCaptureAudioFileOutput alloc] init];
    [audioFileOutput setDelegate:self];
    [session addOutput:audioFileOutput];
    
    AVCaptureDevice *selectedAudioDevice = nil;
    selectedAudioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    audioDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    
    [[self session] beginConfiguration];
    
    _audioInputs = [NSMutableArray arrayWithCapacity:0];
    NSError *error = nil;
    for (AVCaptureDevice *audioDevice in audioDevices) {
        if ([audioDevice hasMediaType:AVMediaTypeMuxed]){
            ;
        }else if([audioDevice hasMediaType:AVMediaTypeAudio]) {
            AVCaptureDeviceInput *newAudioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
            if (![selectedAudioDevice supportsAVCaptureSessionPreset:[session sessionPreset]]) {
                [[self session] setSessionPreset:AVCaptureSessionPresetHigh];
            }
            [[self session] addInput:newAudioDeviceInput];
            [_audioInputs addObject:newAudioDeviceInput];
        }
    }
    
    [[self session] commitConfiguration];
    
}

- (BOOL) isRecording {
    
    return [audioFileOutput isRecording];
    
}

- (void) startRecordingAtPath:(NSString *)filePath {
    [[self session] startRunning];
    //Preparing file url for storing file and others
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithUnsignedInt:kAudioFormatLinearPCM],AVFormatIDKey,
                              [NSNumber numberWithFloat:48000.0],AVSampleRateKey,
                              nil];
    @try {
        [audioFileOutput setAudioSettings:settings];
        [audioFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:filePath] outputFileType:AVFileTypeWAVE recordingDelegate:self];
        
    } @catch (NSException *exception) {
        NSLog(@"%@_%@", ([exception description] && [[exception description] length] > 0)?[exception description]:@"", [exception debugDescription]?[exception debugDescription]:@"?");
    } @finally {
        
    }
}

- (void)stopRecordingCompletionBlock:(void (^)(void))completionBlock {
    
    if (audioFileOutput){
        [audioFileOutput stopRecording];
    }
    
    if ([[self session] isRunning]){
        [[self session] stopRunning];
    }
    completionBlock();
}

#pragma mark - Delegate methods

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    if([_delegate respondsToSelector:@selector(didStartRecordingToOutputFileAt:)]) {
        [_delegate didStartRecordingToOutputFileAt:fileURL];
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didPauseRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    if([_delegate respondsToSelector:@selector(didPauseRecordingToOutputFileAt:)]) {
        [_delegate didPauseRecordingToOutputFileAt:fileURL];
    }
    NSLog(@"Did pause recording to %@", [fileURL description]);
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didResumeRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    if([_delegate respondsToSelector:@selector(didResumeRecordingToOutputFileAt:)]) {
        [_delegate didResumeRecordingToOutputFileAt:fileURL];
    }
    NSLog(@"Did resume recording to %@", [fileURL description]);
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput willFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections dueToError:(NSError *)error
{
    if([_delegate respondsToSelector:@selector(willFinishRecordingToOutputFileAt:dueTo:)]) {
        [_delegate willFinishRecordingToOutputFileAt:fileURL dueTo:error];
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)recordError {
    if([_delegate respondsToSelector:@selector(didFinishRecordingToOutputFileAt:error:)]) {
        [_delegate didFinishRecordingToOutputFileAt:outputFileURL error:recordError];
    }
}

- (void) captureOutput:(AVCaptureFileOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
//    NSLog(@"sampleBuffersampleBuffer");
}

- (BOOL)captureOutputShouldProvideSampleAccurateRecordingStart:(AVCaptureOutput *)captureOutput {
    return NO;
}

@end
