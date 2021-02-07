//
//  ViewController.swift
//  IrisLabs4
//
//  Created by Shalin on 10/28/20.
//

import UIKit
import Mixpanel
import Alamofire
import SwiftyJSON
import FirebaseAuth
import MessageUI
import Kingfisher

struct Post: Hashable, Identifiable, Codable {
    var id: String = "1"
    var posterNeeds: String
    var posterOffer: String
    var posterID: String
    var posterPhone: String
    var posterImage: String
    var posterNickname: String
    var courseID: String
    var postID: String
    var postTime: String
    var courseName: String
    var solved: Bool = false
}


class FeedViewController: UIViewController {
    var posts: [Post]? = [Post]()
    
    @IBOutlet weak var feedTableView: UITableView! {
        didSet {
            self.feedTableView.delegate = self
            self.feedTableView.dataSource = self
            self.feedTableView.layer.shouldRasterize = true
            self.feedTableView.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    @IBOutlet weak var answerButtonBackgroundView: UIView! {
        didSet {
            self.answerButtonBackgroundView.layer.shouldRasterize = true
            self.answerButtonBackgroundView.layer.rasterizationScale = UIScreen.main.scale
        }
    }

    @IBOutlet weak var answerButton: UIButton! {
        didSet {
            self.answerButton.layer.shouldRasterize = true
            self.answerButton.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    @IBOutlet weak var emptyLabel: UILabel! {
        didSet {
            self.emptyLabel.layer.shouldRasterize = true
            self.emptyLabel.layer.rasterizationScale = UIScreen.main.scale
            self.emptyLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.shouldRasterize = true
        self.view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.posts = [Post]()
        self.fetchPosts()
    }
    
    func fetchPosts() {
        struct User: Codable {
            var user_id: String
        }

        do {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let user = User(user_id: userID)
            let jsonData = try JSONEncoder().encode(user)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            
            let parameters = convertToDictionary(text: jsonString)
            let headers : HTTPHeaders = ["Content-Type": "application/json"]
            AF.request("https://1n8dgv8gxd.execute-api.us-west-1.amazonaws.com/api-v0/populate-feed", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                do {
                    let json = try JSON(data: response.data ?? Data())
                    print(json)
                    for (_,subJson):(String, JSON) in json {
                        let currentPost = Post(id: subJson["post_id"].stringValue, posterNeeds: subJson["poster_needs"].stringValue, posterOffer: subJson["poster_offer"].stringValue, posterID: subJson["poster_id"].stringValue, posterPhone: subJson["poster_phone"].stringValue, posterImage: subJson["poster_image"].stringValue, posterNickname: subJson["poster_nickname"].stringValue, courseID: subJson["course_id"].stringValue, postID: subJson["post_id"].stringValue, postTime: subJson["post_time"].stringValue, courseName: subJson["course_name"].stringValue, solved: subJson["solved"].boolValue)
                        self.posts?.append(currentPost)
                        self.displayPosts()
                    }
                } catch {
                    self.displayPosts()
                    print("error")
                }
            }
        } catch {  }
    }
    
    func flagPost(courseID: String, postID: String) {
        struct Info: Codable {
            var course_id: String
            var post_id: String
        }

        do {
            let user = Info(course_id: courseID, post_id: postID)
            let jsonData = try JSONEncoder().encode(user)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            
            let parameters = convertToDictionary(text: jsonString)
            let headers : HTTPHeaders = ["Content-Type": "application/json"]
            AF.request("https://1n8dgv8gxd.execute-api.us-west-1.amazonaws.com/api-v0/flag-post", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                DispatchQueue.main.async {
                    Mixpanel.mainInstance().track(event: "Post Flagged")
                }
            }
        } catch {  }
    }
    
    func deletePost(courseID: String, postID: String) {
        struct Info: Codable {
            var course_id: String
            var post_id: String
        }

        do {
            let user = Info(course_id: courseID, post_id: postID)
            let jsonData = try JSONEncoder().encode(user)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            
            let parameters = convertToDictionary(text: jsonString)
            let headers : HTTPHeaders = ["Content-Type": "application/json"]
            AF.request("https://1n8dgv8gxd.execute-api.us-west-1.amazonaws.com/api-v0/delete-post", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                DispatchQueue.main.async { // also remove it from the table
                    let removeIndex = self.posts?.firstIndex(where: {$0.postID == postID})
                    self.posts?.remove(at: removeIndex ?? 0)
                    self.feedTableView.deleteRows(at: [IndexPath(row: removeIndex ?? 0, section: 0)], with: .fade)
                    self.feedTableView.reloadData()
                    Mixpanel.mainInstance().track(event: "Post Deleted")
                }
            }
        } catch {  }
    }
    
    func displayPosts() {
        self.feedTableView.reloadData()
        self.feedTableView.reloadSections([0], with: UITableView.RowAnimation.none)
        if self.posts?.count == 0 { self.emptyLabel.isHidden = false } else { self.emptyLabel.isHidden = true }
    }

    @IBAction func answerButtonPressed(_ sender: Any) {
        let next: PostViewController? = self.storyboard?.instantiateViewController()
        self.show(next!, sender: self)
    }
    
    @IBAction func questionButtonPressed(_ sender: Any) {
        let next: ServiceViewController? = self.storyboard?.instantiateViewController()
        self.show(next!, sender: self)
    }

}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.feedTableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath as IndexPath) as! FeedTableViewCell
        cell.title.text = (self.posts?[indexPath.row].courseName ?? "") + " / " + (self.posts?[indexPath.row].posterNickname ?? "")
        cell.title.textColor = (self.posts?[indexPath.row].posterID ?? "" == Auth.auth().currentUser?.uid) ? UIColor.red : UIColor.black
        
        cell.needs.text = (self.posts?[indexPath.row].posterNeeds ?? "")
        cell.canGive.text = (self.posts?[indexPath.row].posterOffer ?? "")
        cell.time.text = (self.posts?[indexPath.row].postTime ?? "")
        cell.profile.kf.setImage(with: URL(string: (self.posts?[indexPath.row].posterImage ?? "")))

        
        cell.more.tag = indexPath.row
        cell.more.addTarget(self, action: #selector(self.buttonClicked), for: UIControl.Event.touchUpInside)

        return cell
    }
    
    @objc func buttonClicked(sender: UIButton) {
        let buttonRow = sender.tag

        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if (self.posts?[buttonRow].posterID ?? "" == Auth.auth().currentUser?.uid) {
            let flagAction = UIAlertAction(title: "Delete Post", style: .default, handler:
            { (alert: UIAlertAction!) -> Void in
                self.deletePost(courseID: self.posts?[buttonRow].courseID ?? "", postID: self.posts?[buttonRow].postID ?? "")
            })
            optionMenu.addAction(flagAction)
        } else {
            let flagAction = UIAlertAction(title: "Flag Post", style: .default, handler:
            { (alert: UIAlertAction!) -> Void in
                self.flagPost(courseID: self.posts?[buttonRow].courseID ?? "", postID: self.posts?[buttonRow].postID ?? "")
            })
            optionMenu.addAction(flagAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(cancelAction)
            
        self.present(optionMenu, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 167
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ((self.posts?[indexPath.row].posterID ?? "" == Auth.auth().currentUser?.uid)) { return }
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let textAction = UIAlertAction(title: "Text " + (self.posts?[indexPath.row].posterNickname ?? ""), style: .default, handler:
        { (alert: UIAlertAction!) -> Void in
            if (MFMessageComposeViewController.canSendText()) {
                Mixpanel.mainInstance().track(event: "Opened iMessage Dialogue")
                let controller = MFMessageComposeViewController()
                controller.body = "yo–heard you need help on "
                print(self.posts?[indexPath.row].posterPhone ?? "")
                controller.recipients = [self.posts?[indexPath.row].posterPhone ?? ""]
                controller.messageComposeDelegate = self
                self.show(controller, sender: self)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
        optionMenu.addAction(textAction)
        optionMenu.addAction(cancelAction)
            
        self.present(optionMenu, animated: true, completion: nil)
    }
}

extension FeedViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result)
        {
        case .cancelled:
            Mixpanel.mainInstance().track(event: "iMessage Cancelled")
            break;
        case .sent:
            Mixpanel.mainInstance().track(event: "iMessage Sent")
            break;
        case .failed:
            Mixpanel.mainInstance().track(event: "iMessage Failed")
            break;
        default:
            break;
        }

        
        self.dismiss(animated: true)
    }
}
