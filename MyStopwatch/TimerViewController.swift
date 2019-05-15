//
//  TimerViewController.swift
//  MyStopwatch
//
//  Created by João Gabriel Pozzobon dos Santos on 14/05/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    let time = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func ReturnString(_ time: Int) -> String {
        var milliseconds = time
        var seconds = milliseconds/100
        var minutes = seconds/60
        let hours = minutes/60
        
        milliseconds = milliseconds%100
        seconds = seconds%60
        minutes = minutes%60
        
        let text = String(format: "%02d", hours)+":"+String(format: "%02d", minutes)+":"+String(format: "%02d", seconds)
        
        return text
    }
}
