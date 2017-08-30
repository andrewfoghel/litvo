//
//  MessageLogVC.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/19/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit
import Firebase

var chosenGroup = String()

class MessageLogVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var userGroups = [String]()
    
    let tableView: UITableView = {
        let tv = UITableView(frame: CGRect(x: 0, y: 0, width: width, height: height - navbarHeight))
        return tv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Messages"
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "litvoCompose"), style: .plain, target: self, action: #selector(handleComposeMessage))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeUserGroups()
    }
    
    func setupUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    func observeUserGroups(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("user-groups").child(uid).observe(.value) { (snapshot) in
            self.userGroups.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    self.userGroups.append(snap.key)
                }
            }
            self.tableView.reloadData()
        }
    }

    @objc func handleComposeMessage(){
        performSegue(withIdentifier: "newMessage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        selectedUsers.removeAll()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = userGroups[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        chosenGroup = userGroups[indexPath.row]
        performSegue(withIdentifier: "messageLogToChatLog", sender: nil)
    }

}
