//
//  ViewController.swift
//  Remind
//
//  Created by Manoj kumar on 10/01/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNService.shared.authorize()
    }
    
    @IBAction func onTimerTaped() {
        print("TImer")
    }
    
    @IBAction func onDateTaped() {
        print("Date")
    }
    
    @IBAction func onLocationTaped() {
        print("Location")
    }
}

