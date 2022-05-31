//
//  Extension.swift
//  Messanger
//
//  Created by Rama Muhammad S on 19/05/22.
//

import Foundation
import UIKit

extension UIView{
    var width: CGFloat{
        return self.bounds.size.width
    }
    
    var height: CGFloat{
        return self.frame.size.height
    }
    
    var top: CGFloat{
        return self.frame.origin.y
    }
    
    var bottom: CGFloat{
        return self.frame.size.height + self.frame.origin.y
    }
    
    var left: CGFloat{
        return self.frame.origin.x
    }
    
    var right: CGFloat{
        return self.frame.size.width + self.frame.origin.x
    }
    
    func addTapGesture(target: Any, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
}

extension UITextField{
    func customTextField(corner: CGFloat, border: CGFloat, borColor: UIColor, desc: String, size: CGFloat, font: String){
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.layer.cornerRadius = corner
        self.layer.borderWidth = border
        self.layer.borderColor = borColor.cgColor
        self.placeholder = desc
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        self.leftViewMode = .always
        self.backgroundColor = .none
        self.font = UIFont(name: font, size: size)
        
    }
    func defaultTextField(desc: String){
        customTextField(corner: 12, border: 1, borColor: UIColor.lightGray, desc: desc, size: 14, font: Config.POPPINS_LIGHT)
    }
    
    func setTextFieldLight(desc: String, size: CGFloat){
        setTextFieldFont(desc: desc, size: size, font: Config.POPPINS_LIGHT)
    }
    
    func setTextFieldMedium(desc: String, size: CGFloat){
        setTextFieldFont(desc: desc, size: size, font: Config.POPPINS_MEDIUM)
    }
    
    func setTextFieldBold(desc: String, size: CGFloat){
        setTextFieldFont(desc: desc, size: size, font: Config.POPPINS_BOLD)
    }
    
    private func setTextFieldFont(desc: String, size: CGFloat, font: String){
        customTextField(corner: 12, border: 1, borColor: UIColor.lightGray, desc: desc, size: size, font: font)
    }
}

extension UILabel{
    func setPoppinsLight(size: CGFloat){
        setFont(name: Config.POPPINS_LIGHT, size: size)
    }
    
    func setPoppinsMedium(size: CGFloat){
        setFont(name: Config.POPPINS_MEDIUM, size: size)
    }
    
    func setPoppinsBold(size: CGFloat){
        setFont(name: Config.POPPINS_BOLD, size: size)
    }
    
    private func setFont(name: String, size: CGFloat){
        self.font = UIFont(name: name, size: size)
    }
}

extension UIViewController{
    
    func alertDialog(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert,animated: true)
    }
    
    func actionSheetDialog(title: String, message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        present(alert,animated: true)
        return alert
    }
    
    func negativeButton() -> UIAlertAction{
        let alert = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        return alert
    }
    
    func positiveButton(title: String, action: @escaping(UIAlertAction) -> Void) -> UIAlertAction{
        let alert = UIAlertAction(title: title, style: .default, handler: action)
        return alert
    }
    
    func showToast(message: String, isBottom:Bool? = true, isTabPage:Bool? = false) {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        containerView.alpha = 1.0
        containerView.clipsToBounds = true
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(toastLabel)
      
        toastLabel.textColor = UIColor.white
        toastLabel.setPoppinsLight(size: 14)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        self.view.addSubview(containerView)
        if isBottom ?? true {
            if isTabPage == false {
                NSLayoutConstraint.activate([containerView.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -40.0),
                                             containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0),
                                             containerView.leadingAnchor.constraint(equalTo: toastLabel.leadingAnchor, constant: -16.0),
                                             containerView.trailingAnchor.constraint(equalTo: toastLabel.trailingAnchor, constant: 16.0),
                                             containerView.topAnchor.constraint(equalTo: toastLabel.topAnchor, constant: -10.0),
                                             containerView.bottomAnchor.constraint(equalTo: toastLabel.bottomAnchor, constant: 10.0)])
            } else {
                NSLayoutConstraint.activate([containerView.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -90.0),
                containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0),
                containerView.leadingAnchor.constraint(equalTo: toastLabel.leadingAnchor, constant: -16.0),
                containerView.trailingAnchor.constraint(equalTo: toastLabel.trailingAnchor, constant: 16.0),
                containerView.topAnchor.constraint(equalTo: toastLabel.topAnchor, constant: -10.0),
                containerView.bottomAnchor.constraint(equalTo: toastLabel.bottomAnchor, constant: 10.0)])
            }
        } else {
            NSLayoutConstraint.activate([containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.0),
                                     containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0),
                                     containerView.leadingAnchor.constraint(equalTo: toastLabel.leadingAnchor, constant: -16.0),
                                     containerView.trailingAnchor.constraint(equalTo: toastLabel.trailingAnchor, constant: 16.0),
                                     containerView.topAnchor.constraint(equalTo: toastLabel.topAnchor, constant: -10.0),
                                     containerView.bottomAnchor.constraint(equalTo: toastLabel.bottomAnchor, constant: 10.0)])
        }
//        containerView.layer.cornerRadius = (message.height(withConstrainedWidth: view.bounds.width, font: font) + 32)/2
        containerView.layer.cornerRadius = 10
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseOut, animations: {
            containerView.alpha = 0.0
        }, completion: {(isCompleted) in
            containerView.removeFromSuperview()
        })
    }
}
