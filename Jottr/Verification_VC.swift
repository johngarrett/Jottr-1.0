//
//  Verification_VC.swift
//  Jottr
//
//  Created by John Garrett on 11/24/18.
//  Copyright © 2018 John Garrett. All rights reserved.
//

import UIKit
import FirebaseAuth


class Verification_VC: UIViewController {

	@IBOutlet weak var txtVerificationCode: UITextField!
	let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") //pull from storage
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	@IBAction func check(_ sender: Any) {
		let credential = PhoneAuthProvider.provider().credential(
			withVerificationID: verificationID!,
			verificationCode: txtVerificationCode.text!)
		
		Auth.auth().signInAndRetrieveData(with: credential) { (authRequest, error) in
			if let error = error{
				print(error)
				return
			}
			self.performSegue(withIdentifier: "VerificationToMainView", sender: nil)
		}
	}
}
