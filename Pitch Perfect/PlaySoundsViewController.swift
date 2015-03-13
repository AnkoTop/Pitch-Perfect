//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Anko Top on 10/03/15.
//      refactoring on 13/03/15.
//
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var mainMixer:AVAudioMixerNode!
    var audioFile: AVAudioFile!
    var volumeView: MPVolumeView!
    
    @IBOutlet weak var adjustVolume: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
    
        //volume adjust & speaker control: doesn't work in the simulator but it does on the iphone
        volumeView = MPVolumeView(frame: CGRectMake(30, self.view.frame.size.height - 50, 300, 20))
        volumeView.backgroundColor = UIColor.lightGrayColor()
        volumeView.layer.cornerRadius = 4
        self.view.addSubview(volumeView)
        volumeView.hidden = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func toggleVolumeView(sender: UIBarButtonItem) {
        if volumeView.hidden   {
            volumeView.hidden = false
        } else {
            volumeView.hidden = true
        }
    }
    
    
    @IBAction func playNormalAudio(sender: UIButton) {
       
        playAudioFile()
    }

    
    @IBAction func playSlowAudio(sender: UIButton) {
        
        playAudioFile(desiredSpeed: 0.5)
    }
    
    
    @IBAction func playFastAudio(sender: UIButton) {

        playAudioFile(desiredSpeed: 2.0)
    }
    
    
    func playAudioFile(desiredSpeed: Float = 1.0) {
        
        initAudio()
        
        audioPlayer.rate = desiredSpeed
        audioPlayer.play()
    }

    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
    }
    
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(-500)
    }
    
    
    func playAudioWithVariablePitch(pitch: Float) {
        
        initAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        
        var audioTimePitch = AVAudioUnitTimePitch()
        audioTimePitch.pitch = pitch  // default = 1.0 range: -2400 to 2400
        audioTimePitch.rate = 1 // default = 1.0 range: 1/32 to 32.0.
        audioEngine.attachNode(audioTimePitch)
        
        audioEngine.connect(audioPlayerNode, to: audioTimePitch, format: nil)
        audioEngine.connect(audioTimePitch, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    @IBAction func playAudioWithReverb(sender: UIButton) {
        
        initAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var audioReverb = AVAudioUnitReverb()
        audioReverb.loadFactoryPreset(.Cathedral)
        audioReverb.wetDryMix = 20 // default = 0 range: 0 to 100
        audioEngine.attachNode(audioReverb)
        
        audioEngine.connect(audioPlayerNode, to: audioReverb, format: nil)
        audioEngine.connect(audioReverb, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    @IBAction func playAudioWithEcho(sender: UIButton) {
        
        initAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var audioDelay = AVAudioUnitDelay()
        audioDelay.delayTime = 0.75 // delay in seconds
        audioDelay.feedback = 20 //default = 50 range = -100 to 100
        audioDelay.wetDryMix = 25 // default = 0 range: 0 to 100
        audioEngine.attachNode(audioDelay)
        
        audioEngine.connect(audioPlayerNode, to: audioDelay, format: nil)
        audioEngine.connect(audioDelay, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    @IBAction func stopPlayingSound(sender: UIButton) {
        
        initAudio()
    }
    
    
    func initAudio(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}
