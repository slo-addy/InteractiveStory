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
        
        view.backgroundColor = .white
		
		if let page = page {
			artworkView.image = page.story.artwork
			
			let attributedString = NSMutableAttributedString(string: page.story.text)
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineSpacing = 10
			
			attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
			
			storyLabel.attributedText = attributedString
            
            if let firstChoice = page.firstChoice {
                firstChoiceButton.setTitle(firstChoice.title, for: .normal)
                firstChoiceButton.addTarget(self, action: #selector(PageController.loadFirstChoice), for: .touchUpInside)
            } else {
                firstChoiceButton.setTitle("Play Again", for: .normal)
                firstChoiceButton.addTarget(self, action: #selector(PageController.playAgain), for: .touchUpInside)
            }
            
            if let secondChoice = page.secondChoice {
                secondChoiceButton.setTitle(secondChoice.title, for: .normal)
                secondChoiceButton.addTarget(self, action: #selector(PageController.loadSecondChoice), for: .touchUpInside)
            }
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
		storyLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			// Need to use leading instead of left because this specifies where text begins in left to right language
			storyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			storyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			storyLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -48)
			])
        
        view.addSubview(firstChoiceButton)
        firstChoiceButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            firstChoiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstChoiceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
            ])
        
        view.addSubview(secondChoiceButton)
        secondChoiceButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            secondChoiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondChoiceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
            ])
	}
    
    @objc func loadFirstChoice() {
        if let page = page, let firstChoice = page.firstChoice {
            let nextPage = firstChoice.page
            let pageController = PageController(page: nextPage)
            
            navigationController?.pushViewController(pageController, animated: true)
        }
    }
    
    @objc func loadSecondChoice() {
        if let page = page, let secondChoice = page.secondChoice {
            let nextPage = secondChoice.page
            let pageController = PageController(page: nextPage)
            
            navigationController?.pushViewController(pageController, animated: true)
        }
    }
    
    @objc func playAgain() {
        navigationController?.popToRootViewController(animated: true)
    }
}
