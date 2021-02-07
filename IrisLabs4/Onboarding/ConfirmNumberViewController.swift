//
//  ConfirmNumberViewController.swift
//  Iris
//
//  Created by Shalin Shah on 1/5/20.
//  Copyright © 2020 Shalin Shah. All rights reserved.
//

import UIKit
import FirebaseAuth
import Mixpanel

class ConfirmNumberViewController: UIViewController {

    var verificationID: String!
    var keyboardPushedUp: Bool! = false

    @IBOutlet weak var codeLabel: UITextField! {
        didSet {
            let prefix = UILabel(frame: CGRect(x: 10.0, y: -1.5, width: 30.0, height: 36.0))
            prefix.text = "  "
            prefix.font = UIFont(name: "Courier-Bold", size: 18)
            prefix.textColor = .black
            self.codeLabel.leftView = prefix
            self.codeLabel.leftViewMode = .always
            self.codeLabel.attributedPlaceholder = NSAttributedString(string: "090265", attributes: [NSAttributedString.Key.foregroundColor: UIColor.ColorTheme.Gray.MineShaft])
            self.codeLabel.font = UIFont(name: "Courier", size: 18)
            self.codeLabel.tintColor = .red
            self.codeLabel.isOpaque = true

            self.codeLabel.layer.cornerRadius = 0
            self.codeLabel.layer.borderWidth = 3
            self.codeLabel.layer.borderColor = UIColor.black.cgColor

            self.codeLabel.keyboardType = .phonePad
            self.codeLabel.keyboardAppearance = .dark
            self.codeLabel.textContentType = .oneTimeCode
            self.codeLabel.layer.shouldRasterize = true
            self.codeLabel.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    @IBOutlet weak var continueButtonBackgroundView: UIView! {
        didSet {
            self.continueButtonBackgroundView.layer.shouldRasterize = true
            self.continueButtonBackgroundView.layer.rasterizationScale = UIScreen.main.scale
        }
    }

    
    @IBOutlet weak var continueButton: UIButton! {
        didSet {
            self.continueButton.titleLabel?.font = UIFont(name: "Courier-Bold", size: 16)
            self.continueButton.layer.shouldRasterize = true
            self.continueButton.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    @IBOutlet weak var termsButton: UIButton! {
        didSet {
            self.termsButton.titleLabel?.font = UIFont(name: "Courier-Bold", size: 14)
            self.termsButton.layer.shouldRasterize = true
            self.termsButton.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    @IBOutlet weak var errorLabel: UILabel! {
        didSet {
            self.errorLabel.isHidden = true
            self.errorLabel.font = UIFont(name: "Courier-Bold", size: 14)
            self.errorLabel.layer.shouldRasterize = true
            self.errorLabel.layer.rasterizationScale = UIScreen.main.scale
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.view.layer.shouldRasterize = true
        self.view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.delay(0.1) {self.codeLabel.becomeFirstResponder()}
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if (!keyboardPushedUp) {
                self.animateViewMoving(up: true, moveValue: keyboardSize.height)
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if (keyboardPushedUp) {
                self.animateViewMoving(up: false, moveValue: keyboardSize.height)
            }
        }
    }

    
    // IB Actions
    
    @IBAction func continueTapped(_ sender: Any) {
        guard let text = codeLabel.text else {
            return
        }
        self.verify(code: text)
    }
    
    @IBAction func goBackPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func termsAgreement(_ sender: Any) {
        let optionMenuController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let communityAction = UIAlertAction(title: "Community Guidelines", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            DispatchQueue.main.async {
                if let url = URL(string: "https://www.getiris.xyz/community") {
                   UIApplication.shared.open(url)
               }
            }
        })

        let privacyAction = UIAlertAction(title: "Privacy Policy", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            DispatchQueue.main.async {
                if let url = URL(string: "https://www.getiris.xyz/privacy") {
                   UIApplication.shared.open(url)
               }
            }
        })
        let termsAction = UIAlertAction(title: "Terms of Service", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            DispatchQueue.main.async {
                if let url = URL(string: "https://www.getiris.xyz/tos") {
                   UIApplication.shared.open(url)
               }
            }
        })

        // Add UIAlertAction in UIAlertController
        optionMenuController.addAction(communityAction)
        optionMenuController.addAction(privacyAction)
        optionMenuController.addAction(termsAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancel")
        })
        optionMenuController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(optionMenuController, animated: true, completion: nil)
        }
    }
    
    // Helper functions for this ViewCotroller
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        if (keyboardPushedUp) {
            self.keyboardPushedUp = false
        } else {
            self.keyboardPushedUp = true
        }
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.animate(withDuration: 0.3
        , animations: {
            self.continueButtonBackgroundView.frame = self.continueButtonBackgroundView.frame.offsetBy(dx: 0, dy: movement)
//            self.termsButton.frame = self.termsButton.frame.offsetBy(dx: 0, dy: movement)
        }, completion: nil)
    }

    func verify(code: String) {
        let animation = self.addAnimation()
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            self.removeAnimation(loader: animation)
            if let error = error {
                print("Could not sign this user in! Error: \(error)")
                DispatchQueue.main.async {
                    self.errorLabel.isHidden = false
                }
//                self.showAlert(message: nil, title: "Not valid!", completionHandler: { _ in })
                return
            }
            
            DispatchQueue.main.async {
                if let userID = Auth.auth().currentUser?.uid {
                    Mixpanel.mainInstance().track(event: "Signed Up")
                    Mixpanel.mainInstance().createAlias(userID, distinctId: Mixpanel.mainInstance().distinctId)
                    Mixpanel.mainInstance().identify(distinctId: Mixpanel.mainInstance().distinctId)
                }
                self.dismissKeyboard()
                let next: ClassesMultiSelectViewController? = self.storyboard?.instantiateViewController()
                self.show(next!, sender: self)
            }
        }
    }
}
