//
//  Launch_VC.swift
//  Jottr
//
//  Created by John Garrett on 12/14/18.
//  Copyright © 2018 John Garrett. All rights reserved.
//

import UIKit
import FirebaseAuth
class Launch_VC: UIViewController {

	override func viewDidAppear(_ animated: Bool) {
		if (Auth.auth().currentUser != nil){
			print("There is a user already named \(Auth.auth().currentUser!.uid)")
			UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "UID")
			self.performSegue(withIdentifier: "launchToMainView", sender: nil)
		}
		else{
			self.performSegue(withIdentifier: "launchToVerif", sender: nil)
		}
        // Do any additional setup after loading the view.
    }
    

}
