//
//  SetEventVC.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/15/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import CoreLocation

class SetEventVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var timestamp: AnyObject?
    
    var scrollViewHeight:CGFloat = 0
    var keyboard = CGRect()
    let scrollView: UIScrollView = {
        let sv = UIScrollView(frame: CGRect(x: 0, y: navbarHeight, width: width, height: height - navbarHeight - tabBarHeight))
        return sv
    }()
    
    let imGoingToLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 0, y: navbarHeight + width/40 , width: width, height: width/15))
        lbl.font = UIFont(name: "Avenir Next", size: width/18)
        lbl.text = "I'm Going To..."
        lbl.textColor = litvoGreen
        lbl.textAlignment = .center
        return lbl
    }()
    
    let addPhotoBtn: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "litvoAddPhoto")
        iv.layer.masksToBounds = true   
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let locationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Location"
        tf.layer.borderColor = litvoGreen.cgColor
        tf.layer.borderWidth = 1
        tf.layer.masksToBounds = true
        tf.font = UIFont(name: "Avenir Next", size: width/20)
        tf.textColor = litvoGreen
        tf.textAlignment = .center
        tf.attributedPlaceholder = NSAttributedString(string: "Enter Location", attributes: [NSAttributedStringKey.foregroundColor: litvoGreen])
        return tf
    }()

    let toLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir Next", size: width/20)
        lbl.textColor = litvoGreen
        lbl.textAlignment = .center
        lbl.text = "To"
        return lbl
    }()
    
    let activityTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Activity"
        tf.layer.borderColor = litvoGreen.cgColor
        tf.layer.borderWidth = 1
        tf.layer.masksToBounds = true
        tf.font = UIFont(name: "Avenir Next", size: width/20)
        tf.textColor = litvoGreen
        tf.textAlignment = .center
        tf.attributedPlaceholder = NSAttributedString(string: "Enter Activity", attributes: [NSAttributedStringKey.foregroundColor: litvoGreen])
        return tf
    }()
    
    let atLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir Next", size: width/20)
        lbl.textColor = litvoGreen
        lbl.textAlignment = .center
        lbl.text = "At"
        return lbl
    }()
    
    let timeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Select Time"
        tf.layer.borderColor = litvoGreen.cgColor
        tf.layer.borderWidth = 1
        tf.layer.masksToBounds = true
        tf.font = UIFont(name: "Avenir Next", size: width/20)
        tf.textColor = litvoGreen
        tf.textAlignment = .center
        tf.attributedPlaceholder = NSAttributedString(string: "Select Time", attributes: [NSAttributedStringKey.foregroundColor: litvoGreen])
        return tf
    }()
    
    let timePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .time
        return dp
    }()
    
    lazy var privatePublicSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Private", "Public"])
        sc.tintColor = litvoGreen
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handlePrivatePublicChange), for: .valueChanged)
        sc.layer.borderColor = litvoGreen.cgColor
        sc.layer.borderWidth = 1
        return sc
    }()
    
    var setEventBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = litvoGreen
        btn.setTitle("Invite Friends", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir Next", size: width/20)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.masksToBounds = true
        return btn
    }()
    
    var address: String?
    var name: String?
    var googleChosen = false
    var tempDownLoadUrl: String?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Set Events"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    
    }

    func setupUI(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
      
        view.addSubview(scrollView)
        scrollView.contentSize.height = height - navbarHeight - tabBarHeight
        scrollViewHeight = scrollView.frame.size.height
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        scrollView.addSubview(imGoingToLabel)
        
        addPhotoBtn.frame = CGRect(x: view.frame.midX - width/6.4, y: imGoingToLabel.frame.origin.y + imGoingToLabel.frame.height + width/40, width: width/3.2, height: width/3.2)
        addPhotoBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChooseImageSourceAndImage)))
        scrollView.addSubview(addPhotoBtn)
        
        locationTextField.frame = CGRect(x: width/20, y: addPhotoBtn.frame.origin.y + addPhotoBtn.frame.height + width/40, width: width - width/10, height: width/10.667)
        locationTextField.layer.cornerRadius = locationTextField.frame.height/2
        scrollView.addSubview(locationTextField)
        
        toLbl.frame = CGRect(x: 0, y: locationTextField.frame.origin.y + locationTextField.frame.height + width/40, width: width, height: width/15)
        scrollView.addSubview(toLbl)
        
        activityTextField.frame = CGRect(x: width/20, y: toLbl.frame.origin.y + toLbl.frame.height + width/40, width: width - width/10, height: width/10.667)
        activityTextField.layer.cornerRadius = activityTextField.frame.height/2
        scrollView.addSubview(activityTextField)
        
        atLbl.frame = CGRect(x: 0, y: activityTextField.frame.origin.y + activityTextField.frame.height + width/40, width: width, height: width/15)
        scrollView.addSubview(atLbl)
        
        timeTextField.frame = CGRect(x: width/20, y: atLbl.frame.origin.y + atLbl.frame.height + width/40, width: width - width/10, height: width/10.667)
        timeTextField.layer.cornerRadius = timeTextField.frame.height/2
        timeTextField.inputView = timePicker
        timeTextField.delegate = self
        scrollView.addSubview(timeTextField)
        
        privatePublicSegmentedControl.frame = CGRect(x: width/20, y: timeTextField.frame.origin.y + timeTextField.frame.height + width/6, width: width - width/10, height: width/10.667)
        privatePublicSegmentedControl.layer.cornerRadius = privatePublicSegmentedControl.frame.height/2
        privatePublicSegmentedControl.layer.masksToBounds = true
        scrollView.addSubview(privatePublicSegmentedControl)
        
        setEventBtn.frame = CGRect(x: width/20, y: privatePublicSegmentedControl.frame.origin.y + privatePublicSegmentedControl.frame.height + width/40 , width: width - width/10, height: width/10.667)
        setEventBtn.layer.cornerRadius = setEventBtn.frame.height/2
        setEventBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSetEvent)))
        scrollView.addSubview(setEventBtn)
        
    }
    
    @objc func handleChooseImageSourceAndImage(gesture: UITapGestureRecognizer){
        print("Add Photo Tapped")
        
        let alert = UIAlertController(title: "Choose Image Source", message: "Choose where you would like to select an image from", preferredStyle: .actionSheet)
       
        let camera = UIAlertAction(title: "Camera", style: .default) { (alert) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        
        let photoLibrary = UIAlertAction(title: "Photos", style: .default) { (alert) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        
        let google = UIAlertAction(title: "Google", style: .default) { (alert) in
            print("Google Click")
            self.handleGoogleClick()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(camera)
        alert.addAction(photoLibrary)
        alert.addAction(google)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        timestamp = timePicker.date.timeIntervalSince1970 as AnyObject
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let timeSelected = dateFormatter.string(from: timePicker.date)
        timeTextField.text = "\(timeSelected)"
    }
    
    @objc func handlePrivatePublicChange(){
        //0 is Private, 1 is Public
        if privatePublicSegmentedControl.selectedSegmentIndex == 0{
            setEventBtn.setTitle("Invite Friends", for: .normal)
        }else{
            setEventBtn.setTitle("Create Event", for: .normal)
        }
    }
    
    @objc func handleSetEvent(gesture: UITapGestureRecognizer){
        if privatePublicSegmentedControl.selectedSegmentIndex == 1 {
            if locationTextField.text! == "" || timeTextField.text! == "" || activityTextField.text! == "" {
                locationTextField.attributedPlaceholder = NSAttributedString(string: "Enter Location", attributes: [NSAttributedStringKey.foregroundColor: colorSmoothRed])
                locationTextField.layer.borderColor = colorSmoothRed.cgColor
            
                activityTextField.attributedPlaceholder = NSAttributedString(string: "Enter Activity", attributes: [NSAttributedStringKey.foregroundColor: colorSmoothRed])
                activityTextField.layer.borderColor = colorSmoothRed.cgColor
            
                timeTextField.attributedPlaceholder = NSAttributedString(string: "Select Time", attributes: [NSAttributedStringKey.foregroundColor: colorSmoothRed])
                timeTextField.layer.borderColor = colorSmoothRed.cgColor
            
                return
            }
        
            if addPhotoBtn.image == #imageLiteral(resourceName: "litvoAddPhoto") {
                appDelegate.errorView(message: "Please Choose A Photo", color: colorSmoothRed)
                return
            }
        
            self.postPublicEventToFirebase()
        }
    }
    
    @objc func showKeyboard(_ notification:Notification) {
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        })
    }
    
    @objc func hideKeyboard(_ notification:Notification) {
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.size.height = height - navbarHeight - tabBarHeight
        })
    }
    
    @objc func dismissKeyboard(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        googleChosen = false
        address = ""
        addPhotoBtn.image = info[UIImagePickerControllerEditedImage] as? UIImage
        addPhotoBtn.layer.cornerRadius = addPhotoBtn.frame.height/2
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func handleGoogleClick(){
        googleChosen = true
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)

    }
    
    func postPublicEventToFirebase(){
        if let image = addPhotoBtn.image{
            if let uploadData = UIImageJPEGRepresentation(image, 0.5){
                let imageUrl = UUID().uuidString
                Storage.storage().reference().child("public-event-images").child(imageUrl).putData(uploadData, metadata: nil, completion: { (metaData, error) in
                    if let err = error{
                        appDelegate.errorView(message: err.localizedDescription, color: colorSmoothRed)
                        return
                    }
                    
                    guard let uid = Auth.auth().currentUser?.uid else{
                        return
                    }
                    
                    if let downloadUrl = metaData?.downloadURL()?.absoluteString{
                        let values: [String : AnyObject] = ["poster" : uid as AnyObject, "placeName" : self.locationTextField.text! as AnyObject, "placeAddress" : self.address as AnyObject , "activity" : self.activityTextField.text! as AnyObject, "timeStamp" : self.timestamp!, "placeImageUrl" : downloadUrl as AnyObject, "rsvp" : 0 as AnyObject]
                        Database.database().reference().child("public-events").childByAutoId().updateChildValues(values, withCompletionBlock: { (error, ref) in
                            if let err = error{
                                appDelegate.errorView(message: err.localizedDescription, color: colorSmoothRed)
                                return
                            }
                        })
                    }
                    
                })
            }
        }
    }
    
}

