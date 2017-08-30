//
//  FriendVC.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/16/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit

import UIKit
import Firebase

var userFriends = [String]()

class FriendVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var searchLblBackGround: UILabel?
    var searchIconImageView: UIImageView?
    var searchTxt: UITextField?
    var users = [User]()
    var filteredUsers = [User]()
    var tableView: UITableView?
    var followUser = User()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Profile"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        observeAllUsers()
        observeFriends()

        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleSearchFirebase), userInfo: nil, repeats: true)
    }
    
    func setupUI(){
        searchLblBackGround = UILabel(frame: CGRect(x: width/20, y: navbarHeight, width: width/8, height: width/10.67))
        searchLblBackGround?.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        searchLblBackGround?.layer.cornerRadius = width/64
        searchLblBackGround?.layer.zPosition = 3
        searchLblBackGround?.layer.masksToBounds = true
        view.addSubview(searchLblBackGround!)
        
        searchIconImageView = UIImageView(frame: CGRect(x: width/12, y: navbarHeight + width/21.34 - width/48, width: width/24, height: width/24))
        searchIconImageView?.image = #imageLiteral(resourceName: "litvoSearch")
        searchIconImageView?.layer.zPosition = 4
        searchIconImageView?.layer.masksToBounds = true
        view.addSubview(searchIconImageView!)
        
        searchTxt = UITextField(frame: CGRect(x: (searchLblBackGround?.frame.origin.x)! + (searchLblBackGround?.frame.size.width)! - width/64, y: navbarHeight, width: width - (searchLblBackGround?.frame.origin.x)! - (searchLblBackGround?.frame.size.width)! + width/64 - width/20, height: width/10.67))
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
        tableView?.register(FriendCell.self, forCellReuseIdentifier: "cell")
        tableView?.layer.cornerRadius = width/64
        tableView?.layer.masksToBounds = true
        tableView?.separatorStyle = .none
        tableView?.backgroundColor = litvoGreen
        view.addSubview(tableView!)
        
    }
    
    @objc func handleSearchFirebase(){
        tableView?.frame.size.height = CGFloat(filteredUsers.count) * width/4.923
        filteredUsers.removeAll()
        for user in users {
            if let searchText = searchTxt?.text{
                if user.name?.lowercased() == searchText.lowercased(){
                    filteredUsers.append(user)
                }
            }
        }
        tableView?.reloadData()
    }
    
    func observeAllUsers(){
        Database.database().reference().child("users").observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                self.users.removeAll()
                for snap in snapshot{
                    if let dictionary = snap.value as? [String:AnyObject]{
                        let user = User()
                        user.name = dictionary["name"] as? String
                        user.email = dictionary["email"] as? String
                        user.uid = snap.key
                        user.profileImageUrl = dictionary["profileImageUrl"] as? String
                        
                        guard let currentUserUid = Auth.auth().currentUser?.uid else{
                            return
                        }
                        
                        if user.uid != currentUserUid{
                            self.users.append(user)
                        }
                    }
                }
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendCell
            cell.backgroundColor = litvoGreen
            cell.selectionStyle = .none
            let user = filteredUsers[indexPath.row]
            
            cell.myImageView.loadImageUsingCacheWithUrlString(urlString: user.profileImageUrl!)
            cell.myImageView.layer.cornerRadius = cell.myImageView.frame.size.width/2
            cell.myImageView.layer.masksToBounds = true
            cell.searchedTextLabel.text = user.name
            cell.cellUserId = user.uid
            
            if userFriends.contains(cell.cellUserId!){
                cell.friendFlag = true
                cell.friendBtn.setTitle("Unfriend", for: .normal)
            }else{
                cell.friendFlag = false
                cell.friendBtn.setTitle("Friend", for: .normal)
            }

            cell.layer.cornerRadius = width/64
            cell.layer.masksToBounds = true
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return width/4.923
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.row]
        followUser = user
    }
    
    func observeFriends(){
        Database.database().reference().child("friends").child((Auth.auth().currentUser?.uid)!).observe(.value, with: { (snapshot) in
            userFriends.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    userFriends.append(snap.key)
                    DispatchQueue.main.async {
                        self.tableView?.reloadData()
                    }
                }
            }
        })
    }
    
    @objc func handleBack(gesture: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
    
}

