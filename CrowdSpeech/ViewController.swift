//
//  ViewController.swift
//  CrowdSpeech
//
//  Created by Eduardo de Leon on 11/2/14.
//  Copyright (c) 2014 Eduardo de Leon. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var textToPlayField: UITextField!
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var historyTableView: UITableView!
    @IBAction func playButtonClicked(sender: AnyObject) {
        let text = textToPlayField.text
        var dictation:CrowdSpeech = CrowdSpeech(text:text)
        var synthesizer = AVSpeechSynthesizer()
        var mySpeechUtterance = AVSpeechUtterance(string:text)
        synthesizer.speakUtterance(mySpeechUtterance)
        dictation.incrementUsageCount()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

