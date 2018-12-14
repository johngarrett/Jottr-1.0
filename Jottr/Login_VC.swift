//
//  Login_VC.swift
//  Jottr
//
//  Created by John Garrett on 11/24/18.
//  Copyright © 2018 John Garrett. All rights reserved.
//

import UIKit
import FirebaseAuth
class Login_VC: UIViewController {
	
	var country_code = 1 //+1 for america
	
	@IBOutlet weak var error_label: UILabel!
	@IBOutlet weak var phone_input: UITextField!
	@IBOutlet weak var country_input: UITextField!
	
	func verifyNum(_ number :String!){
		let num = number.digits
		let phone_number = "+\(country_code)\(String(describing: num))"
		PhoneAuthProvider.provider().verifyPhoneNumber(phone_number, uiDelegate: nil) { (verificationID, error) in
			if let error = error {
				print("PHONE VERIFICATION DID NOT WORK BECAUSE OF \(error.localizedDescription)")
				self.error_label.text = error.localizedDescription
				return
			}
			print("Phone verification successful")
			UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
			self.performSegue(withIdentifier: "toVerificationCode", sender: nil)
		}
	}
	
	@IBAction func finishedCode(_ sender: Any) {
		country_code = Int(country_input.text?.digits ?? "1")! //if no text, make it a 1
	}
	
	@IBAction func finishedPhoneInput(_ sender: Any) {
		verifyNum(phone_input.text!)
	}
}

//remove non numerical input from a string, non-mutating
extension StringProtocol {
	var digits: String {
		return String(filter(("0"..."9").contains))
	}
}
