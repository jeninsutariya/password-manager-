//
//  PasswordManagerCell.swift
//  Password Manager
//
//  Created by Apple on 29/07/24.
//

import UIKit

class PasswordManagerCell: UITableViewCell {

    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblAppName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
