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

	@IBOutlet weak var phone_num_input: UITextField!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	@IBAction func finishedInput(_ sender: Any) {
		checkPhoneNumber(phone_num_input.text)

	}
	@IBAction func next(_ sender: Any) {
		checkPhoneNumber(phone_num_input.text)
		
	}
private func checkPhoneNumber(_ number:String?){
		PhoneAuthProvider.provider().verifyPhoneNumber(number ?? "", uiDelegate: nil) { (verificationID, error) in
			if let error = error{
				print("this isnt a phone number buddy \(error)\n\n")
				return
			}
			else{
				//save the verification ID
				UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
				self.performSegue(withIdentifier: "loginToVerification", sender: self)
			}
		}
	}
	
	
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

