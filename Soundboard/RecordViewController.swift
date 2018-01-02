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
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    

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
                self.audioURL = audioURL
                var settings : [String:Any] = [:]
                settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
                settings[AVSampleRateKey] = 44100.0
                settings[AVNumberOfChannelsKey] = 2
                
                // Create the audio recorder
                audioRecorder = try? AVAudioRecorder(url: audioURL, settings: settings)
                audioRecorder?.prepareToRecord()
                
            }
        }
        playButton.isEnabled = false
        nameTextField.isEnabled = false
        addButton.isEnabled = false
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if let audioRecorder =  self.audioRecorder {
            
            if audioRecorder.isRecording {
                audioRecorder.stop()
                recordButton.setTitle("Record", for: .normal)
                playButton.isEnabled = true
                nameTextField.isEnabled = true
                addButton.isEnabled = true
            } else {
                audioRecorder.record()
                recordButton.setTitle("Stop", for: .normal)
                playButton.isEnabled = false
                nameTextField.isEnabled = false
                addButton.isEnabled = false
            }

        }
        
    }
    @IBAction func playTapped(_ sender: Any) {
        if let audioURL = self.audioURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.play()
        }
    }
    @IBAction func addTapped(_ sender: Any) {
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            let sound = Sound(entity: Sound.entity(), insertInto: context)
            sound.name = nameTextField.text
            
            if let audioURL = self.audioURL {
                sound.audioData = try? Data(contentsOf: audioURL)
                try? context.save()
                navigationController?.popViewController(animated: true)
            }
            
        }
        
    }
    
}
