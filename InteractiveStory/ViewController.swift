//
//  ViewController.swift
//  InteractiveStory
//
//  Created by Addison Francisco on 11/11/17.
//  Copyright © 2017 Addison Francisco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "startAdventure" {
			
			do {
				if let name = nameTextField.text {
					if name == "" {
						throw AdventureError.nameNotProvided
					} else {
						guard let pageController = segue.destination as? PageController else { return }
						pageController.page = Adventure.story(withName: name)
					}
				}
			} catch AdventureError.nameNotProvided {
				let alertController = UIAlertController(title: "Name not provided", message: "Provide to start the story", preferredStyle: .alert)
				let action = UIAlertAction(title: "OK", style: .default, handler: nil)
				alertController.addAction(action)
				
				present(alertController, animated: true, completion: nil)
			} catch let error {
				fatalError("\(error.localizedDescription)")
			}
		}
	}
	
	@objc func keyboardWillShow(_ notification: Notification) {
		if let info = notification.userInfo, let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
			let frame = keyboardFrame.cgRectValue
			textFieldBottomConstraint.constant = frame.size.height + 10
			
			UIView.animate(withDuration: 0.8) {
				self.view.layoutIfNeeded()
			}
		}
	}
	
	@objc func keyboardWillHide(_ notification: Notification) {
		textFieldBottomConstraint.constant = 40
		
		UIView.animate(withDuration: 0.8) {
			self.view.layoutIfNeeded()
		}
	}
	
	deinit {
		// Must remove self as registered observer when being released from memory
		// If your app targets iOS 9.0 and later or macOS 10.11 and later,
		// you don't need to unregister an observer in its dealloc method
		NotificationCenter.default.removeObserver(self)
	}
}

extension ViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
