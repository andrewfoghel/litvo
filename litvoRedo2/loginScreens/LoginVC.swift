//
//  LoginVC.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/14/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

let width = UIScreen.main.bounds.width
let height = UIScreen.main.bounds.height
let midX = UIScreen.main.bounds.midX
let litvoGreen = UIColor(r: 70, g: 179, b:83)

class LoginVC: UIViewController, FBSDKLoginButtonDelegate {
    
    var scrollViewHeight:CGFloat = 0
    var keyboard = CGRect()
    let scrollView: UIScrollView = {
        let sv = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        return sv
    }()
    
    let logoImageView: UIImageView = {
       let iv = UIImageView(frame: CGRect(x: midX - width/6.4, y: width/8, width: width/3.2, height: width/3.2))
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "litvoIcon")
        return iv
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
    
    let signInBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign In", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir Next", size: width/20)
        btn.backgroundColor = .white
        btn.setTitleColor(litvoGreen, for: .normal)
        btn.layer.masksToBounds = true
        return btn
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
    
    let faceLoginButton = FBSDKLoginButton()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
        
    }

    func setupUI(){
        view.backgroundColor = litvoGreen
        
        view.addSubview(scrollView)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        scrollView.addSubview(logoImageView)
        
        
        emailTextField.frame = CGRect(x: width/20 , y: logoImageView.frame.origin.y + logoImageView.frame.height + width/8 , width: width - width/10, height: width/10.667)
        emailTextField.layer.cornerRadius = emailTextField.frame.height/2
        scrollView.addSubview(emailTextField)
        
       
        passwordTextField.frame = CGRect(x: width/20, y: emailTextField.frame.origin.y + emailTextField.frame.height + width/40, width: width - width/10, height: width/10.667)
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height/2
        scrollView.addSubview(passwordTextField)
        
        
        signInBtn.frame = CGRect(x: width/20, y: passwordTextField.frame.origin.y + passwordTextField.frame.height + width/20, width: (width - width/10)/2 - width/80, height: width/10.667)
        signInBtn.layer.cornerRadius = signInBtn.frame.height/2
        signInBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSignIn)))
        scrollView.addSubview(signInBtn)
        
        signUpBtn.frame = CGRect(x: width/20 + (width - width/10)/2 + width/80, y: passwordTextField.frame.origin.y + passwordTextField.frame.height + width/20, width: (width - width/10)/2 - width/80, height: width/10.667)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.height/2
        signUpBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSignUpBtnClick)))
        scrollView.addSubview(signUpBtn)
        
        faceLoginButton.frame = CGRect(x: width/20, y: signInBtn.frame.origin.y + signInBtn.frame.height + width/40, width: width - width/10, height: width/10.667)
        faceLoginButton.layer.cornerRadius = faceLoginButton.frame.height/2
        faceLoginButton.layer.masksToBounds = true
        faceLoginButton.titleLabel?.font = UIFont(name: "Avenir Next", size: width/25)
        faceLoginButton.delegate = self
        faceLoginButton.readPermissions = ["email", "public_profile"]
        scrollView.addSubview(faceLoginButton)

    }
    
    @objc func handleSignUpBtnClick(gesture: UITapGestureRecognizer){
        performSegue(withIdentifier: "signUpClick", sender: nil)
    }
 
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error.localizedDescription)
            
        }else{
            print("Successfully logged in with facebook")
            //initialze a facebook grab request
            showEmail()
        }
    }
    
    func showEmail() {
        //logging into fire base with facebook credentials
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else{
            return
        }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if error != nil{
                appDelegate.errorView(message: error!.localizedDescription, color: colorSmoothRed)
            }
            if let uid = user?.uid{
                
                let userRef = Database.database().reference().child("users").child(uid)
                let pictureRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"picture.type(large)"])
                let _ = pictureRequest?.start(completionHandler: { (connection, result, error) in
                    guard let userInfo = result as? [String: Any] else {
                        print("unable to get photo url")
                        return}
                    
                    if let imageURL = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                        //  self.downloadImage(url: imageURL)
                        
                        let url = URL(string: imageURL)
                        
                        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                            DispatchQueue.main.async {
                                if let image = UIImage(data: data!){
                                    if let uploadData = UIImageJPEGRepresentation(image, 0.5){
                                        let imageUrl = NSUUID().uuidString
                                        Storage.storage().reference().child("user-profile-images").child(imageUrl).putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                            if let err = error{
                                                print("Unable to find image from facebook ",err.localizedDescription)
                                                return
                                            }
                                            if let facebookImageUrl = metadata?.downloadURL()?.absoluteString{
                                                let values:[String:AnyObject] = ["name":user?.displayName as AnyObject,"email":user?.email as AnyObject,"profileImageUrl":facebookImageUrl as AnyObject]
                                                userRef.setValue(values)
                                            }
                                        })
                                        
                                        
                                    }
                                }
                            }
                        }
                        task.resume()
                    }
                })
                
            }
            print("successfully logged into fire base", user ?? "")
            self.performSegue(withIdentifier: "loginSuccessful", sender: nil)
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, err) in
            
            if err != nil{
                print("Failed to start the graph request",err ?? "")
            }
            print(result ?? "")
        })
    }
    
    @objc func handleSignIn(gesture: UITapGestureRecognizer){
        if emailTextField.text == "" || passwordTextField.text == "" {
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: colorSmoothRed])
            emailTextField.layer.borderColor = colorSmoothRed.cgColor
        
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: colorSmoothRed])
            passwordTextField.layer.borderColor = colorSmoothRed.cgColor
            
            return
        }
        
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let err = error{
                    appDelegate.errorView(message: err.localizedDescription, color: colorSmoothRed)
                    return
                }
                self.performSegue(withIdentifier: "loginSuccessful", sender: nil)
                
            })

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
            self.scrollView.frame.size.height = self.view.frame.height
        })
    }
    
    @objc func dismissKeyboard(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }

}


extension UIColor {
    
    convenience init(r: CGFloat,g: CGFloat,b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
