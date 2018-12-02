//
//  Hamburger_VC.swift
//  Jottr
//
//  Created by John Garrett on 12/1/18.
//  Copyright © 2018 John Garrett. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Hamburger_VC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var currentThread:String?
	var threadNames = [String]()
	@IBOutlet var tableView: UITableView!
	lazy var userRef = Database.database().reference().child("Users").child("UID").child("Threads")
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return threadNames.count;
	}
	
	@IBAction func swipeAway(_ sender: Any) {
		NotificationCenter.default.post(name: NSNotification.Name("ToggleHamburgerMenu"), object: nil)
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ThreadCell", for: indexPath) as! ThreadCell
		cell.lblThreadName.text = threadNames[indexPath.item]
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let dictionary = ["key":threadNames[indexPath.item]]
		NotificationCenter.default.post(name: Notification.Name("currentThread"), object: nil, userInfo: dictionary)
		NotificationCenter.default.post(name: NSNotification.Name("ToggleHamburgerMenu"), object: nil)
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if (editingStyle == .delete) {
			userRef.child(threadNames[indexPath.row]).removeValue()
			threadNames.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
		}
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.backgroundColor = UIColor.clear
		NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: Notification.Name("currentThread"), object: nil)
		getThreadNames{
			if (self.threadNames.count > 0){//else, they're a first time user
				let dictionary = ["key": self.threadNames[0]]
				NotificationCenter.default.post(name: Notification.Name("currentThread"), object: nil, userInfo: dictionary)
				self.tableView.reloadData()
			}
		}
    }
	@objc func onNotification(notification:Notification)
	{
		currentThread = notification.userInfo!["key"] as? String
//		if (threadNames[indexPath.item] == currentThread){
//			cell.backgroundColor = UIColor.white
//		}
//		else{
//			cell.backgroundColor = UIColor.clear
//		}
	}
	func getThreadNames(completion :@escaping () -> ()){
		userRef.observe(.value) { (snapshot) in
			for threadName in snapshot.children.allObjects as! [DataSnapshot]{
				if !(self.threadNames.contains(threadName.key)){//don't duplicate values
					self.threadNames.append(threadName.key)//add it to the array
				}
			}
			completion()
		}
	}
    

}
class ThreadCell:UITableViewCell{
	@IBOutlet weak var lblThreadName: UILabel!
	var color:String?
	
}
