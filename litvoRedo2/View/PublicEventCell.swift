//
//  PublicEventCell.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/16/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit
import Firebase

class PublicEventCell: UITableViewCell {
    
    var cellUserUid = String()
    var cellEventId = String()
    var cellRsvpCount = Int()
    var userRsvps: [String : AnyObject]?
    var usersInChat =  Set<String>()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = litvoGreen.cgColor
        iv.layer.borderWidth = 1
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let userNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = litvoGreen
        lbl.font = UIFont(name: "Avenir Next", size: width/18.823)
        return lbl
    }()
    
    let rsvpLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont(name: "Avenir Next", size: width/29.09)
        lbl.textAlignment = .center
        lbl.backgroundColor = litvoGreen
        lbl.layer.masksToBounds = true
        lbl.isUserInteractionEnabled = true
        return lbl
    }()
    
    let detailsLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = litvoGreen
        lbl.font = UIFont(name: "Avenir Next", size: width/18.823)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let locationImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.borderColor = litvoGreen.cgColor
        iv.layer.borderWidth = 1
        return iv
    }()
    
    let timeLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = litvoGreen
        lbl.text = "Taking place at 12:12 am"
        lbl.font = UIFont(name: "Avenir Next", size: width/29.09)
        lbl.textAlignment = .center
        return lbl
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.frame = CGRect(x: width/40, y: width/40, width: width/6.4, height: width/6.4)
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        
        userNameLbl.frame = CGRect(x: profileImageView.frame.origin.x + profileImageView.frame.width + width/40, y: profileImageView.frame.midX - width/32, width: width/1.9, height: width/16)
        
        rsvpLbl.frame = CGRect(x: userNameLbl.frame.origin.x + userNameLbl.frame.width, y: userNameLbl.frame.origin.y, width: width/4, height: width/16)
        rsvpLbl.layer.cornerRadius = rsvpLbl.frame.height/2
        rsvpLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRSVP)))
        
        detailsLbl.frame = CGRect(x: 0, y: profileImageView.frame.origin.y + profileImageView.frame.height + width/40, width: width, height: width/16)
        
        locationImageView.frame = CGRect(x: width/40, y: detailsLbl.frame.origin.y + detailsLbl.frame.height + width/40, width: width - width/20, height: width/1.207)
        locationImageView.layer.cornerRadius = width/64
        
        timeLbl.frame = CGRect(x: 0, y: locationImageView.frame.origin.y + locationImageView.frame.height + width/20, width: width, height: width/16)
        
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        addSubview(profileImageView)
        addSubview(userNameLbl)
        addSubview(rsvpLbl)
        addSubview(detailsLbl)
        addSubview(locationImageView)
        addSubview(timeLbl)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleRSVP(gesture: UITapGestureRecognizer){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        if uid == cellUserUid {
            appDelegate.errorView(message: "You Can't RSVP Your Own Event", color: colorSmoothRed)
            return
        }
        
        if userRsvps == nil || cellRsvpCount == 0{
            Database.database().reference().child("public-events").child(cellEventId).child("user-rsvp").updateChildValues([uid : 1], withCompletionBlock: { (error, ref) in
                if let err = error{
                    appDelegate.errorView(message: err.localizedDescription, color: colorSmoothRed)
                    return
                }
            })
            
            Database.database().reference().child("public-events").child(cellEventId).updateChildValues(["rsvp" : 1], withCompletionBlock: { (error, ref) in
                if let err = error{
                    appDelegate.errorView(message: err.localizedDescription, color: colorSmoothRed)
                    return
                }
            })
        }else{
            usersInChat.removeAll()
            for userRsvp in userRsvps! {
                usersInChat.insert(userRsvp.key)
                if usersInChat.contains(uid) {
                    Database.database().reference().child("public-events").child(cellEventId).child("user-rsvp").child(uid).removeValue(completionBlock: { (error, ref) in
                        if let err = error{
                            appDelegate.errorView(message: err.localizedDescription, color: colorSmoothRed)
                            return
                        }
                    })
                    Database.database().reference().child("public-events").child(cellEventId).updateChildValues(["rsvp" : cellRsvpCount - 1], withCompletionBlock: { (error, ref) in
                        if let err = error {
                            appDelegate.errorView(message: err.localizedDescription, color: colorSmoothRed)
                            return
                        }
                    })
                } else {
                    print("Add User")
                    Database.database().reference().child("public-events").child(cellEventId).child("user-rsvp").updateChildValues([uid : 1], withCompletionBlock: { (error, ref) in
                        if let err = error {
                            appDelegate.errorView(message: err.localizedDescription, color: colorSmoothRed)
                            return
                        }
                    })
                    
                    Database.database().reference().child("public-events").child(cellEventId).updateChildValues(["rsvp" : cellRsvpCount + 1], withCompletionBlock: { (error, ref) in
                        if let err = error {
                            appDelegate.errorView(message: err.localizedDescription, color: colorSmoothRed)
                            return
                        }
                    })
                }
            }
        }
    }
}
