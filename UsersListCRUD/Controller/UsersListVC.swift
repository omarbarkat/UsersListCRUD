//
//  ViewController.swift
//  UsersListCRUD
//
//  Created by Omar barkat on 14/03/2024.
//

import UIKit
import CoreData

class UsersListVC: UIViewController {
    
    var arrUsers:[UsersList] = []
    var user:UsersList!
    
    //Outlets:
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var TableView: UITableView!
    override func viewDidLoad() {
        self.arrUsers = getData()
        super.viewDidLoad()
        //New User Notification
        NotificationCenter.default.addObserver(self, selector: #selector(addUser), name: NSNotification.Name(rawValue: "NewUserAdded"), object: nil)
        //Edite Current User Notification
        NotificationCenter.default.addObserver(self, selector: #selector(editedCurrentUser), name: NSNotification.Name(rawValue: "currentUserEdited"), object: nil)
        //Delete Current User Notification
        NotificationCenter.default.addObserver(self, selector: #selector(DeleteCurrentUser), name: NSNotification.Name(rawValue: "DeleteUser"), object: nil)
        
        TableView.delegate = self
        TableView.dataSource = self
    }
    @objc func editedCurrentUser(notification:Notification){
        if let user = notification.userInfo?["EditedUser"] as? UsersList {
            if let index = notification.userInfo?["EditedUserIndex"] as? Int{
                arrUsers[index] = user
                TableView.reloadData()
                updateStoreData(user: user, index: index)
            }
        }
    }
    @objc func DeleteCurrentUser(notification:Notification){
        if let index = notification.userInfo?["DeleteUserIndex"] as? Int {
            arrUsers.remove(at: index)
            TableView.reloadData()
            deleteUserData(index: index)
            let alert = UIAlertController(title: "success", message: "User Deleted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    @objc func addUser(notification:Notification) {
        if let usersList = notification.userInfo?["AddedUser"] as? UsersList {
            arrUsers.append(usersList)
            TableView.reloadData()
            storeUser(user: usersList)
        }
    }
    func storeUser(user:UsersList) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageContext = appDelegate.persistentContainer.viewContext
        guard let userEntity = NSEntityDescription.entity(forEntityName: "Entity", in: manageContext) else {return}
        let userObject = NSManagedObject.init(entity: userEntity, insertInto: manageContext)
        userObject.setValue(user.name , forKey: "name")
        userObject.setValue(user.email, forKey: "email")
        userObject.setValue(user.age, forKey: "age")
        userObject.setValue(user.password, forKey: "password")
        userObject.setValue(user.phone, forKey: "phone")
        if let image = user.image {
            let imageData = image.jpegData(compressionQuality: 1)
            userObject.setValue(imageData, forKey: "image" )
        }
        do{
            try manageContext.save()
            print("===success===")
        }catch {
            print("===error===")
        }
    }
    func updateStoreData(user:UsersList , index : Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            result[index].setValue(user.name, forKey: "name")
            result[index].setValue(user.email, forKey: "email")
            result[index].setValue(user.password, forKey: "password")
            result[index].setValue(user.phone, forKey: "phone")
            result[index].setValue(user.age, forKey: "age")
            try context.save()
        }catch {
            print("===error===")
        }
    }
    func deleteUserData(index : Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
           let userDelete = result[index]
            context.delete(userDelete)
            try context.save()
        }catch {
            print("===error===")
        }
    }
    func getData() -> [UsersList] {
        var users : [UsersList] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return []}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            for mangedUser in result {
                let name = mangedUser.value(forKey: "name") as! String
                let email = mangedUser.value(forKey: "email") as? String
                let password = mangedUser.value(forKey: "password") as? String
                let phone = mangedUser.value(forKey: "phone") as? String
                let age = mangedUser.value(forKey: "age") as? String
                var image:UIImage? = nil
                if let imgFromContext = mangedUser.value(forKey: "image") as? Data {
                     image = UIImage(data: imgFromContext)
                }
                let user = UsersList(name: name, email:email ?? "", password: password ?? "", phone: phone, image:  image , age: age)
                users.append(user)
            }
        }catch {
            print("===error===")

        }
        
        return users
    }
}
extension UsersListVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUsers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserViewCell
        let list = arrUsers[indexPath.row]
        cell.lblUserName.text = list.name
        cell.lblPhone.text = list.phone
        cell.imgUserPhoto.layer.cornerRadius = cell.imgUserPhoto.frame.width / 2 
        cell.imgUserPhoto.image = list.image
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
        tableView.deselectRow(at: indexPath, animated: true)
        let user = arrUsers[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "UserDetailsVC") as? UserDetailsVC {
            vc.userList = user
            vc.index = indexPath.row 
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

