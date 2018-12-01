//
//  MainContainer_VC.swift
//  Jottr
//
//  Created by John Garrett on 12/1/18.
//  Copyright © 2018 John Garrett. All rights reserved.
//

import UIKit

class MainContainer_VC: UIViewController {

	@IBOutlet var feedContainerView: UIView!
	@IBOutlet var hamburgerContainerView: UIView!
	@IBOutlet weak var hamburgerMenuConstraint: NSLayoutConstraint!
	var hamburgerMenuVisible = false
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(toggleHamburgerMenu), name: NSNotification.Name("ToggleHamburgerMenu"), object: nil)
		
//		let tap = UITapGestureRecognizer(target: feedContainerView, action: #selector(self.handleTap(_:)))
//		feedContainerView.addGestureRecognizer(tap)
    }
//	//if user clicked on main view
//	@objc func handleTap(_ sender: UITapGestureRecognizer) {
//		toggleHamburgerMenu()
//	}
//
	@objc func toggleHamburgerMenu(){ //@objc requred for notification center to access
		if (hamburgerMenuVisible){
				hamburgerMenuConstraint.constant = -210
				hamburgerMenuVisible = false
		}
		else{
			hamburgerMenuConstraint.constant = 0
			hamburgerMenuVisible = true
		}
		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
			self.hamburgerContainerView.layer.shadowOffset = CGSize(width: 50, height: 0)
			self.hamburgerContainerView.layer.shadowOpacity = 1
			self.hamburgerContainerView.layer.shadowRadius = 1.0
		}
	}
}
