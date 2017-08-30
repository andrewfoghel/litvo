//
//  NewMessageVC.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/19/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit
import Firebase

var selectedUsers = Set<String>()
var selectedUsersArray = [String]()

class NewMessageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //need dismiss keyboard for this page abd profile page
    
    var searchLblBackGround: UILabel?
    var searchIconImageView: UIImageView?
    var searchTxt: UITextField?
    var friends = [User]()
    var filterFriends = [User]()
    var tableView: UITableView?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleStartMessage))
    }
    
    @objc func handleBack(){
        dismiss(animated: true) {
            selectedUsers.removeAll()
        }
    }
    
    @objc func handleStartMessage(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        selectedUsers.insert(uid)
        selectedUsersArray = Array(selectedUsers)
       
        chosenGroup = UUID().uuidString
        performSegue(withIdentifier: "newMessageToChatLog", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        observeFriends()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleSearchFirebase), userInfo: nil, repeats: true)
        
    }
    
    func setupUI(){
        searchLblBackGround = UILabel(frame: CGRect(x: width/20, y: width/8, width: width/8, height: width/10.67))
        searchLblBackGround?.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        searchLblBackGround?.layer.cornerRadius = width/64
        searchLblBackGround?.layer.zPosition = 3
        searchLblBackGround?.layer.masksToBounds = true
        view.addSubview(searchLblBackGround!)
        
        searchIconImageView = UIImageView(frame: CGRect(x: width/12, y: width/8 + width/21.34 - width/48, width: width/24, height: width/24))
        searchIconImageView?.image = #imageLiteral(resourceName: "litvoSearch")
        searchIconImageView?.layer.zPosition = 4
        searchIconImageView?.layer.masksToBounds = true
        view.addSubview(searchIconImageView!)
        
        searchTxt = UITextField(frame: CGRect(x: (searchLblBackGround?.frame.origin.x)! + (searchLblBackGround?.frame.size.width)! - width/64, y: width/8, width: width - (searchLblBackGround?.frame.origin.x)! - (searchLblBackGround?.frame.size.width)! + width/64 - width/20, height: width/10.67))
        searchTxt?.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        searchTxt?.font = UIFont(name: "Avenir Next", size: 17)
        searchTxt?.placeholder = "Search Users"
        searchTxt?.layer.cornerRadius = width/64
        searchTxt?.clearButtonMode = .always
        searchTxt?.layer.zPosition = 3
        searchTxt?.layer.masksToBounds = true
        view.addSubview(searchTxt!)
        
        tableView = UITableView(frame: CGRect(x: width/20, y: (searchLblBackGround?.frame.origin.y)! + (searchLblBackGround?.frame.size.height)!, width: width - width/10, height: height))
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(NewMessageCell.self, forCellReuseIdentifier: "cell")
        tableView?.layer.cornerRadius = width/64
        tableView?.layer.masksToBounds = true
        tableView?.separatorStyle = .none
        tableView?.backgroundColor = litvoGreen
        view.addSubview(tableView!)
        
    }
    
    @objc func handleSearchFirebase(){
        if searchTxt?.text == ""{
            tableView?.frame.size.height = CGFloat(friends.count) * width/4.923
        }else{
            tableView?.frame.size.height = CGFloat(filterFriends.count) * width/4.923
            filterFriends.removeAll()
            for user in friends {
                if let searchText = searchTxt?.text{
                    if user.name!.lowercased().contains(searchText.lowercased()){
                        filterFriends.append(user)
                    }
                }
            }
        }
        tableView?.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchTxt?.text == ""{
            return friends.count
        }else{
            return filterFriends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewMessageCell
        cell.backgroundColor = litvoGreen
        var user = User()
        if searchTxt?.text == ""{
             user = friends[indexPath.row]
        }else{
             user = filterFriends[indexPath.row]
        }
        cell.myImageView.loadImageUsingCacheWithUrlString(urlString: user.profileImageUrl!)
        cell.searchedTextLabel.text = user.name
        cell.cellUserId = user.uid
        
        if selectedUsers.contains(user.uid!){
            cell.invitationSquareBtn.image = #imageLiteral(resourceName: "litvoInvited")
        }else{
            cell.invitationSquareBtn.image = #imageLiteral(resourceName: "litvoUninvited")
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return width/4.923
    }
    
    func observeFriends(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        Database.database().reference().child("friends").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            self.friends.removeAll()
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshot{
                        Database.database().reference().child("users").child(snap.key).observeSingleEvent(of: .value, with: { (snapshot) in
                            if let dictionary = snapshot.value as? [String:AnyObject]{
                                let user = User()
                                user.uid = snapshot.key
                                user.name = dictionary["name"] as? String
                                user.email = dictionary["email"] as? String
                                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                                self.friends.append(user)
                                DispatchQueue.main.async {
                                    self.tableView?.reloadData()
                                    print("AA: \(self.friends.count)")
                                }
                            }
                        })
                    }
                }
            })
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}

