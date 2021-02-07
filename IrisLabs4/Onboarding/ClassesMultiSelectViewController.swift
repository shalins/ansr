//
//  SettingsMultiSelectViewController.swift
//  Iris
//
//  Created by Shalin Shah on 1/22/20.
//  Copyright © 2020 Shalin Shah. All rights reserved.
//

import UIKit
import Mixpanel
import Alamofire
import SwiftyJSON
import FirebaseAuth

struct Classes: Hashable, Identifiable, Codable {
    var id: String = "1"
    var name: String
    var selected: Bool = false
}

class ClassesMultiSelectViewController: UIViewController {
    
    var optionsChanged: Bool! = false

    var isSeachBarAnimationCompleted: Bool = false
    
    var classes: [Classes]? = [Classes]()
    var selectedClassIDs: [String]? = [String]()
    var filteredClasses: [Classes]? = [Classes]()

    @IBOutlet weak var searchView: UIView! {
        didSet {
            self.searchView.layer.shouldRasterize = true
            self.searchView.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var settingsMultiSelectTableView: UITableView! {
        didSet {
            self.settingsMultiSelectTableView.delegate = self
            self.settingsMultiSelectTableView.dataSource = self
            self.settingsMultiSelectTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.settingsMultiSelectTableView.layer.shouldRasterize = true
            self.settingsMultiSelectTableView.layer.rasterizationScale = UIScreen.main.scale
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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchController.searchBar.placeholder = "Enter your classes"
        self.searchController.searchBar.searchBarStyle = .minimal
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false

        let image = self.getImageWithColor(color: UIColor.white, size: CGSize(width: 20, height: 40))
        self.searchController.searchBar.setSearchFieldBackgroundImage(image, for: .normal)

        if let textfield = self.searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.layer.cornerRadius = 0
            textfield.layer.borderWidth = 3
            textfield.layer.borderColor = UIColor.black.cgColor

            textfield.font = UIFont(name: "Courier", size: 16.0)!
            let imageView: UIImageView = UIImageView.init(image: #imageLiteral(resourceName: "search"))
            imageView.frame = CGRect(x: 0, y: 0, width: (imageView.image?.size.width ?? 0), height: (imageView.image?.size.height ?? 0))
            textfield.tintColor = .red

            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
            paddingView.addSubview(imageView)
            textfield.leftView = paddingView

            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.clear
                backgroundview.layer.cornerRadius = 8
                backgroundview.clipsToBounds = true
            }
            textfield.textColor = UIColor.black
        }

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Courier", size: 16.0)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)

        let placeholderAppearance = UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        placeholderAppearance.padding = UIEdgeInsets(top: 2, left: 50, bottom: 0, right: 0)
        placeholderAppearance.textColor = UIColor.ColorTheme.Gray.Silver

        self.definesPresentationContext = false
        self.searchView.addSubview(self.searchController.searchBar)

        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchResultsUpdater = self


        self.view.layer.shouldRasterize = true
        self.view.layer.rasterizationScale = UIScreen.main.scale
        self.fetchClasses()
    }

    deinit {
        self.searchController.searchResultsUpdater = nil
        self.searchController.searchBar.delegate = nil
        self.searchController.delegate = nil
    }
    
    func fetchClasses() {
        self.classes = [Classes]()
        
        let headers : HTTPHeaders = ["Content-Type": "application/json"]
        AF.request("https://1n8dgv8gxd.execute-api.us-west-1.amazonaws.com/api-v0/courses-list", method: .post, encoding: JSONEncoding.default, headers: headers)
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
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismissKeyboardSearch(searchController: self.searchController)
        }
        self.signUp()
    }
    
    func signUp() {
        struct User: Codable {
            var user_id: String
            var phone: String
            var courses: [String]
        }

        do {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let user = User(user_id: userID, phone: Auth.auth().currentUser?.phoneNumber ?? "", courses: self.selectedClassIDs ?? [String]())
            let jsonData = try JSONEncoder().encode(user)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            
            let parameters = convertToDictionary(text: jsonString)
            let headers : HTTPHeaders = ["Content-Type": "application/json"]
            AF.request("https://1n8dgv8gxd.execute-api.us-west-1.amazonaws.com/api-v0/auth", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    UserDefaults.standard.set(true, forKey: "onboardingComplete")
                    DispatchQueue.main.async {
                        let next: FeedViewController? = self.storyboard?.instantiateViewController()
                        self.show(next!, sender: self)
                    }
            }
        } catch {  }
    }

    func displayClasses() {
        self.settingsMultiSelectTableView.reloadData()
        self.settingsMultiSelectTableView.reloadSections([0], with: UITableView.RowAnimation.none)
    }

    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 0)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        path.fill()
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension ClassesMultiSelectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func updateSelected(index: Int, to value: Bool) {
        if (self.filteredClasses?.count != 0) {
            self.filteredClasses?[index].selected = value

            guard let mainIndex = self.classes!.firstIndex(where: { (theClass) -> Bool in
                theClass.id == self.filteredClasses?[index].id
            }) else { return }
            self.classes?[mainIndex].selected = value
        } else {
            self.classes?[index].selected = value
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive && self.searchController.searchBar.text != "" {
            return self.filteredClasses?.count ?? 0
        }
        return self.classes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.settingsMultiSelectTableView.dequeueReusableCell(withIdentifier: "ClassesMultiSelectTableViewCell", for: indexPath as IndexPath) as! ClassesMultiSelectTableViewCell
        if (self.filteredClasses?.count != 0) {
            cell.title.text = self.filteredClasses?[indexPath.row].name
            cell.id = self.filteredClasses?[indexPath.row].id
            if (self.filteredClasses?[indexPath.row].selected ?? false) {
                cell.checkBox.image = #imageLiteral(resourceName: "checkbox_selected")
            } else {
                cell.checkBox.image = #imageLiteral(resourceName: "checkbox")
            }

            return cell
        }


        cell.title.text = self.classes?[indexPath.row].name
        cell.id = self.classes?[indexPath.row].id
        if (self.classes?[indexPath.row].selected ?? false) {
            cell.checkBox.image = #imageLiteral(resourceName: "checkbox_selected")
        } else {
            cell.checkBox.image = #imageLiteral(resourceName: "checkbox")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // selected the row
        if (!self.optionsChanged) {
            self.optionsChanged = true
            UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseInOut, animations: {
                self.doneButtonBackgroundView.isHidden = false
                self.settingsMultiSelectTableView.frame = CGRect(x: self.settingsMultiSelectTableView.frame.minX, y: self.settingsMultiSelectTableView.frame.minY, width: self.settingsMultiSelectTableView.frame.width, height: self.settingsMultiSelectTableView.frame.height - self.doneButtonBackgroundView.frame.height)
            }, completion: nil)
        }

        guard let cell = self.settingsMultiSelectTableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as? ClassesMultiSelectTableViewCell else { return }
        guard let cellID = cell.id else { return }

        if (self.selectedClassIDs?.contains(cellID) ?? false) {
            if (self.selectedClassIDs?.count ?? 0 <= 1) { return }

            self.selectedClassIDs = self.selectedClassIDs?.filter { $0 != cell.id }
            self.updateSelected(index: indexPath.row, to: false)

            DispatchQueue.main.async {
                UIView.transition(with: cell.checkBox, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    cell.checkBox.image = #imageLiteral(resourceName: "checkbox")
                })
            }
        } else {
            self.selectedClassIDs?.append(cellID)
            self.updateSelected(index: indexPath.row, to: true)

            DispatchQueue.main.async {
                UIView.transition(with: cell.checkBox, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    cell.checkBox.image = #imageLiteral(resourceName: "checkbox_selected")
                })
            }
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.dismissKeyboardSearch(searchController: self.searchController)
    }
}

extension ClassesMultiSelectViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {

    func filterSettings(searchText: String) {
        self.filteredClasses = self.classes?.filter { theClass in
            let title = theClass.name
            let title_filtered = title.folding(options: .diacriticInsensitive, locale: .current)
            return(title_filtered.lowercased().contains(searchText.lowercased()))
        }

        DispatchQueue.main.async {
            self.settingsMultiSelectTableView.reloadData()
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        self.filterSettings(searchText: searchBarText)
    }

    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            self.isSeachBarAnimationCompleted = true
            searchController.searchBar.becomeFirstResponder()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard self.isSeachBarAnimationCompleted else { return }
        self.isSeachBarAnimationCompleted = false
    }
}
