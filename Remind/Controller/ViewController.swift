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
        CLService.shared.authorize()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterRegion),
                                               name: Notification.Name("internalNotification.enteredRegion"),
                                               object: nil)
        //internalNotification.handleAction
        NotificationCenter.default.addObserver(self, selector: #selector(handleAction), name: Notification.Name("internalNotification.handleAction"), object: nil)
    }
    
    @IBAction func onTimerTaped() {
        print("Timer")
        AlertService.actionSheet(in: self, title: "5 Seconds") {
            UNService.shared.timerRequest(with: 5)
        }
    }
    
    @IBAction func onDateTaped() {
        print("Date")
        AlertService.actionSheet(in: self, title: "Some future time") {
            var component = DateComponents()
            component.second = 2
            UNService.shared.dateRequest(with: component)
        }
    }
    
    @IBAction func onLocationTaped() {
        print("Location")
        AlertService.actionSheet(in: self, title: "When I return") {
            CLService.shared.updateLocation()
        }
    }
    
    @objc func didEnterRegion() {
        UNService.shared.locationRequest()
    }
    
    @objc func handleAction(_ sender: Notification) {
        guard let action = sender.object as? NotificationActionID else { return }
        switch action {
        case .timer: print("timer logic")
        case .date: print("date logic")
        case .location: changeBackground()
        default:
            break
        }
    }
    
    func changeBackground() {
        view.backgroundColor = .red
    }
}

