//
//  ExperienceView.swift
//  RaphaelSilva
//
//  Created by Raphael Silva on 4/19/15.
//  Copyright (c) 2015 Raphael Silva. All rights reserved.
//

import UIKit

protocol ExperienceViewDelegate {
    func didPressButton(sender: AnyObject)
}

class ExperienceView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var companyButton: UIButton!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var delegate: ExperienceViewDelegate?
    var url: String!
    var view: UIView!
    var nibName: String = "ExperienceView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    
    func setup() {
        self.view = loadViewFromNib()
        
        self.view.frame = self.bounds
        self.view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        addSubview(self.view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    // MARK: - Button Pressed Method
    
    @IBAction func didPressButton(sender: AnyObject) {
        if let actualDelegate = self.delegate {
            actualDelegate.didPressButton(self)
        }
    }
}
