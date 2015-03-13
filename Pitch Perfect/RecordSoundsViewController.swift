//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Anko Top on 09/03/15.
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var stopRecording: UILabel!
    @IBOutlet weak var resumeRecording: UILabel!
    @IBOutlet weak var pauseRecording: UILabel!
    @IBOutlet weak var recordingStatus: UILabel!
    @IBOutlet weak var pausedStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        pauseButton.hidden = false
        pauseRecording.hidden = false
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
            pauseButton.hidden = true
            pauseRecording.hidden = true

        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    
    @IBAction func pauseRecording(sender: UIButton) {
        // prepare screen
        pausedStatus.hidden = false
        resumeButton.hidden = false
        resumeRecording.hidden = false
        pauseButton.hidden = true
        pauseRecording.hidden = true
        recordingStatus.hidden = true
        
        //pause recording
        audioRecorder.pause()
    }
    
    
    @IBAction func resumeRecording(sender: UIButton) {
        recordingStatus.hidden = false
        resumeButton.hidden = true
        resumeRecording.hidden = true
        pauseButton.hidden = false
        pauseRecording.hidden = false
        pausedStatus.hidden = true
        
        // resume recording
        audioRecorder.record()
    }
    
    
    @IBAction func stopRecordingAudio(sender: UIButton) {
        //To do: user sitches to next screen, after return tis screen is initialized
        // also do it here?
        initVisibleItems()
        // stop recording
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    
    func initVisibleItems(){
        // init layout screen
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        recordButton.enabled = true
        recordingStatus.textColor = UIColor.blackColor()
        recordingStatus.text = "Tap the mic to record"
        pausedStatus.hidden = true
        stopRecording.hidden = true
        resumeRecording.hidden = true
        pauseRecording.hidden = true
    }
}

