//
//  PublicEventsVC.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/16/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit
import Firebase

class PublicEventsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //DRAG DOWN TO REFRESH!!!!
    
    var allEvents = [PublicEvent]()
    
    let tableView: UITableView = {
        let tv = UITableView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        return tv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Public Events"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    func setupUI(){
        observePosts()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PublicEventCell.self, forCellReuseIdentifier: "cell")
    }
    
    func observePosts(){
        Database.database().reference().child("public-events").observe(.value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                self.allEvents.removeAll()
                for snap in snapshot {
                    if let dictionary = snap.value as? [String : AnyObject]{
                        let publicEvent = PublicEvent()
                        publicEvent.poster = dictionary["poster"] as? String
                        publicEvent.activity = dictionary["activity"] as? String
                        publicEvent.placeImageUrl = dictionary["placeImageUrl"] as? String
                        publicEvent.placeName = dictionary["placeName"] as? String
                        publicEvent.eventId = snap.key
                        publicEvent.userRsvp = dictionary["user-rsvp"] as? [String : AnyObject]
                        
                        if publicEvent.userRsvp == nil {
                            publicEvent.rsvp = 0
                        }else{
                            publicEvent.rsvp = publicEvent.userRsvp!.count
                        }
                        self.allEvents.reverse()
                        self.allEvents.insert(publicEvent, at: 0)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PublicEventCell
        let event = allEvents[indexPath.row]
        if let posterUid = event.poster{
            Database.database().reference().child("users").child(posterUid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String : AnyObject]{
                    cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: dictionary["profileImageUrl"] as! String)
                    cell.userNameLbl.text = dictionary["name"] as? String
                }
            })
        }
        
        if let cellUserUid = event.poster {
            cell.cellUserUid = cellUserUid
        }
        
        if let cellEventId = event.eventId{
            cell.cellEventId = cellEventId
        }
        
        if let rsvpNumber = event.rsvp {
            cell.cellRsvpCount = rsvpNumber
            cell.rsvpLbl.text = "RSVP's: \(rsvpNumber)"
        }
        
        if let userRsvps = event.userRsvp {
            cell.userRsvps = userRsvps
        }
        
        cell.detailsLbl.text = "\(event.activity ?? "No Activity") at \(event.placeName ?? "No Location")"
        cell.locationImageView.loadImageUsingCacheWithUrlString(urlString: event.placeImageUrl!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return width/0.8
    }
    

}
