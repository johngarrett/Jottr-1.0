//
//  NewJot_VC.swift
//  Jottr
//
//  Created by John Garrett on 11/24/18.
//  Copyright © 2018 John Garrett. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class NewJot_VC: UIViewController {

	var currentThread:String?
	let UID:String = UserDefaults.standard.string(forKey: "UID") ?? (Auth.auth().currentUser?.uid)! //pull from storage
	
	@IBOutlet var btnSave: UIBarButtonItem!
	@IBOutlet var lblTitle: UINavigationItem!
	@IBOutlet var txtText: UITextField!
	
	@IBOutlet var txtName: UITextField!
	override func viewDidLoad() {
        super.viewDidLoad()
		btnSave.isEnabled = false
		//the drop down is gonna let you chose which thread to post it in
		super.viewDidLoad()
		lblTitle.title = "Jott to \(currentThread!)"
    }
	
	@IBAction func cancel(_ sender: Any) {self.dismiss(animated: true, completion: nil)}
	@IBAction func startedEditing(_ sender: Any) {btnSave.isEnabled = true}

	
	@IBAction func save(_ sender: Any) {
		if (txtName.text == nil || txtText.text == nil){
			txtName.placeholder = "Add a name"
			return
		}
		else{
			let ref = Database.database().reference().child("Users").child(UID).child("Threads")
				.child(currentThread!).child("Jotts").child(txtName.text!.trimmingCharacters(in: .whitespaces))
			
			let time = UInt64(NSDate().timeIntervalSince1970 * 1000)
			
			
			let dict = ["name": txtName.text?.trimmingCharacters(in: .whitespaces) ?? "null",
						"text":  txtText.text?.trimmingCharacters(in: .whitespaces) ?? "",
						"time": time] as [String : Any]
			ref.updateChildValues(dict)
			self.dismiss(animated: true, completion: nil)
		}
	}
	
}
