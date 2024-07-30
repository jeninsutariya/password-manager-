//
//  AddPasswordVC.swift
//  Password Manager
//
//  Created by Apple on 29/07/24.
//

import UIKit

protocol AddPasswordDelegate: AnyObject {
    func didAddData()
    func didUpdateData()
}

class AddPasswordVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsernameEmail: UITextField!
    @IBOutlet weak var txtAccountName: UITextField!
    @IBOutlet weak var dismisView: UIView!
    var isUpdate = false
    var isShowPassword = false
    weak var delegate: AddPasswordDelegate?
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnShowPassword: UIButton!
    
    var accountType: String = ""
    var password: String = ""
    var usernameEmail: String = ""
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        txtAccountName.attributedPlaceholder = NSAttributedString(
            string: "Account Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        txtUsernameEmail.attributedPlaceholder = NSAttributedString(
            string: "Username / Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        txtPassword.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        txtPassword.delegate = self
        self.txtPassword.text =  String(repeating: "*", count: password.count)
        self.txtUsernameEmail.text = usernameEmail
        self.txtAccountName.text = accountType
        if isUpdate {
            btnAdd.setTitle("Update Password", for: .normal)
        } else {
            btnAdd.setTitle("Add New Account", for: .normal)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dismisView.addGestureRecognizer(tapGesture)
        self.showPassword()
    }
    func showPassword(){
        if isShowPassword{
            self.txtPassword.isSecureTextEntry = false
            self.btnShowPassword.setImage(UIImage(named: "eye"), for: .normal)
        }else{
            self.txtPassword.isSecureTextEntry = true
            self.btnShowPassword.setImage(UIImage(named: "Ceye"), for: .normal)
        }
    }
    @IBAction func btnShowPasswordClick(_ sender: Any) {
        self.isShowPassword.toggle()
        self.showPassword()
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    public class func fatchInstance() -> AddPasswordVC {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: "AddPasswordVC") as! AddPasswordVC
    }
    
    @IBAction func btnAddNewAccount(_ sender: Any) {
        if txtAccountName.text?.isEmpty ?? true {
            showAlert(message: "Please Enter Account")
        } else if txtUsernameEmail.text?.isEmpty ?? true {
            showAlert(message: "Please Enter Username / Email")
        } else if txtPassword.text?.isEmpty ?? true {
            showAlert(message: "Please Enter Password")
        } else {
            if isUpdate {
                DatabaseHelper.shared.editPassword(id: id, username: txtUsernameEmail.text ?? "", accountname: txtAccountName.text ?? "", password: txtPassword.text ?? "") { _ in
                    DispatchQueue.main.async {
                        self.delegate?.didUpdateData()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                DatabaseHelper.shared.savePasswordData(username: txtUsernameEmail.text ?? "", accountname: txtAccountName.text ?? "", password: txtPassword.text ?? "") { _ in
                    DispatchQueue.main.async {
                        self.delegate?.didAddData()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtPassword{
            self.btnGeneratePasswordTapped()
        }
    }
     func btnGeneratePasswordTapped() {
        let generatedPassword = generateRandomPassword(length: 8)
         self.txtPassword.text = generatedPassword
    }
    
    private func generateRandomPassword(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_-+=<>?"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
