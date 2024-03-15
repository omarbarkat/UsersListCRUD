//
//  CreateVC.swift
//  UsersListCRUD
//
//  Created by Omar barkat on 14/03/2024.
//

import UIKit

class CreateVC: UIViewController{
    var isCreation = true
    var editedUser :UsersList?
    var editedUserIndex: Int?
//Outlets:
    @IBOutlet weak var btnImoprtImage: UIButton!
    {
        didSet {
            btnImoprtImage.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var lblViewHeader: UILabel!
    @IBOutlet weak var btnAddToList: UIButton!
    {
        didSet {
            btnAddToList.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if isCreation == false {
            print("edit")
            btnAddToList.setTitle("Edit User Info", for: .normal)
            lblViewHeader.text = "Edit User Info"
            if let user = editedUser {
                txtName.text = user.name
                txtPassword.text = user.password
                txtPhone.text = user.phone
                txtEmail.text = user.email
                imgUser.image = user.image
                txtAge.text = user.age
                
            }
        }
    }
    //Action:
    
    @IBAction func btnImoprtImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func btnAddToList(_ sender: Any) {
        if isCreation {
            let userList = UsersList(name: txtName.text!, email: txtEmail.text!, password: txtPassword.text!, phone: txtPhone.text!, image: imgUser.image, age: txtAge.text)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewUserAdded"), object: nil, userInfo: ["AddedUser":userList])
            txtAge.text = ""
            txtName.text = ""
            txtEmail.text = ""
            txtPhone.text = ""
            txtPassword.text = ""
            imgUser.image = nil
            
            let alert = UIAlertController(title: "seccess", message: "New User Added", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: {_ in 
                self.tabBarController?.selectedIndex = 0
            }))
            present(alert, animated: true, completion:nil)
        }else {
            //edit the current user
            let user = UsersList(name: txtName.text!, email: txtEmail.text!, password: txtPassword.text!, phone: txtPhone.text!, image: imgUser.image, age: txtAge.text)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentUserEdited"), object: nil, userInfo: ["EditedUser":  user,"EditedUserIndex":editedUserIndex])
            let alert = UIAlertController(title: "seccess", message: " User Edited", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: {_ in
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true, completion:nil)
        }
    }
}
extension CreateVC : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        dismiss(animated: true, completion: nil)
        imgUser.image = image
    }
}
