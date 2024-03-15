//
//  UserDetailsVC.swift
//  UsersListCRUD
//
//  Created by Omar barkat on 14/03/2024.
//

import UIKit

class UserDetailsVC: UIViewController {
//Outlets:
    var index : Int!
    var userList : UsersList!
    @IBOutlet weak var btnUpdate: UIButton!{
        didSet {
            btnUpdate.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var btnDeleteUser: UIButton!{
        didSet {
            btnDeleteUser.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(editedCurrentUser), name: NSNotification.Name(rawValue: "currentUserEdited"), object: nil)

    }
    @objc func editedCurrentUser(notification:Notification){
        if let user = notification.userInfo?["EditedUser"] as? UsersList {
            self.userList = user
            setupUI()
        }
    }
    
    @IBAction func btnDeleteUser(_ sender: Any) {
    
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DeleteUser"), object: nil, userInfo: ["DeleteUserIndex":index])
    }
    @IBAction func btnUpdate(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CreateVC") as? CreateVC {
            vc.isCreation = false
            vc.editedUser = userList
            vc.editedUserIndex = index
            navigationController?.pushViewController(vc, animated: true)
        }
            
    }
    func setupUI() {
        lblPhone.text = userList.phone
        lblName.text = userList.name
        lblEmail.text = userList.email
        lblPassword.text = userList.password
        imgUser.image = userList.image
    }
    
  
    

}
