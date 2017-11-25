//
//  PageController.swift
//  InteractiveStory
//
//  Created by Addison Francisco on 11/20/17.
//  Copyright © 2017 Addison Francisco. All rights reserved.
//

import UIKit
import Foundation

extension NSAttributedString {
	
	var stringRange: NSRange {
		return NSMakeRange(0, self.length)
	}
}

extension Story {
	
	var attributedText: NSAttributedString {
		
		let attributedString = NSMutableAttributedString(string: text)
		let paragraphStyle = NSMutableParagraphStyle()
		
		paragraphStyle.lineSpacing = 10
		attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
		
		return attributedString
	}
}

extension Page {
	
	func story(attributed: Bool) -> NSAttributedString {
		if attributed {
			return story.attributedText
		} else {
			return NSAttributedString(string: story.text)
		}
	}
}

class PageController: UIViewController {
	
	var page: Page?
	let soundEffectsPlayer = SoundEffectsPlayer()
	
	// MARK: - User Interface Properties
	
	lazy var artworkView: UIImageView = {
		let imageView = UIImageView()
		
		// Must do this to prevent parent view from adding it's own [conflicting] contraints
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.image = self.page?.story.artwork
		
		return imageView
	}()
	
	lazy var storyLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.attributedText = self.page?.story(attributed: true)
		
		return label
	}()
	
	lazy var firstChoiceButton: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		let title = self.page?.firstChoice?.title ?? "Play Again"
		let selector = self.page?.firstChoice != nil ? #selector(PageController.loadFirstChoice) : #selector(PageController.playAgain)
		
		button.setTitle(title, for: .normal)
		button.addTarget(self, action: selector, for: .touchUpInside)
		
		return button
	}()
	
	lazy var secondChoiceButton: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.setTitle(self.page?.secondChoice?.title, for: .normal)
		button.addTarget(self, action: #selector(PageController.loadSecondChoice), for: .touchUpInside)
		
		return button
	}()
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	init(page: Page) {
		self.page = page
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		view.addSubview(artworkView)
		
		NSLayoutConstraint.activate([
			artworkView.topAnchor.constraint(equalTo: view.topAnchor),
			artworkView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			artworkView.leftAnchor.constraint(equalTo: view.leftAnchor),
			artworkView.rightAnchor.constraint(equalTo: view.rightAnchor)
			])
		
		view.addSubview(storyLabel)
		
		NSLayoutConstraint.activate([
			// Need to use leading instead of left because this specifies where text begins in left to right language
			storyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			storyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			storyLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -48)
			])
		
		view.addSubview(firstChoiceButton)
		
		NSLayoutConstraint.activate([
			firstChoiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			firstChoiceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
			])
		
		view.addSubview(secondChoiceButton)
		
		NSLayoutConstraint.activate([
			secondChoiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			secondChoiceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
			])
	}
	
	@objc func loadFirstChoice() {
		if let page = page, let firstChoice = page.firstChoice {
			let nextPage = firstChoice.page
			let pageController = PageController(page: nextPage)
			
			soundEffectsPlayer.playSound(for: firstChoice.page.story)
			navigationController?.pushViewController(pageController, animated: true)
		}
	}
	
	@objc func loadSecondChoice() {
		if let page = page, let secondChoice = page.secondChoice {
			let nextPage = secondChoice.page
			let pageController = PageController(page: nextPage)
			
			soundEffectsPlayer.playSound(for: secondChoice.page.story)
			navigationController?.pushViewController(pageController, animated: true)
		}
	}
	
	@objc func playAgain() {
		navigationController?.popToRootViewController(animated: true)
	}
}
