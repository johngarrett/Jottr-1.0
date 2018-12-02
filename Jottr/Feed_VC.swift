//
//  Feed_VC.swift
//  Jottr
//
//  Created by John Garrett on 11/24/18.
//  Copyright © 2018 John Garrett. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Feed_VC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
	
	var jotts = [Jott]()
	var currentThread:String?
	
	@IBOutlet weak var feedName: UINavigationItem!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet var lblEmpty: UILabel!
	
	lazy var userRef = Database.database().reference().child("Users").child("UID").child("Threads")//.child(currentThread!)

	override func viewDidLoad() {
		NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: Notification.Name("currentThread"), object: nil)
        super.viewDidLoad()
    }
	
	@objc func onNotification(notification:Notification)
	{
		self.jotts.removeAll()//clear the jotts to load the new ones
		currentThread = notification.userInfo!["key"] as? String
		feedName.title = currentThread
		userRef = Database.database().reference().child("Users").child("UID").child("Threads").child(currentThread!)
		downloadJotts {
			self.collectionView.reloadData()
		}
	}
	
	func downloadJotts(completion: @escaping () -> ()){
		userRef.observe(.value) { (snapshot) in
			let enumerator = snapshot.children
			
			while let rest = enumerator.nextObject() as? DataSnapshot{
				for child in rest.children.allObjects as! [DataSnapshot] {
					if let dict = child.value as? [String:AnyObject]{
						let jott = Jott()
						jott.name = dict["name"] as? String
						jott.text = dict["text"] as? String
						jott.time = dict["time"] as? Int
						
						self.jotts.insert(jott, at: 0)
					}
				}
			}
			completion()
		}
		userRef.removeAllObservers()
		userRef.observe(.childAdded) { (snapshot) in
			let enumerator = snapshot.children
			while let rest = enumerator.nextObject() as? DataSnapshot{
				for child in rest.children.allObjects as! [DataSnapshot] {
					if let dict = child.value as? [String:AnyObject]{
						let jott = Jott()
						jott.name = dict["name"] as? String
						jott.text = dict["text"] as? String
						jott.time = dict["time"] as? Int
						self.jotts.insert(jott, at: 0)
						
						let firstItemIndex = IndexPath(item: 0, section: 0)
						self.collectionView?.scrollToItem(at: firstItemIndex, at: .top, animated: true)
					}
				}
			}
		}
		
	}
	
	@IBAction func hamburgerBtnTapped(){NotificationCenter.default.post(name: NSNotification.Name("ToggleHamburgerMenu"), object: nil)}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "feedToNewJott"{
			let destination = segue.destination as! NewJot_VC
			destination.currentThread = self.currentThread
		}
	}
	
	/********************COLLECTION VIEW METHODS*******************************/
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		lblEmpty.isHidden = (jotts.count < 1) ?  false : true
		return jotts.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "jottCell", for: indexPath) as! JottCell
		
		cell.contentView.layer.backgroundColor = UIColor.white.cgColor
		
		let jott = jotts[indexPath.item]
		cell.lblName.text = jott.name
		cell.txtText.text = jott.text
		
		if let time = jott.time{
			let date = Date(timeIntervalSince1970: TimeInterval(time))
			let dayTimePeriodFormatter = DateFormatter()
			dayTimePeriodFormatter.dateFormat = "MMM d, h:mm a"
			let dateString = dayTimePeriodFormatter.string(from: date)
			cell.lblTime.text = dateString
		}
		else{
			cell.lblTime.text = "Check Date and Time settings"
		}
		
		cell.btnDelete.layer.setValue(indexPath.row, forKey: "index")
		cell.btnDelete.addTarget(self, action: #selector(deleteJott(sender:)), for: UIControl.Event.touchUpInside)
		
		cell.formatCell()
		return cell
	}
	
	
	@objc func deleteJott(sender:UIButton) {
		let i : Int = (sender.layer.value(forKey: "index")) as! Int
		
		let refToDelete = Database.database().reference().child("Users").child("UID").child("Threads").child(jotts[i].name)
		refToDelete.removeValue()
		print(userRef.child(jotts[i].name).description())
		jotts.remove(at: i)
		let removalIndex = IndexPath(item: i, section: 0)
		collectionView.deleteItems(at: [removalIndex])
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		var height:CGFloat = 100
		if let text = jotts[indexPath.item].text{
			height = CGRect.estimateSize(text, fontSize: 17).height
			height += 70 //ex post facto adjustments
		}
		return CGSize(width: (view.frame.width) - 16, height: height)
	}
}





class JottCell:UICollectionViewCell{
	@IBOutlet var lblName: UILabel!
	@IBOutlet var lblTime: UILabel!
	@IBOutlet var txtText: UITextView!
	@IBOutlet var btnDelete: UIButton!
}

extension UICollectionViewCell{
	func formatCell(){
		self.backgroundView?.backgroundColor = UIColor.white
		self.backgroundView?.layer.masksToBounds = true
		self.contentView.layer.cornerRadius = 10
		self.contentView.layer.borderWidth = 1.0
		self.contentView.layer.borderColor = UIColor.clear.cgColor
		self.contentView.layer.masksToBounds = true;
		
		self.layer.shadowColor = UIColor.lightGray.cgColor
		self.layer.shadowOffset = CGSize(width:0,height: 1.0)
		self.layer.shadowRadius = 7
		self.layer.shadowOpacity = 0.5
		self.layer.masksToBounds = false;
		self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
	}
}

extension CGRect{
	static func estimateSize(_ txt:String, fontSize:Int) -> CGRect{
		let size = CGSize(width: 338, height: 1000)
		let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		
		return NSString(string: txt).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(fontSize), weight: .medium)], context: nil)
	}
}
