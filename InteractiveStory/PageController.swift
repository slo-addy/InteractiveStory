//
//  PageController.swift
//  InteractiveStory
//
//  Created by Addison Francisco on 11/20/17.
//  Copyright © 2017 Addison Francisco. All rights reserved.
//

import UIKit
import Foundation

class PageController: UIViewController {
	
	var page: Page?
	
	// MARK: - User Interface Properties
	
	let artworkView = UIImageView()
	let storyLabel = UILabel()
	let firstChoiceButton = UIButton(type: .system)
	let secondChoiceButton = UIButton(type: .system)
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	init(page: Page) {
		self.page = page
		super.init(nibName: nil, bundle: nil)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		if let page = page {
			artworkView.image = page.story.artwork
			
			let attributedString = NSMutableAttributedString(string: page.story.text)
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineSpacing = 10
			
			attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
			
			storyLabel.attributedText = attributedString
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		view.addSubview(artworkView)
		
		// Must do this to prevent parent view from adding it's own [conflicting] contraints
		artworkView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			artworkView.topAnchor.constraint(equalTo: view.topAnchor),
			artworkView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			artworkView.leftAnchor.constraint(equalTo: view.leftAnchor),
			artworkView.rightAnchor.constraint(equalTo: view.rightAnchor)
			])
		
		view.addSubview(storyLabel)
		storyLabel.numberOfLines = 0
		
		// Must do this to prevent parent view from adding it's own [conflicting] contraints
		storyLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			// Need to use leading instead of left because this specifies where text begins in left to right language
			storyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			storyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			storyLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -48)
			])
	}
}
