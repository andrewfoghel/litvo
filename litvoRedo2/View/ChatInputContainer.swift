//
//  ChatInputContainer.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/21/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit

class ChatInputContainerView: UIView, UITextFieldDelegate{
    
    var chatLogController: ChatLogVC? {
        didSet{
            sendBtn.addTarget(chatLogController, action: #selector(ChatLogVC.handleSend), for: .touchUpInside)
            
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: chatLogController, action: #selector(ChatLogVC.handleUploadTap)))
            
        }
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder  = "Enter Message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        return textField
    }()
    
    
    let uploadImageView: UIImageView = {
        let uploadImageView = UIImageView()
        uploadImageView.image = #imageLiteral(resourceName: "litvoAddImage")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.isUserInteractionEnabled = true
        return uploadImageView
    }()
    
    let sendBtn: UIButton = {
        let sendBtn = UIButton(type: .system)
        sendBtn.setTitle("Send", for: .normal)
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        return sendBtn
    }()
    
    let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor =  UIColor.lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(uploadImageView)
        
        uploadImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        addSubview(sendBtn)
        
        sendBtn.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sendBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendBtn.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(self.inputTextField)
        
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendBtn.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(separator)
        
        separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

