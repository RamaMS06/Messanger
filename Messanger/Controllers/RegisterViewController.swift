//
//  RegisterViewController.swift
//  Messanger
//
//  Created by Rama Muhammad S on 19/05/22.
//

import Foundation
import UIKit
import FirebaseAuth

class RegisterViewController : UIViewController{
    
    var isShowPass: Bool = false
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user")
        imageView.contentMode = .scaleToFill
        imageView.layer.shadowOffset = CGSize.zero
        imageView.layer.shadowRadius = 2.0
        imageView.tintColor = .gray
        imageView.layer.shadowOpacity = 1
        imageView.layer.masksToBounds = true
        imageView.layer.shadowColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    private let addImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "add")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowOffset = CGSize.zero
        imageView.layer.shadowRadius = 2.0
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
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.defaultTextField(desc: Config.FIRST_NAME_FIELD)
        field.returnKeyType = .continue
        field.layer.shadowOpacity = 1
        field.layer.shadowRadius = 3.0
        field.layer.shadowOffset = CGSize.zero
        field.layer.shadowColor = UIColor.lightGray.cgColor
        return field
    }()
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.defaultTextField(desc: Config.LAST_NAME_FIELD)
        field.returnKeyType = .continue
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
    
    private let btnRegister: UIButton = {
        let btnRegister = UIButton()
        btnRegister.backgroundColor = .systemGreen
        btnRegister.titleLabel?.setPoppinsBold(size: 16)
        btnRegister.setTitle("Register", for: .normal)
        btnRegister.setTitleColor(.white, for: .normal)
        btnRegister.layer.cornerRadius = 12
        btnRegister.layer.masksToBounds = true
        return btnRegister
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView(){
        view.backgroundColor = .white
        view.addSubview(scrollView)
        
        scrollView.addSubview(profileImage)
        scrollView.addSubview(addImage)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(btnRegister)
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
        addImage.addTapGesture(target: self, action: #selector(didTapChangeProfile))
        btnRegister.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
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
        profileImage.frame = CGRect(x: (view.width-size)/2,
                                 y: 35,
                                    width: scrollView.width/4, height: scrollView.width/4)
        
        profileImage.layer.cornerRadius = profileImage.width/2.0
        
        addImage.frame = CGRect(x: (view.width-size)/1.35, y: 100, width: scrollView.width/12.5, height: scrollView.width/12.5)
        
        firstNameField.frame = CGRect(x: 30, y: profileImage.bottom + 60 , width: scrollView.width - 60, height: 50)
        
        lastNameField.frame = CGRect(x: 30, y: firstNameField.bottom + 15, width: scrollView.width - 60, height: 50)
        
        emailField.frame = CGRect(x: 30,
                                  y: lastNameField.bottom + 15,
                                  width: scrollView.width - 60, height: 50)
        
        passwordField.frame = CGRect(x: 30, y: emailField.bottom + 15,
                                     width: scrollView.width - 60, height: 50)
        
        btnRegister.frame = CGRect(x: 30, y: passwordField.bottom + 30,
                               width: scrollView.width - 60, height: 50)
        
    }
    
    @objc private func didTapCreateAccount(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        //false
        guard let email = emailField.text, let password = passwordField.text, let firstName = firstNameField.text, let lastName = lastNameField.text, 
              !email.isEmpty, !password.isEmpty,
              !firstName.isEmpty, !lastName.isEmpty,
                email.count >= 6 else{
                    alertDialog(title: Config.TITLE_ALERT_TEXT_FIELD, message: Config.DESC_ALERT_TEXT_FIELD_REGISTRATION)
                  return
              }
        //true (Firebase Register)
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {
            [weak self]
            authResult, error in
            
            //Avoid memory leak
            guard let strongSelf = self else{
                return
            }
            
            guard let result = authResult, error == nil else{
                let errorCode = AuthErrorCode.Code(rawValue: error!._code)
                
                switch errorCode{
                case .invalidEmail: strongSelf.showToast(message: "Invalid Email")

                    break
                case .emailAlreadyInUse:
                    strongSelf.alertDialog(title: Config.TITLE_ALERT_TEXT_FIELD, message: "Email is already in use.")
                    break
                    default :
                    strongSelf.alertDialog(title: Config.TITLE_ALERT_TEXT_FIELD, message: "Create account failed.")
                }
                return
            }
            DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
            strongSelf.showToast(message: "Create account is success")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func didTapChangeProfile(){
        presentPhotoActionSheet()
    }
}

@available(iOS 13.0, *)
extension RegisterViewController: UITextViewDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == emailField{
            passwordField.becomeFirstResponder()
        }
        else if emailField == passwordField{
            didTapCreateAccount()
        }
        
        return true
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func presentPhotoActionSheet(){
        let photoPresent = actionSheetDialog(title: Config.TITLE_PROFILE_PICTURE, message: Config.DESC_PROFILE_PICTURE)
        photoPresent.addAction(negativeButton())
        photoPresent.addAction(positiveButton(title: Config.TITLE_TAKE_PHOTO){ [weak self] _ in
            self?.presentCamera()
        })
        photoPresent.addAction(positiveButton(title: Config.TITLE_CHOOSE_PHOTO){ [weak self]
            _ in
            self?.presentPhotoPicker()
        })
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        self.profileImage.image = selectedImage
        
            picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    }
}

