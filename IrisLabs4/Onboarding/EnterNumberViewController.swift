//
//  EnterNumberViewController.swift
//  Iris
//
//  Created by Shalin Shah on 1/5/20.
//  Copyright © 2020 Shalin Shah. All rights reserved.
//

import UIKit
import FirebaseAuth

class EnterNumberViewController: UIViewController {

    var keyboardPushedUp: Bool! = false
    
    @IBOutlet weak var phoneTextField: UITextField! {
        didSet {
            let prefix = UILabel(frame: CGRect(x: 10.0, y: -1.5, width: 50.0, height: 36.0))
            prefix.text = "  +1  "
            prefix.font = UIFont(name: "Courier-Bold", size: 18)
            prefix.textColor = .black
            self.phoneTextField.leftView = prefix
            self.phoneTextField.leftViewMode = .always
            self.phoneTextField.attributedPlaceholder = NSAttributedString(string: "678 136 7092", attributes: [NSAttributedString.Key.foregroundColor: UIColor.ColorTheme.Gray.MineShaft])
            self.phoneTextField.font = UIFont(name: "Courier", size: 18)
            self.phoneTextField.tintColor = .red
            self.phoneTextField.isOpaque = true
            
            self.phoneTextField.layer.cornerRadius = 0
            self.phoneTextField.layer.borderWidth = 3
            self.phoneTextField.layer.borderColor = UIColor.black.cgColor
            
            self.phoneTextField.textContentType = .telephoneNumber
            self.phoneTextField.keyboardType = .phonePad
            self.phoneTextField.keyboardAppearance = .dark
            self.phoneTextField.layer.shouldRasterize = true
            self.phoneTextField.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    @IBOutlet weak var continueButton: UIButton! {
        didSet {
            self.continueButton.titleLabel?.font = UIFont(name: "Courier-Bold", size: 16)
            self.continueButton.layer.shouldRasterize = true
            self.continueButton.layer.rasterizationScale = UIScreen.main.scale
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
        self.delay(0.1) { self.phoneTextField.becomeFirstResponder() }
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
    
    @IBOutlet weak var continueButtonBackgroundView: UIView! {
        didSet {
            self.continueButtonBackgroundView.layer.shouldRasterize = true
            self.continueButtonBackgroundView.layer.rasterizationScale = UIScreen.main.scale
        }
    }
        
    @IBAction func continueButton(_ sender: Any) {
        guard let text = phoneTextField.text else {
            return
        }
        self.sendCode(phoneNumber: text)
    }

    // Helper functions for this ViewCotroller
    func animateViewMoving (up:Bool, moveValue :CGFloat) {
        if (keyboardPushedUp) {
            self.keyboardPushedUp = false
        } else {
            self.keyboardPushedUp = true
        }
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.animate(withDuration: 0.3
        , animations: {
            self.continueButtonBackgroundView.frame = self.continueButtonBackgroundView.frame.offsetBy(dx: 0, dy: movement)
        }, completion: nil)
    }

    func sendCode(phoneNumber: String) {
        let animation = self.addAnimation()
        let finalNumber = self.formatNumber(number: phoneNumber)
        
        print(finalNumber)
        
        PhoneAuthProvider.provider().verifyPhoneNumber(finalNumber, uiDelegate: nil) { (verificationID, error) in
            self.removeAnimation(loader: animation)
            if let error = error {
                print(error.localizedDescription)
           
                DispatchQueue.main.async {
                    self.errorLabel.isHidden = false
                }
                
//                self.showAlert(message: nil, title: "Phone number invalid.  Please retry.", completionHandler: { _ in })
                return
            }

            let defaults1 = UserDefaults.standard
            defaults1.set(finalNumber, forKey: "phoneNumber")
            defaults1.synchronize()

            DispatchQueue.main.async {
                self.dismissKeyboard()
                let next: ConfirmNumberViewController? = self.storyboard?.instantiateViewController()
                next!.verificationID = verificationID
                self.show(next!, sender: self)
            }
        }
    }
}
