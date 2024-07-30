//
//  PasswordManagerHomeVC.swift
//  Password Manager
//
//  Created by Apple on 29/07/24.
//

import UIKit

class PasswordManagerHomeVC: UIViewController, AddPasswordDelegate, ShowPasswordDelegate {

    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var PasswordTableView: UITableView!
    var password = [Password]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setTableView()
    }
    func setUI(){
        self.noDataView.isHidden = true
        self.dataView.isHidden = true
        DatabaseHelper.shared.getPasswordData { passwords in
            if passwords.count == 0{
                self.noDataView.isHidden = false
                self.dataView.isHidden = true
            }else{
                self.password = passwords
                self.PasswordTableView.reloadData()
                self.noDataView.isHidden = true
                self.dataView.isHidden = false
            }
        }
        
    }
    func setTableView(){
        self.PasswordTableView.dataSource = self
        self.PasswordTableView.delegate = self
        self.PasswordTableView.register(UINib(nibName: "PasswordManagerCell", bundle: nil), forCellReuseIdentifier: "PasswordManagerCell")
        self.PasswordTableView.reloadData()
    }
    func didAddData() {
        setUI()
        showToast(message: "Add Password")
    }
    func didDeleteData() {
        setUI()
        showToast(message: "Delete Password")
    }
    func didUpdateData() {
        setUI()
        showToast(message: "Updata Password")
    }
    @IBAction func btnAddPassword(_ sender: Any) {
        let vc = AddPasswordVC.fatchInstance()
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        vc.accountType = ""
        vc.password = ""
        vc.usernameEmail = ""
        vc.id = ""
        present(vc, animated: true, completion: nil)
    }
    
}
extension PasswordManagerHomeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.password.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordManagerCell", for: indexPath) as! PasswordManagerCell
        cell.lblAppName.text = password[indexPath.row].accountname
        let password = password[indexPath.row].password
        var passwordString = ""
        if let password = password {
            for _ in password {
                passwordString.append("*")
            }
        }
        cell.lblPassword.text = passwordString
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ShowPasswordVC.fatchInstance()
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        let data =  password[indexPath.row]
        vc.accountType = data.accountname ?? ""
        vc.password = data.password ?? ""
        vc.usernameEmail = data.username ?? ""
        vc.id = data.id ?? ""
        self.present(vc, animated: true, completion: nil)
    }
    
}
