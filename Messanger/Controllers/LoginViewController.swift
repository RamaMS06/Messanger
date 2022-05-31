//
//  LoginViewController.swift
//  Messanger
//
//  Created by Rama Muhammad S on 19/05/22.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController : UIViewController{
    
    var isShowPass: Bool = false
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Config.LOGO_IMAGE)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowOffset = CGSize.zero
        imageView.layer.shadowRadius = 6.0
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowColor = UIColor.gray.cgColor
        return imageView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.defaultTextField(desc: Config.EMAIL_FIELD)
        field.returnKeyType = .continue
        field.layer.shadowOpacity = 1
        field.layer.shadowRadius = 3.0
        field.layer.shadowOffset = CGSize.zero
        field.layer.shadowColor = UIColor.lightGray.cgColor
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.defaultTextField(desc: Config.PASSWORD_FIELD)
        field.returnKeyType = .done
        field.isSecureTextEntry = true
        field.layer.shadowOpacity = 1
        field.layer.shadowRadius = 3.0
        field.layer.shadowOffset = CGSize.zero
        field.layer.shadowColor = UIColor.lightGray.cgColor
        return field
    }()
    
    private let passwordIcon: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 10, width: 20, height: 20))
        image.image = UIImage(named: Config.EYE_OFF)
        image.tintColor = .lightGray
        return image
    }()
    
    private let textFooter: UILabel = {
        let label = UILabel()
        label.text = "Version 1"
        label.textColor = .lightGray
        label.setPoppinsMedium(size: 16)
        label.textAlignment = .right
        return label
    }()
    
    private let btnLogin: UIButton = {
        let btnLogin = UIButton()
        btnLogin.backgroundColor = .systemBlue
        btnLogin.titleLabel?.setPoppinsBold(size: 16)
        btnLogin.setTitle("Login", for: .normal)
        btnLogin.setTitleColor(.white, for: .normal)
        btnLogin.layer.cornerRadius = 12
        btnLogin.layer.masksToBounds = true
        return btnLogin
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView(){
        title = "Login"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem?.isEnabled = false
        view.addSubview(scrollView)
        
        scrollView.addSubview(logoImage)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(btnLogin)
        setEyeIcon()
    }
    
    func setEyeIcon(){
        passwordIcon.isUserInteractionEnabled = true
       
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: passwordIcon.bounds.width+15, height: 40))
        imageContainerView.addSubview(passwordIcon)
        passwordField.rightView = imageContainerView
        passwordField.rightViewMode = .always
        passwordIcon.isUserInteractionEnabled = true
        passwordIcon.addTapGesture(target: self, action: #selector(toggleEyeIcon))
        btnLogin.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }
    
    @objc func toggleEyeIcon(){
        if !isShowPass{
            passwordField.isSecureTextEntry = false
            passwordIcon.image = UIImage(named: Config.EYE_ON)
        }else{
            passwordField.isSecureTextEntry = true
            passwordIcon.image = UIImage(named: Config.EYE_OFF)
        }
        self.isShowPass = !isShowPass
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/4
        logoImage.frame = CGRect(x: (view.width-size)/2,
                                 y: 35,
                                 width: size, height: size)
        
        emailField.frame = CGRect(x: 30,
                                  y: logoImage.bottom + 60,
                                  width: scrollView.width - 60, height: 50)
        
        passwordField.frame = CGRect(x: 30, y: emailField.bottom + 15,
                                     width: scrollView.width - 60, height: 50)
        
        btnLogin.frame = CGRect(x: 30, y: passwordField.bottom + 30,
                               width: scrollView.width - 60, height: 50)
        
    }
    
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapLogin(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        //false
        guard let email = emailField.text, let password = passwordField.text,
              !email.isEmpty, !password.isEmpty, email.count >= 6 else{
                  showToast(message: Config.DESC_ALERT_TEXT_FIELD_LOGIN)
                  return
              }
        
        DatabaseManager.shared.userExists(with: email, completion: {
            [weak self]
            exists in
            //Avoid memory leak
            guard let strongSelf = self else{
                return
            }
            
            guard !exists else{
                //User already exists
                strongSelf.showToast(message: "Looks like a user account for that email address already exists")
                return
            }
            
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {
                authResult, error in
                
                guard let result = authResult, error == nil else{
                    let errorCode = AuthErrorCode.Code(rawValue: error!._code)
                    
                    switch errorCode{
                    case .invalidEmail:
                        strongSelf.showToast(message: "Invalid Email")
                        break
                    case .wrongPassword:
                        strongSelf.showToast(message: "Wrong Password")
                    default :
                        strongSelf.showToast(message: "Login is failed.")
                    }
                    return
                }
                
                let user = result.user
                strongSelf.showToast(message: user.description)
            })
            
        })
        
    }
}

@available(iOS 13.0, *)
extension LoginViewController: UITextViewDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == emailField{
            passwordField.becomeFirstResponder()
        }
        else if emailField == passwordField{
            didTapLogin()
        }
        
        return true
    }
}

