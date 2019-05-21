//
//  TimerViewController.swift
//  TimeTracker
//
//  Created by João Gabriel Pozzobon dos Santos on 14/05/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    @IBOutlet weak var StackView: UIStackView!
    
    @IBOutlet var TimePicker: UIDatePicker!
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var Reset: UIButton!
    
    var Label = UILabel();
    
    let bodyFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.body)
    
    var time = 0
    var timer = Timer()
    
    var backgroundTime = Date()
    var correctTime = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func TriggerTimer(_ sender: Any) {
        if (Button.currentTitle! == "Start") {
            let date = TimePicker.date
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            
            let hour = components.hour!
            let minute = components.minute!
            
            let totalMinutes = hour*60+minute
            let totalMillis = totalMinutes*60*1000
            
            time = totalMillis;
            
            timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(DecrementTime), userInfo: nil, repeats: true)
            
            Button.setTitle("Pause", for: .normal)
            Button.setTitleColor(.red, for: .normal)
            
            Reset.isEnabled = false
            Reset.setTitleColor(.lightGray, for: .normal)
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.TimePicker.isHidden = true
            })
            
            let bodyMonospacedNumbersFontDescriptor = bodyFontDescriptor.addingAttributes(
                [
                    UIFontDescriptor.AttributeName.featureSettings: [
                        [
                            UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                            UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector
                        ]
                    ]
                ])
            
            Label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            
            Label.font = UIFont(descriptor: bodyMonospacedNumbersFontDescriptor, size: 65.0)
            Label.adjustsFontSizeToFitWidth = true
            Label.textAlignment = .center
            
            Label.text = MillisToString(time)
            
            Label.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.Label.alpha = 1
            })
            
            StackView.insertArrangedSubview(Label, at: 0)
            TimePicker.removeFromSuperview()
            
            correctTime = true
        } else if Button.currentTitle! == "Pause" {
            timer.invalidate()
            
            Button.setTitle("Resume", for: .normal)
            Button.setTitleColor(UIColor(displayP3Red: 0, green: 196/255, blue: 14/255, alpha: 1), for: .normal)
            
            Reset.isEnabled = true
            Reset.setTitleColor(.darkGray, for: .normal)
            
            correctTime = false
        } else if Button.currentTitle! == "Resume" {
            timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(DecrementTime), userInfo: nil, repeats: true)
            
            Button.setTitle("Pause", for: .normal)
            Button.setTitleColor(.red, for: .normal)
            
            Reset.isEnabled = false
            Reset.setTitleColor(.lightGray, for: .normal)
        }
    }
    
    
    @IBAction func ResetTimer(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.Label.isHidden = true
        })
        
        TimePicker = UIDatePicker()
        TimePicker.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        TimePicker.datePickerMode = .countDownTimer
        TimePicker.countDownDuration = TimeInterval(time/1000)
        
        Button.setTitle("Start", for: .normal)
        Button.setTitleColor(UIColor(displayP3Red: 0, green: 196/255, blue: 14/255, alpha: 1), for: .normal)
        
        Reset.isEnabled = false
        Reset.setTitleColor(.lightGray, for: .normal)
        
        TimePicker.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.TimePicker.alpha = 1
        })
        
        StackView.insertArrangedSubview(TimePicker, at: 0)
        Label.removeFromSuperview()
    }
    
    @objc func DecrementTime() {
        time -= 1
        Label.text = MillisToString(self.time)
    }
    
    func MillisToString(_ millis: Int) -> String {
        var milliseconds = millis
        var seconds = milliseconds/1000
        var minutes = seconds/60
        let hours = minutes/60
        
        milliseconds = milliseconds%1000
        seconds = seconds%60
        minutes = minutes%60
        
        var text = String(format: "%02d", minutes)+":"+String(format: "%02d", seconds)
        
        if hours >= 1 {
            text = String(format: "%02d", hours)+":"+text
        }
        
        return text
    }
    
    @objc func goingAway() {
        backgroundTime = Date()
    }
    
    @objc func activeAgain() {
        if (correctTime) {
            time += Int(Date().timeIntervalSince1970 * 1000.0.rounded() - backgroundTime.timeIntervalSince1970 * 1000.0.rounded())
            Label.text = MillisToString(time)
        }
    }
}
