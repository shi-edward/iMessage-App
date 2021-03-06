//
//  ProfileTableViewController.swift
//  iMessage
//
//  Created by Edward on 7/23/16.
//  Copyright © 2016 Edward. All rights reserved.
//

import UIKit
//这个页面不显示内容
class ProfileTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "EDIT PROFILE"
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileTableViewController.selectPhoto(_:)))
        tap.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(tap)
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.clipsToBounds = true
        
        if let user = DataService.dataService.currentUser{
            username.text = user.displayName
            email.text = user.email
            if user.photoURL != nil{
                if let data = NSData(contentsOfURL: user.photoURL!){
                    self.profileImage.image = UIImage.init(data: data)
                }
            }
        }
    }
    func selectPhoto(tap: UITapGestureRecognizer){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            imagePicker.sourceType = .Camera
        }else{
            imagePicker.sourceType = .PhotoLibrary
        }
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        profileImage.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func saveDidTapped(sender: AnyObject) {
        var data = NSData()
        data = UIImageJPEGRepresentation(profileImage.image!, 0.1)!
        ProgressHUD.show("Please wait...", interaction: false)
        DataService.dataService.saveProfile(username.text!, email: email.text!, data: data)
    }


}
