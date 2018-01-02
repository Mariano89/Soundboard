//
//  RecordViewController.swift
//  Soundboard
//
//  Created by Mariano Echegoyen on 12/31/17.
//  Copyright © 2017 Mariano Echegoyen. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    var audioRecorder : AVAudioRecorder?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create audio session
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try? session.overrideOutputAudioPort(.speaker)
        try? session.setActive(true)
        
        // URL to save the audio
        if let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            
            let pathComponents = [basePath, "audio.m4a"]
            
            if let audioURL = NSURL.fileURL(withPathComponents: pathComponents) {
                // Create some settings
                var settings : [String:Any] = [:]
                settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
                settings[AVSampleRateKey] = 44100.0
                settings[AVNumberOfChannelsKey] = 2
                
                // Create the audio recorder
                audioRecorder = try? AVAudioRecorder(url: audioURL, settings: settings)
                audioRecorder?.prepareToRecord()
                
            }
        }
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if let audioRecorder =  self.audioRecorder {
            
            if audioRecorder.isRecording {
                audioRecorder.stop()
                recordButton.setTitle("Record", for: .normal)
            } else {
                audioRecorder.record()
                recordButton.setTitle("Stop", for: .normal)
            }

        }
        
    }
    @IBAction func playTapped(_ sender: Any) {
    }
    @IBAction func addTapped(_ sender: Any) {
    }
    
}
