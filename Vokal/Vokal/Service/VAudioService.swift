//
//  VAudioService.swift
//  Vokal
//
//  Created by Bhabani on 14/03/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation
import AVFoundation

class VAudioService: NSObject {
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder?
    private var audioPayler: AVAudioPlayer?
    
    dynamic private(set) var isRecordingAllowed = false
    dynamic private(set) var isRecording = false
    dynamic fileprivate(set) var isPlaying = false
    private(set) var currentAudioId: String?
    
    static let sharedInstance = VAudioService()
    
    private  override init() {
        super.init()
        recordingSession = AVAudioSession.sharedInstance()
        
        try? recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try? recordingSession.setActive(true)
        recordingSession.requestRecordPermission() { [unowned self] allowed in
            self.isRecordingAllowed = allowed
        }
    }
    
    func playAudio(withIdentifier identifier: String) {
        if (!isRecording) {
            
            if let audioPayler = audioPayler,  audioPayler.isPlaying{
                audioPayler.stop()
                isPlaying = false
            }else{
                currentAudioId = identifier
                let name =  identifier + ".m4a"
                let audioFilename = getDocumentsDirectory().appendingPathComponent(name)
                audioPayler = try? AVAudioPlayer(contentsOf: audioFilename)
                audioPayler?.delegate = self
                audioPayler?.play()
                isPlaying =  true
            }
        }
    }
    
    func recordAudio(withIdentifier identifier: String) {
        currentAudioId = identifier
        let name =  identifier + ".m4a"
        if audioRecorder == nil {
            startRecording(withName: name)
        } else {
            finishRecording(success: true)
        }
    }
    
    private func startRecording(withName name: String) {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(name)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            isRecording = true
        } catch {
            finishRecording(success: false)
        }
    }
    
    private func record(withName name: String) {
        if let audioPayler = audioPayler {
            if audioPayler.isPlaying {
                audioPayler.stop()
            }
        }
        
        if audioRecorder == nil {
            startRecording(withName: name)
        } else {
            finishRecording(success: true)
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    fileprivate func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil
        isRecording = false
    }
}

extension VAudioService: AVAudioRecorderDelegate {
    internal func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        finishRecording(success: flag)
    }
}

extension VAudioService: AVAudioPlayerDelegate {
    
    internal func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying =  false
    }
}
