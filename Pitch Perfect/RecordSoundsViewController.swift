//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Anko Top on 09/03/15.
//      after review: inetgrated pause/resume in 1 toggle button 16/03/2015.
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var paused = false
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var stopRecording: UILabel!
    @IBOutlet weak var pauseOrResumeRecording: UILabel!
    @IBOutlet weak var recordingStatus: UILabel!
    @IBOutlet weak var pauseResumeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(false)
        // intialize the screen
        initVisibleItems()
    }
    
    
    @IBAction func recordAudio(sender: UIButton) {
    
        recordButton.enabled = false
        stopButton.hidden = false
        stopRecording.hidden = false
        paused = false
        initPauseOrResumeButton()
        pauseResumeButton.hidden = false
        recordingStatus.textColor = UIColor.redColor()
        recordingStatus.text = "Recording"
       
        // set name & path of recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        
        //setup audio session & prepare AudioRecorder
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        
        // start recording
        audioRecorder.record()
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not succesful")
            stopButton.hidden = true
            stopRecording.hidden = true
            recordButton.enabled = true
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    
    @IBAction func pauseOrResumeRecording(sender: UIButton) {
        // toggle between pause & resume
        if paused == false {
            paused = true
            initPauseOrResumeButton()
            recordingStatus.textColor = UIColor.redColor()
            recordingStatus.text = "Paused"
            audioRecorder.pause()
        } else {
            paused = false
            initPauseOrResumeButton()
            recordingStatus.hidden = false
            recordingStatus.textColor = UIColor.redColor()
            recordingStatus.text = "Recording"
            audioRecorder.record()
        }
    }
    
    
    @IBAction func stopRecordingAudio(sender: UIButton) {
        initVisibleItems()
        // stop recording
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    
    func initPauseOrResumeButton(){
        //depending on what we are doing set the correct image
        pauseOrResumeRecording.hidden = false
        if paused {
            let image = UIImage(named: "resume button")
            pauseResumeButton.setBackgroundImage(image, forState: .Normal)
            pauseOrResumeRecording.text = "Resume"
        } else {
            let image = UIImage(named: "pause button")
            pauseResumeButton.setBackgroundImage(image, forState: .Normal)
            pauseOrResumeRecording.text = "Pause"
        }
    }
    
    
    func initVisibleItems(){
        // init layout screen
        stopButton.hidden = true
        stopRecording.hidden = true
        recordButton.enabled = true
        recordingStatus.hidden = false
        recordingStatus.textColor = UIColor.blackColor()
        recordingStatus.text = "Tap the mic to record"
        pauseResumeButton.hidden = true
        pauseOrResumeRecording.hidden = true
    }
}

