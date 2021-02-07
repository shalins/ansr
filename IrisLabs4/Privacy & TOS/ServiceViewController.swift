//
//  ServiceViewController.swift
//  Iris
//
//  Created by Shalin Shah on 1/7/20.
//  Copyright © 2020 Shalin Shah. All rights reserved.
//

import UIKit
import MessageUI

class ServiceViewController: UIViewController {

    @IBOutlet weak var policyText: UITextView! {
        didSet {
            self.policyText.layer.shouldRasterize = true
            self.policyText.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    @IBOutlet weak var policyTitle: UILabel! {
        didSet {
            self.policyText.layer.shouldRasterize = true
            self.policyText.layer.rasterizationScale = UIScreen.main.scale
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.shouldRasterize = true
        self.view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func communityButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            if let url = URL(string: "https://www.getiris.xyz/community") {
               UIApplication.shared.open(url)
           }
        }
    }

    
    @IBAction func privacyButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            if let url = URL(string: "https://www.getiris.xyz/privacy") {
               UIApplication.shared.open(url)
           }
        }
    }

    @IBAction func tosButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            if let url = URL(string: "https://www.getiris.xyz/tos") {
               UIApplication.shared.open(url)
           }
        }
    }

    @IBAction func feedbackButtonPressed(_ sender: Any) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            controller.recipients = ["9498362723", "9499396619", "8182033202"]
            controller.messageComposeDelegate = self
            self.show(controller, sender: self)
        }
    }
}


extension ServiceViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true)
    }
}
