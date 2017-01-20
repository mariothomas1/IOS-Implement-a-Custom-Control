//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Mario Thomas on 1/18/17.
//  Copyright © 2017 Mario Thomas. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    // MARK: Properties
    
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectedStates()
           
        }
    }
    
    @IBInspectable var STARSIZE: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starcount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: Button Action
    
    func ratingButtonTapped(button: UIButton) {
        // old code: print("Button pressed")
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons Array:\(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // if the selected star represents the current rating, reset the rating to 0
            rating = 0
        }
        else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
    }
    
    // MARK: Private Methods
    
    private func setupButtons() {
        // Clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starcount {
            // Create the button
            let button = UIButton()
            // old code: button.backgroundColor = UIColor.red
            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(filledStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
        
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: STARSIZE.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: STARSIZE.width).isActive = true
        
            // Set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Setup the button action
            button.addTarget(self, action:
                #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
        
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        
        updateButtonSelectedStates()
    }

    private func updateButtonSelectedStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If he index of a button is less than the rating, that button should be selected
            button.isSelected = index < rating
            
            // Set the hint string for the currently selected star
            let hintString: String?
            
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            }
            else {
              hintString = nil
            }
            
            // Calculate the value string
            let valueString: String
            switch (rating) {
                case 0:
                    valueString = "No rating set."
                case 1:
                    valueString = "1 star set."
                default:
                    valueString = "\(rating) stars set."
            }
            
            // Assign the hint string and the value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
 }
