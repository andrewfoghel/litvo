//
//  ChatLogVC.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/19/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class ChatLogVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var messages = [Message]()
    
    lazy var inputContainer: ChatInputContainerView = {
        let chatInputContainer = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        chatInputContainer.chatLogController = self
        return chatInputContainer
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: width, height: height - navbarHeight - 70), collectionViewLayout: layout)
        cv.keyboardDismissMode = .interactive
        cv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        cv.alwaysBounceVertical = true
        cv.backgroundColor = UIColor.clear
        return cv
    }()
    
    let layout = UICollectionViewFlowLayout()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        observeMessages()
        setupUI()
        setupKeyboardObservers()
    }
    
    func setupUI(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override var inputAccessoryView: UIView?{
        get{
            return inputContainer
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    @objc func handleKeyboardDidShow(){
        if messages.count > 0{
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    @objc func keyboardWillShow(notification: Notification){
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyBoardDuration = userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as! Double
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        UIView.animate(withDuration: keyBoardDuration) {
            self.collectionView.frame = CGRect(x: 0, y: 0, width: width, height: height - keyboardHeight - 70)
        //    self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyBoardDuration = userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as! Double
        
        UIView.animate(withDuration: keyBoardDuration) {
            self.collectionView.frame = CGRect(x: 0, y: 0, width: width, height: height - 70)
       //     self.view.layoutIfNeeded()
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChatMessageCell
        cell.chatLogController = self
        cell.backgroundColor = .clear
        let message = messages[indexPath.row]
        cell.message = messages[indexPath.row]
        setupCell(cell: cell, message: message)
        cell.messageTextView.text = message.text
        cell.playButton.isHidden = message.videoUrl == nil
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        var heightForCell: CGFloat = 80
        let message = messages[indexPath.item]
        if let text = message.text{
            heightForCell = estimateFrameForText(text: text).height + 20
        }else if let imageWidth = message.imageWidth?.floatValue, let imageheight = message.imageHeight?.floatValue{
            heightForCell =  CGFloat(imageheight / imageWidth * 200)
        }
        
        return CGSize(width: width, height: heightForCell)
    }
    
   func estimateFrameForText(text: String)->CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
   func setupCell(cell: ChatMessageCell, message: Message){
        Database.database().reference().child("users").child(message.sender!).observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject]{
                cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: dictionary["profileImageUrl"] as! String)
            }
        }
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        if message.sender == uid{
            cell.bubbleView.backgroundColor = messageBlue
            cell.messageTextView.textColor = .white
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.bubbleViewRightAnchor?.isActive = true
            cell.profileImageView.isHidden = true
        }else{
            cell.bubbleView.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0)
            cell.messageTextView.textColor = .black
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.bubbleViewRightAnchor?.isActive = false
            cell.profileImageView.isHidden = false
        }
         
    
        if let messageImageUrl = message.imageUrl{
            cell.messageImageView.loadImageUsingCacheWithUrlString(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.messageTextView.isHidden = true
            cell.bubbleView.backgroundColor = UIColor.clear
            
        }else{
            cell.messageTextView.isHidden = false
            cell.messageImageView.isHidden = true
        }
    
    }
    
    @objc func handleSend(){
        let properties: [String:AnyObject] = ["text":inputContainer.inputTextField.text as AnyObject]
        sendMessageWithProperties(properties: properties)
    }
    
    func sendMessageWithProperties(properties: [String : AnyObject]){
        let reference = Database.database().reference().child("messages")
        let childRef = reference.childByAutoId()
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let timeStamp = Date().timeIntervalSince1970
        var values: [String : AnyObject] = ["sender" : uid as AnyObject, "timeStamp" : timeStamp as AnyObject]
        properties.forEach({values[$0] = $1})
        
       childRef.updateChildValues(values) { (error, ref) in
            if let err = error{
                appDelegate.errorView(message: err.localizedDescription, color: colorSmoothRed)
                return
            }
        
            self.inputContainer.inputTextField.text = ""
            let messageId = childRef.key
            Database.database().reference().child("groups").child(chosenGroup).updateChildValues([messageId : 1], withCompletionBlock: { (error, ref) in
                if let err = error{
                    appDelegate.errorView(message: err.localizedDescription, color: colorSmoothRed)
                }
            })
        
            for userUid in selectedUsersArray{
                Database.database().reference().child("user-groups").child(userUid).updateChildValues([chosenGroup : 1], withCompletionBlock: { (error, ref) in
                    if let err = error{
                        appDelegate.errorView(message: err.localizedDescription, color: colorSmoothRed)
                    }
                })
            }
        }
    }
    
    @objc func handleUploadTap(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
    
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL{
            print("video")
            
            let filename = UUID().uuidString
            Storage.storage().reference().child("videos").child(filename).putFile(from: videoUrl, metadata: nil, completion: { (metadata, error) in
                if let err = error{
                    appDelegate.errorView(message: err.localizedDescription, color: colorSmoothRed)
                    return
                }
                if let downloadUrl = metadata?.downloadURL()?.absoluteString{
                    if let thumbnailImage = self.thumbNailImageForVideo(videoUrl: videoUrl){
                        self.uploadToFirebaseStorageUsingImage(selectedImage: thumbnailImage, completion: { (imageUrl) in
                            let properties: [String:AnyObject] = ["videoUrl":downloadUrl as AnyObject,"imageUrl":imageUrl as AnyObject,"imageWidth":thumbnailImage.size.width as AnyObject,"imageHeight":thumbnailImage.size.height as AnyObject]
                            self.sendMessageWithProperties(properties: properties)
                            
                        })
                    }
                }
            })
        }else{
            print("image")
            if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
                selectedImageFromPicker = editedImage
            }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
                selectedImageFromPicker = originalImage
            }
            if let selectedImage = selectedImageFromPicker{
                uploadToFirebaseStorageUsingImage(selectedImage: selectedImage, completion: { (imageUrl) in
                    self.sendMessageWithImageUrl(imageUrl: imageUrl,image: selectedImage)
                })
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func thumbNailImageForVideo(videoUrl: URL) -> UIImage?{
        let asset = AVAsset(url: videoUrl)
        let assetGenterator = AVAssetImageGenerator(asset: asset)

        do{
            let thumbnailCGImage = try assetGenterator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            
            return UIImage(cgImage: thumbnailCGImage)
            
        }catch let err{
            print(err.localizedDescription)
        }
        return nil
        
    }

    func uploadToFirebaseStorageUsingImage(selectedImage: UIImage, completion:@escaping (_ imageUrl:String)->()){
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(selectedImage, 0.2){
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if let err = error{
                    print("failed: ",err.localizedDescription)
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString{
                    completion(imageUrl)
                }
                
            })
        }
    }
    
    func sendMessageWithImageUrl(imageUrl: String, image: UIImage){
        let properties: [String:AnyObject] = ["imageUrl":imageUrl as AnyObject,"imageWidth":image.size.width as AnyObject,"imageHeight":image.size.height as AnyObject]
        
        sendMessageWithProperties(properties: properties)
        
    }
    
    func observeMessages(){
        Database.database().reference().child("groups").child(chosenGroup).observe(.value) { (snapshot) in
            self.messages.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                   self.fetchMessageInfo(messageId: snap.key)
                }
            }
        }
    }
    
    func fetchMessageInfo(messageId: String){
        Database.database().reference().child("messages").child(messageId).observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject]{
                let message = Message(dictionary: dictionary)
                self.messages.append(message)
            }
            self.collectionView.reloadData()
            let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    var startingFrame: CGRect?
    var blackBackGround: UIView?
    var startingImageView: UIImageView?
    func performZoomInForstartingImageView(startingImageView: UIImageView){
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow{
            
            
            blackBackGround = UIView(frame: keyWindow.frame)
            blackBackGround?.backgroundColor = .black
            blackBackGround?.alpha = 0
            keyWindow.addSubview(blackBackGround!)
            
            keyWindow.addSubview(zoomingImageView)
            
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let height = (self.startingFrame?.height)! / (self.startingFrame?.width)! * keyWindow.frame.width
                self.blackBackGround?.alpha = 1
                self.inputContainer.alpha = 0
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
            }, completion: { (completed) in
                
            })
            
            
        }
        
        
    }
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer){
        if let zoomOutImageView = tapGesture.view{
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackGround?.alpha = 0
                self.inputContainer.alpha = 1
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
            
            
            
        }
    }
    
    
}
