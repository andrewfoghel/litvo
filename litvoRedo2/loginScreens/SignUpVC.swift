//
//  SignUpVC.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/14/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var scrollViewHeight:CGFloat = 0
    var keyboard = CGRect()
    let scrollView: UIScrollView = {
        let sv = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        return sv
    }()
    
    let logoImageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: midX - width/8.532, y: width/8, width: width/4.266, height: width/4.266))
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.image = #imageLiteral(resourceName: "litvoUser")
        return iv
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.font = UIFont(name: "Avenir Next", size: width/20)
        tf.textColor = .white
        tf.layer.borderColor = UIColor.white.cgColor
        tf.layer.borderWidth = 1
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        tf.layer.masksToBounds = true
        tf.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.font = UIFont(name: "Avenir Next", size: width/20)
        tf.textColor = .white
        tf.layer.borderColor = UIColor.white.cgColor
        tf.layer.borderWidth = 1
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        tf.layer.masksToBounds = true
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        return tf
    }()

    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.font = UIFont(name: "Avenir Next", size: width/20)
        tf.textColor = .white
        tf.layer.borderColor = UIColor.white.cgColor
        tf.layer.borderWidth = 1
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        tf.layer.masksToBounds = true
        tf.isSecureTextEntry = true
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        return tf
    }()
    
    let confirmPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Reenter Password"
        tf.font = UIFont(name: "Avenir Next", size: width/20)
        tf.textColor = .white
        tf.layer.borderColor = UIColor.white.cgColor
        tf.layer.borderWidth = 1
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        tf.layer.masksToBounds = true
        tf.isSecureTextEntry = true
        tf.attributedPlaceholder = NSAttributedString(string: "Reenter Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        return tf
    }()
    
    let signUpBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign Up", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir Next", size: width/20)
        btn.backgroundColor = .white
        btn.setTitleColor(litvoGreen, for: .normal)
        btn.layer.masksToBounds = true
        return btn
    }()
    
    let cancelBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Cancel", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir Next", size: width/20)
        btn.backgroundColor = .white
        btn.setTitleColor(litvoGreen, for: .normal)
        btn.layer.masksToBounds = true
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()

    }

    func setupUI(){
        view.backgroundColor = litvoGreen
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        view.addSubview(scrollView)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        logoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loadImg)))
        scrollView.addSubview(logoImageView)
    
        nameTextField.frame = CGRect(x: width/20 , y: logoImageView.frame.origin.y + logoImageView.frame.height + width/8 , width: width - width/10, height: width/10.667)
        nameTextField.layer.cornerRadius = nameTextField.frame.height/2
        scrollView.addSubview(nameTextField)
        
        
        emailTextField.frame = CGRect(x: width/20, y: nameTextField.frame.origin.y + nameTextField.frame.height + width/40, width: width - width/10, height: width/10.667)
        emailTextField.layer.cornerRadius = emailTextField.frame.height/2
        scrollView.addSubview(emailTextField)
        
        passwordTextField.frame = CGRect(x: width/20, y: emailTextField.frame.origin.y + emailTextField.frame.height + width/40, width: width - width/10, height: width/10.667)
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height/2
        scrollView.addSubview(passwordTextField)
        
        confirmPasswordTextField.frame = CGRect(x: width/20, y: passwordTextField.frame.origin.y + passwordTextField.frame.height + width/40, width: width - width/10, height: width/10.667)
        confirmPasswordTextField.layer.cornerRadius = confirmPasswordTextField.frame.height/2
        scrollView.addSubview(confirmPasswordTextField)
        
        signUpBtn.frame = CGRect(x: width/20, y: confirmPasswordTextField.frame.origin.y + confirmPasswordTextField.frame.height + width/20, width: (width - width/10)/2 - width/80, height: width/10.667)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.height/2
        signUpBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSignUp)))
        scrollView.addSubview(signUpBtn)
        
        cancelBtn.frame = CGRect(x: width/20 + (width - width/10)/2 + width/80, y: confirmPasswordTextField.frame.origin.y + confirmPasswordTextField.frame.height + width/20, width: (width - width/10)/2 - width/80, height: width/10.667)
        cancelBtn.layer.cornerRadius = cancelBtn.frame.height/2
        cancelBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCancel)))
        scrollView.addSubview(cancelBtn)
        
    }
    
    @objc func loadImg(gesture: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        logoImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        logoImageView.layer.cornerRadius = width/64
        logoImageView.layer.masksToBounds = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showKeyboard(_ notification:Notification) {
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        })
    }
    
    @objc func hideKeyboard(_ notification:Notification) {
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.size.height = self.view.frame.height
        })
    }
    
    @objc func handleCancel(gesture: UITapGestureRecognizer){
        dismiss(animated: false, completion: nil)
    }
    
    @objc func handleSignUp(){
       
        if  nameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" || confirmPasswordTextField.text == "" {
            
            nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedStringKey.foregroundColor: colorSmoothRed])
            nameTextField.layer.borderColor = colorSmoothRed.cgColor
            
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: colorSmoothRed])
            emailTextField.layer.borderColor = colorSmoothRed.cgColor
            
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: colorSmoothRed])
            passwordTextField.layer.borderColor = colorSmoothRed.cgColor
            
            confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Reenter Password", attributes: [NSAttributedStringKey.foregroundColor: colorSmoothRed])
            confirmPasswordTextField.layer.borderColor = colorSmoothRed.cgColor
            
            if logoImageView.image == #imageLiteral(resourceName: "litvoUser") {
                logoImageView.image = #imageLiteral(resourceName: "litvoUserError")
                return
            }
            
            return
        }
        
        if passwordTextField.text != confirmPasswordTextField.text {
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: colorSmoothRed])
            passwordTextField.layer.borderColor = colorSmoothRed.cgColor
            
            confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Reenter Password", attributes: [NSAttributedStringKey.foregroundColor: colorSmoothRed])
            confirmPasswordTextField.layer.borderColor = colorSmoothRed.cgColor
            
            appDelegate.errorView(message: "Passwords Don't Match", color: colorSmoothRed)
            return
        }
        
        if logoImageView.image == #imageLiteral(resourceName: "litvoUserError") {
            appDelegate.errorView(message: "Please Choose An Image", color: colorSmoothRed)
            return
        }
        
        if let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text{
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if let err = error{
                    appDelegate.errorView(message: err.localizedDescription, color: colorSmoothRed)
                    return
                }
                guard let image = self.logoImageView.image else{
                    return
                }
                if let uploadData = UIImageJPEGRepresentation(image, 0.5){
                    let imageUrl = NSUUID().uuidString
                    Storage.storage().reference().child("user-profile-images").child(imageUrl).putData(uploadData, metadata: nil, completion: { (metaData, error) in
                        
                        if let err = error{
                            appDelegate.errorView(message: err.localizedDescription, color: colorSmoothRed)
                            return
                        }
                        if let downloadUrl = metaData?.downloadURL()?.absoluteString {
                            Database.database().reference().child("users").child(user!.uid).updateChildValues(["email" : email, "name" : name, "profileImageUrl" : downloadUrl], withCompletionBlock: { (error, ref) in
                                if let err = error{
                                    appDelegate.errorView(message: err.localizedDescription, color: colorSmoothRed)
                                }
                                self.performSegue(withIdentifier: "signUpSuccessful", sender: nil)
                            })
                        }
                        
                    })
                }
            })
        }
    }
    
    @objc func dismissKeyboard(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }

}

