//
//  NewMessageCell.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/20/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit

class NewMessageCell: UITableViewCell {

    var cellUserId: String?
    
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

    var invitationSquareBtn: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "litvoUninvited")
        return iv
    }()
    
    var searchedImageView: UIImageView?
    override func layoutSubviews() {
        super.layoutSubviews()
        myImageView.frame = CGRect(x: width/20, y: width/32, width: width/7.11, height: width/7.11)
        myImageView.layer.cornerRadius = myImageView.frame.height/2
        myImageView.layer.masksToBounds = true
        
        searchedTextLabel.frame = CGRect(x: myImageView.frame.origin.x + myImageView.frame.size.width + width/64, y: width/14.22, width: self.frame.width - myImageView.frame.origin.x + myImageView.frame.size.width + width/64 , height: width/16)
        
        invitationSquareBtn.frame = CGRect(x: width - width/20 - width/10.67 - width/12.5, y: width/17.5, width: width/10.67, height: width/10.67)
        invitationSquareBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleIniviteUser)))
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        addSubview(searchedTextLabel)
        addSubview(myImageView)
        addSubview(invitationSquareBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleIniviteUser(gesture: UITapGestureRecognizer){
        
        if !selectedUsers.contains(cellUserId!){
            selectedUsers.insert(cellUserId!)
            invitationSquareBtn.image = #imageLiteral(resourceName: "litvoInvited")
        }else{
            selectedUsers.remove(cellUserId!)
            invitationSquareBtn.image = #imageLiteral(resourceName: "litvoUninvited")
        }
    }
    
}
