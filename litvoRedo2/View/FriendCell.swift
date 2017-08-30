//
//  FriendCell.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/16/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit
import Firebase

class FriendCell: UITableViewCell {
    
    var cellUserId: String?
    let uid = Auth.auth().currentUser?.uid
    var friendFlag: Bool?
    
    
    var searchedTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Avenir Next", size: width/18.82)
        return label
    }()
    
    var myImageView: UIImageView = {
        let searchedImageView = UIImageView()
        searchedImageView.contentMode = .scaleAspectFill
        return searchedImageView
    }()
    
    var friendBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont(name: "Avenir Next", size: 12)
        btn.layer.borderColor = litvoGreen.cgColor
        btn.layer.borderWidth = 1
        btn.setTitleColor(litvoGreen, for: .normal)
        return btn
    }()
    
    var searchedImageView: UIImageView?
    override func layoutSubviews() {
        super.layoutSubviews()
        myImageView.frame = CGRect(x: width/20, y: width/32, width: width/7.11, height: width/7.11)
        
        searchedTextLabel.frame = CGRect(x: myImageView.frame.origin.x + myImageView.frame.size.width + width/64, y: width/14.22, width: self.frame.width - myImageView.frame.origin.x + myImageView.frame.size.width + width/64 , height: width/16)
        
        friendBtn.frame = CGRect(x: width - width/20 - width/5.33 - width/12.5, y: width/17.5, width: width/5.33, height: width/10.67)
        friendBtn.layer.cornerRadius = friendBtn.frame.size.height/2
        friendBtn.layer.masksToBounds = true
        friendBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFollowers)))
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        addSubview(searchedTextLabel)
        addSubview(myImageView)
        addSubview(friendBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleFollowers(gesture: UITapGestureRecognizer){
        
        
        if friendFlag == false{
            //Add Friend
            friendBtn.setTitle("Friend", for: .normal)
            Database.database().reference().child("friends").child(uid!).child(cellUserId!).setValue(1) { (error, ref) in
                if let err = error{
                    print(err.localizedDescription)
                    return
                }
            }
            Database.database().reference().child("friends").child(cellUserId!).child(uid!).setValue(1) { (error, ref) in
                if let err = error{
                    print(err.localizedDescription)
                    return
                }
            }
        }else{
            friendBtn.setTitle("UnFriend", for: .normal)
            Database.database().reference().child("friends").child(uid!).child(cellUserId!).removeValue()
            Database.database().reference().child("friends").child(cellUserId!).child(uid!).removeValue()
        }
        
    }
    
}

