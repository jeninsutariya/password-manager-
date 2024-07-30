//
//  ShowPasswordVC.swift
//  Password Manager
//
//  Created by Apple on 29/07/24.
//

import UIKit
protocol ShowPasswordDelegate: AnyObject {
    func didDeleteData()
}


class ShowPasswordVC: UIViewController, AddPasswordDelegate {
    func didUpdateData() {
        DispatchQueue.main.async {
            self.delegate?.didDeleteData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func didAddData() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.didDeleteData()
        }
    }
    @IBOutlet weak var lblAccountType: UILabel!
    @IBOutlet weak var dismisView: UIView!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblUsernameEmail: UILabel!
    @IBOutlet weak var btnShowPassword: UIButton!
    weak var delegate: ShowPasswordDelegate?
    var accountType: String = ""
    var password: String = ""
    var usernameEmail: String = ""
    var id: String = ""
    var isShow = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.lblAccountType.text = accountType
        self.lblUsernameEmail.text = usernameEmail
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dismisView.addGestureRecognizer(tapGesture)
        let PasswordTapGesture = UITapGestureRecognizer(target: self, action: #selector(PasswordTap))
        lblPassword.addGestureRecognizer(PasswordTapGesture)
        let UsernameEmailTapGesture = UITapGestureRecognizer(target: self, action: #selector(UsernameEmailTap))
        lblUsernameEmail.addGestureRecognizer(UsernameEmailTapGesture)
        self.showPassword()
    }
    
    func showPassword(){
        if isShow{
            self.lblPassword.text = password
            self.btnShowPassword.setImage(UIImage(named: "eye"), for: .normal)
        }else{
            self.lblPassword.text = String(repeating: "*", count: password.count)
            self.btnShowPassword.setImage(UIImage(named: "Ceye"), for: .normal)
            self.btnShowPassword.tintColor = UIColor.lightGray
        }
    }
    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc private func PasswordTap() {
        UIPasteboard.general.string = lblPassword.text
        showToast(message: "Copy")
    }
    @objc private func UsernameEmailTap() {
        UIPasteboard.general.string = lblUsernameEmail.text
        showToast(message: "Copy")
    }
    
    public class func fatchInstance() -> ShowPasswordVC {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: "ShowPasswordVC") as! ShowPasswordVC
    }
    @IBAction func btnDelete(_ sender: Any) {
        DatabaseHelper.shared.deletePassword(id: self.id) { _ in
            self.delegate?.didDeleteData()
            self.dismiss(animated: true, completion: nil)
            showToast(message: "Delete Password")
        }
    }
    
    @IBAction func btnShowPasswordClick(_ sender: Any) {
        self.isShow.toggle()
        self.showPassword()
    }
    @IBAction func btnEdit(_ sender: Any) {
        let vc = AddPasswordVC.fatchInstance()
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        vc.isUpdate = true
        vc.accountType = self.accountType
        vc.password = self.password
        vc.usernameEmail = self.usernameEmail
        vc.id = self.id
        self.present(vc, animated: true, completion: nil)
    }
    
}
