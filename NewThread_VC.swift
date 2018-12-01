//
//  NewThread_VC.swift
//  Jottr
//
//  Created by John Garrett on 12/1/18.
//  Copyright © 2018 John Garrett. All rights reserved.
//

import UIKit
import FirebaseDatabase
class NewThread_VC: UIViewController {
	let ref = Database.database().reference().child("Users").child("UID").child("Threads")

	
	@IBOutlet var btnDone: UIBarButtonItem!
	@IBOutlet var txtColor: UITextField!
	@IBOutlet var txtThreadName: UITextField!
	
	@IBAction func beganEditing(_ sender: Any) {
		btnDone.isEnabled = true
	}
	override func viewDidLoad() {
        super.viewDidLoad()
		btnDone.isEnabled = false
    }
    
	@IBAction func cancel(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func done(_ sender: Any) {
		if let text = txtThreadName.text{
			ref.updateChildValues([text: 1])
			if let color = txtColor.text{
				ref.child(text).updateChildValues(["color":color])
			}
		}
		
		self.dismiss(animated: true, completion: nil)
	}
}
