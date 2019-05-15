//
//  StopwatchViewController.swift
//  MyStopwatch
//
//  Created by João Gabriel Pozzobon dos Santos on 13/05/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var Reset: UIButton!
    
    let bodyFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.body)
    
    var time = 0
    var timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(IncrementTime), userInfo: nil, repeats: true)
    
    var backgroundTime = Date()
    var correctTime = false

    override func viewDidLoad() {
        super.viewDidLoad()
        timer.invalidate()
        
        let bodyMonospacedNumbersFontDescriptor = bodyFontDescriptor.addingAttributes(
            [
                UIFontDescriptor.AttributeName.featureSettings: [
                    [
                        UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                        UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector
                    ]
                ]
            ])
        
        Label.font = UIFont(descriptor: bodyMonospacedNumbersFontDescriptor, size: 50.0)
        Label.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func TriggerTimer(_ sender: Any) {
        if Button.currentTitle! == "Start" {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(IncrementTime), userInfo: nil, repeats: true)
            
            Button.setTitle("Stop", for: .normal)
            Button.setTitleColor(.red, for: .normal)
            
            Reset.isEnabled = false
            Reset.setTitleColor(.lightGray, for: .normal)
            
            correctTime = true
        } else {
            timer.invalidate()
            Button.setTitle("Start", for: .normal)
            Button.setTitleColor(UIColor(displayP3Red: 0, green: 196/255, blue: 14/255, alpha: 1), for: .normal)
            
            Reset.isEnabled = true
            Reset.setTitleColor(.darkGray, for: .normal)
            
            correctTime = false
        }
    }
    
    @IBAction func ResetTime(_ sender: Any) {
        time = 0
        Label.text = ReturnString(time)
        
        Button.setTitle("Start", for: .normal)
        Button.setTitleColor(UIColor(displayP3Red: 0, green: 196/255, blue: 14/255, alpha: 1), for: .normal)
        
        Reset.isEnabled = false
        Reset.setTitleColor(.lightGray, for: .normal)
    }
    
    @objc func IncrementTime() {
        time += 1
        Label.text = ReturnString(time)
    }
    
    func ReturnString(_ time: Int) -> String {
        var milliseconds = time
        var seconds = milliseconds/100
        var minutes = seconds/60
        let hours = minutes/60
        
        milliseconds = milliseconds%100
        seconds = seconds%60
        minutes = minutes%60
        
        var text = String(format: "%02d", minutes)+":"+String(format: "%02d", seconds)+"."+String(format: "%02d", milliseconds)
        
        if hours >= 1 {
            text = String(format: "%02d", hours)+":"+text
        }
        
        return text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: Selector(("activeAgain")), name: NSNotification.Name(rawValue: "UIApplicationDidBecomeActiveNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: Selector(("goingAway")), name: NSNotification.Name(rawValue: "UIApplicationWillResignActiveNotification"), object: nil)
    }
    
    @objc func goingAway() {
        backgroundTime = Date()
    }
    
    @objc func activeAgain() {
        if (correctTime) {
            time += Int(Date().timeIntervalSince1970 * 100.0.rounded() - backgroundTime.timeIntervalSince1970 * 100.0.rounded())
            Label.text = UpdateTime(time)
        }
    }
}

