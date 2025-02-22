//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var timer: Timer? = nil

    @IBOutlet weak var eggTitleLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!

    var player: AVAudioPlayer?

    //in seconds
    let eggTimes = ["Soft" : 5, "Medium" : 7, "Hard" : 12]

    override func viewDidLoad() {
        debugPrint("viewDidLoad")
        self.progressView.progress = 0
    }

    @IBAction func hardnessSelected(_ sender: UIButton) {
        let hardness = sender.currentTitle!
        let countdownSecs = eggTimes[hardness]!
        var progress = 0

        self.progressView.progress = 0

        if (timer != nil) {
            timer?.invalidate()
            self.eggTitleLabel.text = "How do you like your eggs?"
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if (progress < countdownSecs) {
                progress += 1
                let progressPercent = Float(progress)/Float(countdownSecs)
                print("progressPercent \(progressPercent)")
                self.progressView.setProgress(progressPercent, animated: true)
            } else {
                timer.invalidate()
                self.playSound("alarm_sound")
                self.eggTitleLabel.text = "Your eggs are done."
            }

        }
    }

    func playSound(_ wavFileName: String) {
        debugPrint("key pressed, playing \(wavFileName)...")
        guard let url = Bundle.main.url(forResource: wavFileName, withExtension: "mp3") else {
            debugPrint("no wav files found")
            return
        }
        do {
            // make sure that audio will play even if app is in silent mode
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            // acticate chosen category
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
