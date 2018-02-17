//
//  AudioRecordingController.swift
//  Audio Capture
//
//  Created by Satendra Dagar on 28/12/17.
//  Copyright © 2017 CB. All rights reserved.
//

import Foundation
import AVFoundation

class AVAudioRecordingController: NSObject {
//    var recordingSession: AVAudioSession?

    var recordManager = RecordingManager()
    
    var recorder: AVAudioRecorder?

    override init() {
        super.init()
        
    }
    // MARK: Instance methods
    func createRecorder() {
        var initialisedRecorder: AVAudioRecorder?
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy HHmmss"
        let fileName = "/Recording on " + dateFormatter.string(from: currentDate as Date) + ".\(captureExtension)"
        let recordingPath = RecordingStoreManager.capturesRootPath()+fileName
        let url = NSURL(fileURLWithPath: recordingPath)
        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                              AVEncoderBitRateKey: 16,
                              AVNumberOfChannelsKey: 2,
                              AVFormatIDKey: kAudioFormatAppleIMA4,
                              AVSampleRateKey: 44100.0] as [String : Any]
        do {
            initialisedRecorder = try AVAudioRecorder(url: url as URL, settings: recordSettings)
        }catch {
            print("nope\(error)")
        }
        initialisedRecorder!.isMeteringEnabled = true
        initialisedRecorder!.prepareToRecord()
        recorder = initialisedRecorder
    }
    
    func createRecorderFromMix() {
        recordManager = RecordingManager()
        recordManager.delegate = self;
    }

//    func isRecording() -> Bool {
//
//        if let recordr = recorder {
//            return recordr.isRecording
//        }
//        return false;
//    }
    
    func startRecording()  {
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy HHmmss"
        let fileName = "/Recording on " + dateFormatter.string(from: currentDate as Date) + ".\(captureExtension)"
        let recordingPath = RecordingStoreManager.capturesRootPath()+fileName
//        let url = NSURL(fileURLWithPath: recordingPath)
        recordManager.startRecording(atPath: recordingPath)
    }

    func stopRecording()  {
        recordManager.stopRecordingCompletionBlock {
            print("Stopped called")
        }
    }

    func isRecording() -> Bool {
        
        return recordManager.isRecording()
    }
}

extension AVAudioRecordingController: RecordingManagerDelegate{
    
    func didStartRecordingToOutputFile(at outputURL: URL!) {
        print("Function: \(#function), line: \(#line)")

    }
    
    func didPauseRecordingToOutputFile(at outputURL: URL!) {
        print("Function: \(#function), line: \(#line)")

    }
    
    func didResumeRecordingToOutputFile(at outputURL: URL!) {
        print("Function: \(#function), line: \(#line)")

    }
    
    func didFinishRecordingToOutputFile(at outputURL: URL!, error: Error!) {
        print("Function: \(#function), line: \(#line)")

    }
}
