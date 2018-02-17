//
//  RecordingManager.h
//  TestmacOS
//
//  Created by Live on 2/15/18.
//  Copyright © 2018 Live. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
//@class AVCaptureSession;
//@class AVCaptureDeviceInput;
//@class AVCaptureAudioPreviewOutput;
//@class AVCaptureConnection;
//@class AVCaptureDevice;

@protocol RecordingManagerDelegate <NSObject>
@optional
- (void) didStartRecordingToOutputFileAt:(NSURL*) outputURL;
- (void) didPauseRecordingToOutputFileAt:(NSURL*) outputURL;
- (void) didResumeRecordingToOutputFileAt:(NSURL*) outputURL;
- (void) willFinishRecordingToOutputFileAt:(NSURL*) outputURL dueTo:(NSError*) error;
- (void) didFinishRecordingToOutputFileAt:(NSURL*) outputURL error:(NSError*) error;


@end

@interface RecordingManager : NSObject <AVCaptureFileOutputDelegate, AVCaptureFileOutputRecordingDelegate> {
    
    AVCaptureSession             *session;
    AVCaptureAudioFileOutput     *audioFileOutput;
    
    NSArray                      *audioDevices;
    NSArray                      *observers;
    NSMutableArray               *_audioInputs;
    NSMutableArray               *_audioInputConnectons;
    BOOL                         _verbose;
    
}
#pragma MARK Properties

@property (retain)                      AVCaptureSession    *session;
@property (assign, nonatomic)           id<RecordingManagerDelegate> delegate;

#pragma MARK Public methods
- (BOOL) isRecording;
- (void) startRecordingAtPath:(NSString *)filePath;
- (void) stopRecordingCompletionBlock:(void (^)(void))completionBlock ;

@end
