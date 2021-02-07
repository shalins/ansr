//
//  PostViewController.swift
//  IrisLabs4
//
//  Created by Shalin on 10/28/20.
//

import UIKit
import Alamofire
import SwiftyJSON
import FirebaseAuth
import Mixpanel

class PostViewController: UIViewController {
    
    var keyboardPushedUp: Bool! = false
    var classes: [Classes]? = [Classes]()
    var courseID: String = ""
    var selectedIndex: Int = 0

    @IBOutlet weak var needsTextField: UITextField! {
        didSet {
            let prefix = UILabel(frame: CGRect(x: 10.0, y: -1.5, width: 50.0, height: 36.0))
            prefix.text = "  Send Me  "
            prefix.font = UIFont(name: "Courier-Bold", size: 16)
            prefix.textColor = .black
            self.needsTextField.leftView = prefix
            self.needsTextField.leftViewMode = .always
            self.needsTextField.attributedPlaceholder = NSAttributedString(string: "#1, 2 or 3 pls :) ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.ColorTheme.Gray.Silver])
            self.needsTextField.font = UIFont(name: "Courier", size: 16)
            self.needsTextField.isOpaque = true
            self.needsTextField.tintColor = .red
            self.needsTextField.keyboardAppearance = .dark
            self.needsTextField.delegate = self
            self.needsTextField.layer.shouldRasterize = true
            self.needsTextField.layer.rasterizationScale = UIScreen.main.scale
        }
    }

    @IBOutlet weak var offerTextField: UITextField! {
        didSet {
            let prefix = UILabel(frame: CGRect(x: 10.0, y: -1.5, width: 50.0, height: 36.0))
            prefix.text = "  Can Send  "
            prefix.font = UIFont(name: "Courier-Bold", size: 16)
            prefix.textColor = .black
            self.offerTextField.leftView = prefix
            self.offerTextField.leftViewMode = .always
            self.offerTextField.attributedPlaceholder = NSAttributedString(string: "#4, 5, the whole PSET :() ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.ColorTheme.Gray.Silver])
            self.offerTextField.font = UIFont(name: "Courier", size: 16)
            self.offerTextField.isOpaque = true
            self.offerTextField.tintColor = .red
            self.offerTextField.keyboardAppearance = .dark
            self.offerTextField.delegate = self
            self.offerTextField.layer.shouldRasterize = true
            self.offerTextField.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    @IBOutlet weak var classesCollectionView: UICollectionView! {
        didSet {
            self.classesCollectionView.delegate = self
            self.classesCollectionView.dataSource = self
            self.classesCollectionView.layer.shouldRasterize = true
            self.classesCollectionView.layer.rasterizationScale = UIScreen.main.scale
        }
    }

    @IBOutlet weak var doneButtonBackgroundView: UIView! {
        didSet {
            self.doneButtonBackgroundView.isHidden = true
            self.doneButtonBackgroundView.layer.shouldRasterize = true
            self.doneButtonBackgroundView.layer.rasterizationScale = UIScreen.main.scale
        }
    }

    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            self.doneButton.layer.shouldRasterize = true
            self.doneButton.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.offerTextField.addTarget(self, action: #selector(self.typingName), for: .editingChanged)
        self.needsTextField.addTarget(self, action: #selector(self.typingName), for: .editingChanged)

        if let flowlayout = self.classesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.itemSize = CGSize(width: 110, height: 38)
        }
        
        self.fetchClasses()
    }
    
    func fetchClasses() {
        struct User: Codable {
            var user_id: String
        }

        do {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let user = User(user_id: userID)
            let jsonData = try JSONEncoder().encode(user)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            
            let parameters = convertToDictionary(text: jsonString)
            let headers : HTTPHeaders = ["Content-Type": "application/json"]
            AF.request("https://1n8dgv8gxd.execute-api.us-west-1.amazonaws.com/api-v0/get-user-courses", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                do {
                    let json = try JSON(data: response.data ?? Data())
                    print(json)
                    for (_,subJson):(String, JSON) in json {
                        let currentClass = Classes(id: subJson["course_id"].stringValue, name: subJson["course_name"].stringValue)
                        self.classes?.append(currentClass)
                        self.displayClasses()
                    }
                } catch {
                    print("error")
                }
            }
        } catch {  }
    }
    
    func displayClasses() {
        self.classesCollectionView.reloadData()
        self.classesCollectionView.reloadSections([0])
        self.courseID = self.classes?[self.selectedIndex].id ?? ""
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
            self.doneButtonBackgroundView.frame = self.doneButtonBackgroundView.frame.offsetBy(dx: 0, dy: movement)
        }, completion: nil)
    }
    
    @objc func typingName(textField: UITextField) {
        if self.needsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && self.offerTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            self.doneButtonBackgroundView.isHidden = false
        } else {
            self.doneButtonBackgroundView.isHidden = true
        }
     }



    @IBAction func cancel(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        print("tapping")

        DispatchQueue.main.async {
            self.doneButton.isUserInteractionEnabled = false
            self.dismissKeyboard()
        }
        if self.needsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && self.offerTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && self.courseID != "" {
            self.postSomething()
        }
    }

    
    func postSomething() {

        struct PostInfo: Codable {
            var user_id: String
            var needs: String
            var offer: String
            var course_id: String
        }

        do {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let user = PostInfo(user_id: userID, needs: self.needsTextField.text ?? "", offer: self.offerTextField.text ?? "", course_id: self.courseID)
            let jsonData = try JSONEncoder().encode(user)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)

            let parameters = convertToDictionary(text: jsonString)
            let headers : HTTPHeaders = ["Content-Type": "application/json"]
            AF.request("https://1n8dgv8gxd.execute-api.us-west-1.amazonaws.com/api-v0/make-post", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                DispatchQueue.main.async {
                    self.doneButton.isUserInteractionEnabled = true
                    self.dismiss(animated: true, completion: nil)
                    Mixpanel.mainInstance().track(event: "Question Posted")
                }
            }
        } catch { self.doneButton.isUserInteractionEnabled = true }
    }
}

extension PostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.classes?.count ?? 0
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostClassesCollectionViewCell", for: indexPath as IndexPath) as! PostClassesCollectionViewCell
        cell.title.text = self.classes?[indexPath.item].name
        if indexPath.item == self.selectedIndex { cell.background.image = #imageLiteral(resourceName: "classbutton_selected") } else { cell.background.image = #imageLiteral(resourceName: "classbutton") }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("self.selectedIndex", self.selectedIndex)
        print("indexPath.item", indexPath.item)
        if (self.selectedIndex == indexPath.item) { print("they're the same"); return }
        guard let cell = classesCollectionView.cellForItem(at: indexPath) as? PostClassesCollectionViewCell else { print("cell can't be selected"); return }
        cell.background.image = #imageLiteral(resourceName: "classbutton_selected")
        
        if let cell2 = classesCollectionView.cellForItem(at: IndexPath(item: selectedIndex, section: indexPath.section)) as? PostClassesCollectionViewCell {
            cell2.background.image = #imageLiteral(resourceName: "classbutton")
        }
        
        self.selectedIndex = indexPath.item
        self.courseID = self.classes?[self.selectedIndex].id ?? ""
        print("self.selectedIndex", self.selectedIndex)
        print("self.courseID", self.courseID)
    }
    
}

extension PostViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
}


extension PostViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton {
            return false
        }
        return true
    }
}
