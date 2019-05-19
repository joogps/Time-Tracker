//
//  TimerViewController.swift
//  TimeTracker
//
//  Created by João Gabriel Pozzobon dos Santos on 14/05/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    @IBOutlet weak var TimePicker: UIDatePicker!
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var Reset: UIButton!
    
    var time = 0
    
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
        }
    }
    
    @objc func DecrementTime() {
        time -= 1
    }
    
    func SecondsToString(_ seconds: Int) -> String {
        var seconds = seconds
        var minutes = seconds/60
        let hours = minutes/60
        
        seconds = seconds%60
        minutes = minutes%60
        
        let text = String(format: "%02d", hours)+":"+String(format: "%02d", minutes)+":"+String(format: "%02d", seconds)
        
        return text
    }
}
