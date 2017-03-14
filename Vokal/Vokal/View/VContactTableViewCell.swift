//
//  VContactTableViewCell.swift
//  Vokal
//
//  Created by Bhabani on 14/03/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import UIKit

class VContactTableViewCell: UITableViewCell {
    
    struct Static {
        static let isRecordingAllowed = "isRecordingAllowed"
        static let isRecording = "isRecording"
        static let isPlaying = "isPlaying"
    }
    
    var cellModel: VContactCellModel? {
        didSet{
            contactNameLabel.text = cellModel?.name
            contactImageView.image = cellModel?.image
            
            recordButtonButton.isEnabled = VAudioService.sharedInstance.isRecordingAllowed &&
                (!VAudioService.sharedInstance.isRecording ||
                    VAudioService.sharedInstance.currentAudioId == cellModel?.audioIdentifier)
            
            playButton.isEnabled = !VAudioService.sharedInstance.isRecording
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addObserver()
    }
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactDescriptionLabel: UILabel!
    @IBOutlet weak var recordButtonButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func recordAudio(_ sender: Any) {
        if let identifier = cellModel?.audioIdentifier{
            VAudioService.sharedInstance.recordAudio(withIdentifier: identifier)
        }
    }
    
    @IBAction func playAudio(_ sender: Any) {
        if let identifier = cellModel?.audioIdentifier{
            VAudioService.sharedInstance.playAudio(withIdentifier: identifier)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Static.isRecordingAllowed{
            recordButtonButton.isEnabled = change?[NSKeyValueChangeKey.newKey] as? Bool ?? false
        } else if keyPath == Static.isRecording {
            let isRecording = change?[NSKeyValueChangeKey.newKey] as? Bool ?? false
            if (isRecording == true) {
                if (VAudioService.sharedInstance.currentAudioId != cellModel?.audioIdentifier) {
                    playButton.isEnabled = false
                    recordButtonButton.isEnabled = false
                }else {
                    recordButtonButton.setTitle("Recording", for: .normal)
                    playButton.isEnabled = false
                }
                
            } else {
                playButton.isEnabled = true
                recordButtonButton.isEnabled = true
                recordButtonButton.setTitle("Record", for: .normal)
            }
        } else if keyPath == Static.isPlaying {
            let isPlaying = change?[NSKeyValueChangeKey.newKey] as? Bool ?? false
            if (isPlaying == true) {
                if (VAudioService.sharedInstance.currentAudioId != cellModel?.audioIdentifier) {
                    playButton.setTitle("Play", for: .normal)
                }else {
                    playButton.setTitle("Playing", for: .normal)
                }
                
            } else {
                playButton.setTitle("Play", for: .normal)
            }
        }
    }
    
    private func addObserver() {
        VAudioService.sharedInstance.addObserver(self, forKeyPath: Static.isRecordingAllowed, options: .new, context: nil)
        VAudioService.sharedInstance.addObserver(self, forKeyPath: Static.isRecording, options: .new, context: nil)
        VAudioService.sharedInstance.addObserver(self, forKeyPath: Static.isPlaying, options: .new, context: nil)
    }
    
    
    private func removeObservers() {
        VAudioService.sharedInstance.removeObserver(self, forKeyPath: Static.isRecordingAllowed)
        VAudioService.sharedInstance.removeObserver(self, forKeyPath: Static.isRecording)
        VAudioService.sharedInstance.removeObserver(self, forKeyPath: Static.isPlaying)
    }
    
    deinit {
        removeObservers()
    }
}
