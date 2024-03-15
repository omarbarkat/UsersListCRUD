//
//  UserViewCell.swift
//  UsersListCRUD
//
//  Created by Omar barkat on 14/03/2024.
//

import UIKit

class UserViewCell: UITableViewCell {

    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var imgUserPhoto: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnDelete: UIButton! {
        didSet {
            btnDelete.layer.cornerRadius = 15
        }
    }
//    @IBOutlet weak var btnUpdate: UIButton! {
//        didSet {
//            btnUpdate.layer.cornerRadius = 15
//        }
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
