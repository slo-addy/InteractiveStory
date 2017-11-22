//
//  ViewController.swift
//  InteractiveStory
//
//  Created by Addison Francisco on 11/11/17.
//  Copyright © 2017 Addison Francisco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "startAdventure" {
			guard let pageController = segue.destination as? PageController else {
				return
			}
			pageController.page = Adventure.story
		}
	}
}
