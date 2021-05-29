//
//  ViewController.swift
//  MyCoreData
//
//  Created by mac10 on 2021/4/15.
//  Copyright © 2021 mac10. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var clientName: UITextField!
    @IBOutlet weak var clientId: UITextField!
    @IBOutlet weak var carplate: UITextField!
    @IBAction func clearInfo(_ sender: UIButton) {
        clientName.text = ""
        clientId.text = ""
        carplate.text = ""
        myImage.image = nil
    }
    @IBAction func saveData(_ sender: UIButton) {
        if (clientId.text == "") || (clientName.text == "") || (carplate.text == "") || (myImage.image == nil){
            MyAlertController("Error")
        }else{
            let user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
            user.setValue(clientName.text, forKey: "cname")
            user.setValue(clientId.text, forKey: "cid")
            user.setValue(myImage.image?.pngData(), forKey: "cimage")
            let car = NSEntityDescription.insertNewObject(forEntityName: "Car", into: viewContext) as! Car
            car.setValue(carplate.text, forKey: "plate")
            user.addToOwn(car)
            app.saveContext()
            MyAlertController("Successful insert")
        }
    }
    @IBAction func loadData(_ sender: UIButton) {
        let fetchId = NSPredicate(format: "cid BEGINSWITH[cd] %@", clientId.text!)
        let fetchName = NSPredicate(format: "cname BEGINSWITH[cd] %@", clientName.text!)
        let fetchCar = NSPredicate(format: "plate BEGINSWITH[cd] %@", carplate.text!)
        let fetchRequest : NSFetchRequest<UserData> = UserData.fetchRequest()
        let fetchCarRequest : NSFetchRequest<Car> = Car.fetchRequest()
        var predicate = NSCompoundPredicate()
        if (carplate.text != ""){
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[fetchCar])
            fetchCarRequest.predicate = predicate
            do {
                let Cars = try viewContext.fetch(fetchCarRequest)
                if Cars == [] {
                    MyAlertController("Unsuccessful load")
                }
                for car in Cars{
                    carplate.text = car.plate
                    clientId.text = car.belongto?.cid
                    clientName.text = car.belongto?.cname
                    myImage.image = UIImage(data: (car.belongto?.cimage!)! as Data)
                }
            }catch{
                print(error)
            }
        }
        else if (clientName.text == "") && (clientId.text != ""){
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fetchId])
            fetchRequest.predicate = predicate
            do {
                let Users = try viewContext.fetch(fetchRequest)
                if Users == [] {
                    MyAlertController("Unsuccessful load")
                }
                for user in Users{
                    clientId.text = user.cid
                    clientName.text = user.cname
                    myImage.image = UIImage(data: user.cimage! as Data)
                    for car in user.own as! Set<Car>{
                        carplate.text = car.plate
                    }
                }
            }catch{
                print(error)
            }
        }
        else if (clientName.text != "") && (clientId.text == ""){
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fetchName])
            fetchRequest.predicate = predicate
            do {
                let Users = try viewContext.fetch(fetchRequest)
                if Users == [] {
                    MyAlertController("Unsuccessful load")
                }
                for user in Users{
                    clientId.text = user.cid
                    clientName.text = user.cname
                    myImage.image = UIImage(data: user.cimage! as Data)
                    for car in user.own as! Set<Car>{
                        carplate.text = car.plate
                    }
                }
            }catch{
                print(error)
            }
        }
        else{
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fetchId,fetchName])
            fetchRequest.predicate = predicate
            do {
                let Users = try viewContext.fetch(fetchRequest)
                if Users == [] {
                    MyAlertController("Unsuccessful load")
                }
                for user in Users{
                    clientId.text = user.cid
                    clientName.text = user.cname
                    myImage.image = UIImage(data: user.cimage! as Data)
                    for car in user.own as! Set<Car>{
                        carplate.text = car.plate
                    }
                }
            }catch{
                print(error)
            }
        }
        
        
    }
    func MyAlertController(_ result: String){
        var alert = UIAlertController()
        if result == "Error" {
            alert = UIAlertController(title: "Error", message: "Please enter complete information", preferredStyle: .alert)
        }else if result == "Successful insert"{
            alert = UIAlertController(title: "Successful insert", message: String(clientName.text!) + " added finish", preferredStyle: .alert)
        }else{
            alert = UIAlertController(title: "Unsuccessful load", message: "There is no such data", preferredStyle: .alert)
        }
        let action = UIAlertAction(title: "I got it!", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert,animated: true,completion: nil)
    }
    @IBAction func clickReturn(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func selected(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .popover
        show(imagePicker, sender: myImage)
    }
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewContext = app.persistentContainer.viewContext
        print(NSPersistentContainer.defaultDirectoryURL())
        //insertUserData()
        //queryWithPredicate()
        //queryAllUserData()
        //deleteAllUserData()
        //storedFetch()
        //insert_onetooMany()
        //query_onetooMany()
        for i in 1...3{
            if let image = UIImage(named: "0\(i).jpg"){
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
        saveImage()
        loadImage()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        myImage.image = image
        dismiss(animated: true, completion: nil)
    }
    func loadImage(){
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        let predicate = NSPredicate(format: "cid like 'B10715059'")
        fetchRequest.predicate = predicate
        do{
            let allUsers = try viewContext.fetch(fetchRequest)
            for user in allUsers {
                myImage.image = UIImage(data: user.cimage! as Data)
            }
        } catch {
            print(error)
        }
    }
    func query_onetooMany(){
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        let predicate = NSPredicate(format: "cid like 'M10815055'")
        fetchRequest.predicate = predicate
        do{
            let allUsers = try viewContext.fetch(fetchRequest)
            for user in allUsers {
                if user.own == nil{
                    print("\((user.cname)!),沒有車")
                }
                else {
                    print("\((user.cname)!)有\((user.own?.count)!)部車")
                    for car in user.own as! Set<Car> {
                        print("車牌是 \((car.plate)!)")
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    func saveImage(){
        let user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "B10715059"
        user.cname = "Jessica"
        let image = UIImage(named: "01.jpg")
        let imageData = image?.pngData()
        user.cimage = imageData
        app.saveContext()
    }
    func storedFetch(){
        let model = app.persistentContainer.managedObjectModel
        if let fetchRequest = model.fetchRequestTemplate(forName: "FtchRst_cname_BeginsA"){
            do{
                let allUsers = try viewContext.fetch(fetchRequest)
                for user in allUsers as! [UserData] {
                    print("\((user.cid)!),\((user.cname)!)")
                }
            } catch {
                print(error)
            }
        }
    }
    func insert_onetooMany(){
        let user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "M10815055"
        user.cname = "Yuan"
        
        var car = NSEntityDescription.insertNewObject(forEntityName: "Car", into: viewContext) as! Car
        car.plate = "811-MYG"
        user.addToOwn(car)
        car = NSEntityDescription.insertNewObject(forEntityName: "Car", into: viewContext) as! Car
        car.plate = "BBT-9088"
        user.addToOwn(car)
        app.saveContext()
        
    }
    func insertUserData(){
        var user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "M10815055"
        user.cname = "Yuan"
        
        user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "M10815066"
        user.cname = "Evan"
        
        user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "M10815069"
        user.cname = "Abby"
        
        user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.cid = "M10815071"
        user.cname = "Alex"
        
        app.saveContext()
    }
    func queryWithPredicate(){
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        let predicate = NSPredicate(format: "cname like 'A*'")
        fetchRequest.predicate = predicate
        let sort = NSSortDescriptor(key: "cid" , ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do{
            let allUsers = try viewContext.fetch(fetchRequest)
            for user in allUsers {
                print("\((user.cid)!),\((user.cname)!)")
            }
        } catch {
            print(error)
        }
    }
    func queryAllUserData(){
        do{
            let allUsers = try viewContext.fetch(UserData.fetchRequest())
            for user in allUsers as! [UserData]{
                print("\((user.cid)!),\((user.cname)!)")
            }
        } catch {
            print(error)
        }
    }
    func deleteAllUserData(){
        do{
            let allUsers = try viewContext.fetch(UserData.fetchRequest())
            for user in allUsers as! [UserData]{
                viewContext.delete(user)
            }
            app.saveContext()
            print("successful delete")
        } catch {
            print(error)
        }
    }
}

