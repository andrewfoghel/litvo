//
//  ChatMessageCell.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/22/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit
import AVFoundation

let messageBlue = UIColor(r: 39, g: 146, b: 246)

class ChatMessageCell: UICollectionViewCell {
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
   
    var message: Message?
    var chatLogController = ChatLogVC()
    
    let activityMonitor: UIActivityIndicatorView = {
        let am = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        am.translatesAutoresizingMaskIntoConstraints = false
        am.hidesWhenStopped = true
        return am
    }()

    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = messageBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let messageTextView: UITextView = {
        let tv = UITextView()
        tv.text = "sample text for now"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = UIColor.clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textColor = .white
        tv.isEditable = false
        return tv
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    let blackBackgroundView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: -navbarHeight, width: width, height: height + navbarHeight))
        view.backgroundColor = .black
        return view
    }()
    
    let stopVideoBtn: UIImageView = {
        let btn = UIImageView()
        btn.contentMode = .scaleAspectFill
        btn.isUserInteractionEnabled = true
        btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stopVideo)))
        btn.image = #imageLiteral(resourceName: "litvoStop")
        btn.layer.masksToBounds = true
        return btn
    }()
    
    var playerLayer: AVPlayerLayer?
    var player:AVPlayer?
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = #imageLiteral(resourceName: "litvoPlay")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        return button
    }()
    
    @objc func handleZoomTap(gesture: UITapGestureRecognizer){
        if message?.videoUrl != nil{
            return
        }
        
        if let imageView = gesture.view as? UIImageView{
            self.chatLogController.performZoomInForstartingImageView(startingImageView: imageView)
        }
    }
    
    @objc func handlePlay(gesture: UITapGestureRecognizer){
        if let videoUrlString = message?.videoUrl{
            if let url = URL(string: videoUrlString){
                player = AVPlayer(url: url)
                playerLayer = AVPlayerLayer(player: player)
                playerLayer?.frame = UIScreen.main.bounds
                chatLogController.view.addSubview(blackBackgroundView)
                blackBackgroundView.layer.addSublayer(playerLayer!)
                blackBackgroundView.addSubview(stopVideoBtn)
                chatLogController.inputContainer.alpha = 0
                chatLogController.navigationController?.navigationBar.isHidden = true
                player?.isMuted = false
                player?.play()
                self.activityMonitor.startAnimating()
                playButton.isHidden = true
                
                NotificationCenter.default.addObserver(self, selector: #selector(prepareForReuse), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)

            }
        }
    }
    
    @objc func stopVideo(gesture: UITapGestureRecognizer){
        print("stop")
        /*   stopVideoBtn.removeFromSuperview()
        blackBackgroundView.removeFromSuperview()
        playerLayer?.removeFromSuperlayer()
        chatLogController.inputContainer.alpha = 1
        chatLogController.navigationController?.navigationBar.isHidden = false
        player?.pause()
        player?.isMuted = true
        activityMonitor.stopAnimating()
        playButton.isHidden = false */
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        blackBackgroundView.removeFromSuperview()
        playerLayer?.removeFromSuperlayer()
        chatLogController.inputContainer.alpha = 1
        chatLogController.navigationController?.navigationBar.isHidden = false
        player?.pause()
        player?.isMuted = true
        activityMonitor.stopAnimating()
        playButton.isHidden = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        addSubview(bubbleView)
        addSubview(messageTextView)
        bubbleView.addSubview(messageImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        messageTextView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        messageTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        messageTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        bubbleView.addSubview(playButton)
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        blackBackgroundView.addSubview(activityMonitor)
        activityMonitor.frame = CGRect(x: blackBackgroundView.frame.midX - 25, y: blackBackgroundView.frame.midY - 25, width: 50, height: 50)
        stopVideoBtn.frame = CGRect(x: width/40, y: width/16, width: width/16, height: width/16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
}
