//
//  ResumeViewController.swift
//  RaphaelSilva
//
//  Created by Raphael Silva on 4/15/15.
//  Copyright (c) 2015 Raphael Silva. All rights reserved.
//

import UIKit
import MediaPlayer

class ResumeViewController: UIViewController, UIScrollViewDelegate, ExperienceViewDelegate {
    
    @IBOutlet weak var logoWWDC: UIImageView!
    @IBOutlet weak var imageHidder: UIImageView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var byLabel: UILabel!
    
    var introLabel: UILabel!
    var titleLabel: UILabel!
    var titleLabelCenter: CGPoint!
    var titleFont: String!
    var bodyFont: String!
    var italicFont: String!
    var swipeCount: Int!
    var menuStates: MenuStates!
    var resume: Resume!
    
    lazy var radians: CGFloat = {
        var radians: CGFloat = atan2( self.logoView.transform.b, self.logoView.transform.a)
        
        return radians
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.userInteractionEnabled = false
        
        self.swipeCount = 0
        
        self.titleFont = "HelveticaNeue-Light"
        self.bodyFont = "HelveticaNeue-Thin"
        self.italicFont = "HelveticaNeue-ThinItalic"
        
        self.resume = Resume()
        
        self.byLabel.alpha = 1.0
        self.byLabel.hidden = true
        
        self.scrollView.delegate = self
        self.scrollView.alpha = 0.0
        self.scrollView.hidden = true
        
        self.initTitleLabel()
        self.configScrollView()
        
        self.imageHidder.hidden = true
        
        self.configureProfilePhoto()
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("animateWWDCLogo"), userInfo: nil, repeats: false)
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    func animateWWDCLogo() {
        self.imageHidder.hidden = false
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
            self.logoView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            self.logoView.center = self.profilePhoto.center
            
            }, completion: { _ in
                self.profilePhoto.alpha = 0.0
                self.profilePhoto.hidden = false
                self.profilePhoto.fadeIn(duration: 0.20, delay: 0, completion: { _ in })
        })
        
        self.view.userInteractionEnabled = true
        self.displayContent()
    }
    
    // MARK: - ScrollView Methods
    // MARK: > ScrollView
    
    func configScrollView() {
        var y = (self.titleLabel.frame.origin.y + self.titleLabel.frame.height)
        
        self.scrollView.frame = CGRectMake(0, (self.titleLabel.frame.origin.y + self.titleLabel.frame.height) + (self.titleLabel.frame.height * 0.1), self.view.frame.width, (self.view.frame.height - y))
    }
    
    func changeContentSizeHeight(height: CGFloat) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width, height)
    }
    
    // MARK: > Scroll to Top
    
    func scrollToTop() {
        self.scrollView.setContentOffset(CGPointMake(0, 0), animated: false)
    }
    
    // MARK: > Container View
    
    func changeContainerHeight(height: CGFloat) {
        self.containerView.setHeight(height)
        
        self.changeContentSizeHeight(self.containerView.frame.height)
    }
    
    // MARK: > Clean Container View
    
    func cleanContainerView() {
        self.containerView.revomeAllSubviews()
    }
    
    // MARK: > Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            
            self.byLabel.hidden = false
        } else {
            
            self.byLabel.hidden = true
        }
    }
    
    // MARK: - Configure Profile Photo
    
    func configureProfilePhoto() {
        self.profilePhoto.image = UIImage(named: "raphael.jpg")
        self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.size.width / 2
        self.profilePhoto.clipsToBounds = true
        self.profilePhoto.layer.borderColor = UIColor.whiteColor().CGColor
        self.profilePhoto.layer.borderWidth = 2.0
        self.profilePhoto.hidden = true
    }
    
    // MARK: - Swipes Handler
    
    func handleSwipes(sender: UIGestureRecognizer) {
        self.byLabel.hidden = true
        
        if let swipeGesture = sender as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                if (self.swipeCount != 0) {
                    self.titleLabel.hidden = false
                    
                    self.radians = self.radians - CGFloat(M_PI_4)
                    
                    self.checkRadians()
                    
                    UIView.animateWithDuration(0.5, delay: 0.0, options: nil, animations: {
                        self.logoView.transform = CGAffineTransformMakeRotation(self.radians)
                        
                        self.titleLabel.fadeOut(duration: 0.15, delay: 0, completion: { _ in })
                        self.scrollView.fadeOut(duration: 0.2, delay: 0, completion: { _ in })
                        
                        }, completion: { _ in
                            self.displayContent()
                            
                            self.titleLabel.fadeIn(duration: 0.15, delay: 0, completion: { _ in })
                            self.scrollView.fadeIn(duration: 0.2, delay: 0, completion: { _ in })
                    })
                    
                    self.swipeCount = self.swipeCount - 1
                    
                    if (self.swipeCount == 0) {
                        self.titleLabel.fadeOut(duration: 0.15, delay: 0, completion: { _ in })
                        self.scrollView.fadeOut(duration: 0.2, delay: 0, completion: { _ in })
                    }
                }
            case UISwipeGestureRecognizerDirection.Left:
                self.radians = self.radians + CGFloat(M_PI_4)
                
                self.checkRadians()
                
                UIView.animateWithDuration(0.5, delay: 0.0, options: nil, animations: {
                    self.logoView.transform = CGAffineTransformMakeRotation(self.radians)
                    
                    self.titleLabel.fadeOut(duration: 0.15, delay: 0, completion: { _ in })
                    self.scrollView.fadeOut(duration: 0.2, delay: 0, completion: { _ in })
                    
                    }, completion: { _ in
                        self.displayContent()
                        
                        self.titleLabel.fadeIn(duration: 0.15, delay: 0, completion: { _ in })
                        self.scrollView.fadeIn(duration: 0.2, delay: 0, completion: { _ in })
                })
                
                self.swipeCount = self.swipeCount + 1
                
                if (self.swipeCount == 1) {
                    self.introLabel.fadeOut(duration: 0.2, delay: 0, completion: { _ in })
                } else if (self.swipeCount > 7) {
                    self.swipeCount = 0
                } else if (self.swipeCount == 0) {
                    self.titleLabel.alpha = 0
                }
            default:
                break
            }
        }
    }
    
    // MARK: - Display Content Methods
    
    func displayContent() {
        
        switch self.radians {
        case CGFloat(M_PI_4):
            self.menuStates = .Projects
            
            self.scrollToTop()
            self.cleanContainerView()
            self.loadProjects()
            
        case CGFloat(M_PI_2):
            self.menuStates = .ContactInfo
            
            self.scrollToTop()
            self.cleanContainerView()
            self.loadContactInfo()
            
        case CGFloat(M_PI_4 * 3):
            self.menuStates = .Thanks
            
            self.scrollToTop()
            self.cleanContainerView()
            self.loadThanksInfo()
            
        case CGFloat(M_PI):
            self.menuStates = .Intro
            
            self.scrollToTop()
            self.cleanContainerView()
            self.loadIntro()
            
        case CGFloat(M_PI + M_PI_4):
            self.menuStates = .About
            
            self.scrollToTop()
            self.cleanContainerView()
            self.loadAboutMe()
            
        case CGFloat(M_PI + M_PI_2):
            self.menuStates = .Experience
            
            self.scrollToTop()
            self.cleanContainerView()
            self.loadExperience()
            
        case CGFloat((M_PI * 2) - M_PI_4):
            self.menuStates = .Education
            
            self.scrollToTop()
            self.cleanContainerView()
            self.loadEducation()

        case CGFloat(M_PI * 2):
            self.menuStates = .TechSkills
            
            self.scrollToTop()
            self.cleanContainerView()
            self.loadTechSkills()
            
        default:
            break
        }
    }
    
    // MARK: > Content loading Methods
    
    func loadIntro() {
        self.scrollView.hidden = true
        self.titleLabel.hidden = true
        
        self.introLabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.width, 40))
        self.introLabel.center = self.scrollView.center
        self.introLabel.font = UIFont(name: self.bodyFont, size: 30)
        self.introLabel.textColor = UIColor.lightGrayColor()
        self.introLabel.textAlignment = NSTextAlignment.Center
        self.introLabel.text = "< swipe left to start" // ≪
        self.introLabel.alpha = 0.0
        self.view.addSubview(self.introLabel)
        
        self.introLabel.fadeIn(duration: 1.0, delay: 0, completion: { _ in })
    }
    
    func loadAboutMe() {
        self.changeTitleLabelText(self.menuStates.description.uppercaseString)
        
        let labelName = UILabel(frame: CGRectMake(0, 5, self.view.frame.width, 30))
        labelName.font = UIFont(name: self.titleFont, size: 25)
        labelName.numberOfLines = 0
        labelName.textColor = UIColor.whiteColor()
        labelName.text = self.resume.about["name"]
        labelName.textAlignment = NSTextAlignment.Center
        labelName.sizeToFit()
        labelName.setWidth(self.containerView.frame.width)
        
        let labelAbout = UILabel(frame: CGRectMake(20, (labelName.frame.origin.y + labelName.frame.height) + 5, self.containerView.frame.width, 100))
        labelAbout.font = UIFont(name: self.italicFont, size: 20)
        labelAbout.numberOfLines = 0
        labelAbout.textColor = UIColor.whiteColor()
        labelAbout.text = self.resume.about["aboutme"]
        labelAbout.textAlignment = NSTextAlignment.Center
        labelAbout.setWidth(self.containerView.frame.width - 40)
        
        let labelSummary = UILabel(frame: CGRectMake(20, (labelAbout.frame.origin.y + labelAbout.frame.height) + 5, self.containerView.frame.width - 40, 30))
        labelSummary.font = UIFont(name: self.bodyFont, size: 20)
        labelSummary.numberOfLines = 0
        labelSummary.textColor = UIColor.whiteColor()
        labelSummary.text = self.resume.about["summary"]
        labelSummary.textAlignment = NSTextAlignment.Left
        labelSummary.sizeToFit()
        
        self.containerView.setHeight(labelSummary.frame.origin.y + labelSummary.frame.size.height + 20)
        self.containerView.blurBackground(UIBlurEffectStyle.Light)
        
        self.containerView.addSubview(labelName)
        self.containerView.addSubview(labelAbout)
        self.containerView.addSubview(labelSummary)
        
        self.configScrollView()
        self.changeContainerHeight(self.containerView.frame.height)
        
        self.scrollView.hidden = false
        self.scrollView.alpha = 0
        self.scrollView.fadeIn(duration: 0.1, delay: 0, completion: { _ in })
    }
    
    func loadExperience() {
        self.changeTitleLabelText(self.menuStates.description.uppercaseString)
        
        var viewsHeight: CGFloat = 0
        var experiences = [ExperienceView]()
        
        for experience in self.resume.experiences {
            let experienceView = ExperienceView(frame: CGRectMake(0, viewsHeight, self.containerView.frame.width, 200))
            
            experienceView.delegate = self
            experienceView.url = experience["url"]
            experienceView.positionLabel.text = experience["position"]
            experienceView.companyButton.setTitle("@ " + experience["company"]!, forState: UIControlState.Normal)
            experienceView.periodLabel.text = experience["duration"]
            experienceView.descriptionLabel.text = experience["description"]
            experienceView.descriptionLabel.textAlignment = NSTextAlignment.Justified
            experienceView.descriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            experienceView.descriptionLabel.sizeToFit()
            
            var descriptionLabelHeight: CGFloat = experienceView.descriptionLabel.frame.height * 0.85
            
            experienceView.descriptionLabel.setWidth(experienceView.contentView.frame.width)
            experienceView.descriptionLabel.setHeight(descriptionLabelHeight)
            
            var contentViewHeight: CGFloat = experienceView.descriptionLabel.frame.origin.y + experienceView.descriptionLabel.frame.height
            
            experienceView.contentView.setHeight(contentViewHeight)
            
            var experienceViewHeight: CGFloat = experienceView.contentView.frame.origin.y + experienceView.contentView.frame.height + 5
            
            experienceView.setHeight(experienceViewHeight)
            
            experiences.append(experienceView)
            
            viewsHeight += experienceViewHeight
        }
        
        self.configScrollView()
        self.changeContainerHeight(viewsHeight + 15);
        self.containerView.blurBackground(UIBlurEffectStyle.Light)
        
        for xpView in experiences {
            self.containerView.addSubview(xpView)
        }
    }
    
    func loadEducation() {
        self.changeTitleLabelText(self.menuStates.description.uppercaseString)
        
        var labels = [UILabel]()
        var yPosition: CGFloat = 5
        
        for school in self.resume.education {
            let labelSchoolName = UILabel(frame: CGRectMake(20, yPosition, self.view.frame.width - 40, 30))
            labelSchoolName.font = UIFont(name: self.titleFont, size: 25)
            labelSchoolName.numberOfLines = 0
            labelSchoolName.textColor = UIColor.whiteColor()
            labelSchoolName.text = school["school"]
            labelSchoolName.sizeToFit()
            
            let labelPeriod = UILabel(frame: CGRectMake(20, yPosition + labelSchoolName.frame.height, self.view.frame.width - 40, 30))
            labelPeriod.font = UIFont(name: self.italicFont, size: 20)
            labelPeriod.numberOfLines = 0
            labelPeriod.textColor = UIColor.whiteColor()
            labelPeriod.text = school["period"]
            
            let labelInfo = UILabel(frame: CGRectMake(20, labelPeriod.frame.origin.y + labelPeriod.frame.height, self.view.frame.width - 40, 30))
            labelInfo.font = UIFont(name: self.bodyFont, size: 20)
            labelInfo.numberOfLines = 0
            labelInfo.textColor = UIColor.whiteColor()
            labelInfo.text = school["info"]
            labelInfo.sizeToFit()
            
            labels.append(labelSchoolName)
            labels.append(labelPeriod)
            labels.append(labelInfo)
            
            yPosition = labelInfo.frame.origin.y + labelInfo.frame.height + 15
        }
        
        self.changeContainerHeight(yPosition);
        self.containerView.blurBackground(UIBlurEffectStyle.Light)
        
        for label in labels {
            self.containerView.addSubview(label)
        }
    }
    
    func loadTechSkills() {
        self.changeTitleLabelText(self.menuStates.description.uppercaseString)
        
        var labels = [UILabel]()
        var yPosition: CGFloat = 5
        
        for techSkill in self.resume.techSkills {
            let label = UILabel(frame: CGRectMake(20, yPosition, self.view.frame.width - 40, 30))
            label.font = UIFont(name: self.bodyFont, size: 20)
            label.numberOfLines = 0
            label.textColor = UIColor.whiteColor()
            label.text = techSkill
            label.sizeToFit()
            
            labels.append(label)
            
            yPosition = label.frame.origin.y + label.frame.height + 5
        }
        
        self.changeContainerHeight(yPosition + 15);
        self.containerView.blurBackground(UIBlurEffectStyle.Light)
        
        for label in labels {
            self.containerView.addSubview(label)
        }
    }
    
    func loadProjects() {
        self.changeTitleLabelText(self.menuStates.description.uppercaseString)
        
        var labels = [UILabel]()
        var buttons = [UIButton]()
        var yPosition: CGFloat = 5
        
        for (index, project) in enumerate(self.resume.projects) {
            let labelTitle = UILabel(frame: CGRectMake(20, yPosition, self.view.frame.width - 40, 30))
            labelTitle.font = UIFont(name: self.titleFont, size: 25)
            labelTitle.numberOfLines = 0
            labelTitle.textColor = UIColor.whiteColor()
            labelTitle.text = project["title"]
            labelTitle.sizeToFit()
            
            let labelDescription = UILabel(frame: CGRectMake(20, labelTitle.frame.origin.y + labelTitle.frame.height, self.view.frame.width - 40, 30))
            labelDescription.font = UIFont(name: self.bodyFont, size: 20)
            labelDescription.numberOfLines = 0
            labelDescription.textColor = UIColor.whiteColor()
            labelDescription.text = project["description"]
            labelDescription.sizeToFit()
            
            yPosition = labelDescription.frame.origin.y + labelDescription.frame.height + 5
            
            if (project["url"] != "") {
                var button = UIButton(frame: CGRectMake(20, yPosition, self.view.frame.width - 40, 30))
                
                button.backgroundColor = UIColor.clearColor()
                button.tag = index
                
                if (project["title"] == "Ludwig") {
                    button.setTitle("Watch Videos", forState: UIControlState.Normal)
                    button.enabled = false
                } else if (project["title"] == "English for Kids - Lite") {
                    button.setTitle("Go to App Store (iPad only)", forState: UIControlState.Normal)
                } else {
                    button.setTitle("Go to App Store", forState: UIControlState.Normal)
                }
                
                button.titleLabel!.font = UIFont(name: self.bodyFont, size: 20)
                button.setTitleColor(UIColor(red: 0.988, green: 0.702, blue: 0.227, alpha: 1.0), forState: UIControlState.Normal)
                button.titleLabel?.numberOfLines = 0
                button.titleLabel?.sizeToFit()
                button.addTarget(self, action: "buttonProjectAction:", forControlEvents: UIControlEvents.TouchUpInside)
                
                yPosition = button.frame.origin.y + button.frame.height + 20
                
                buttons.append(button)
            } else {
                yPosition += 15
            }
            
            labels.append(labelTitle)
            labels.append(labelDescription)
        }
        
        self.changeContainerHeight(yPosition);
        self.containerView.blurBackground(UIBlurEffectStyle.Light)
        
        for label in labels {
            self.containerView.addSubview(label)
        }
        
        for button in buttons {
            self.containerView.addSubview(button)
        }
    }
    
    func loadContactInfo() {
        self.changeTitleLabelText(self.menuStates.description.uppercaseString)
        
        var labels = [UILabel]()
        var buttons = [UIButton]()
        var yPosition: CGFloat = 5
        
        let labelName = UILabel(frame: CGRectMake(20, yPosition, self.view.frame.width - 40, 30))
        labelName.font = UIFont(name: self.titleFont, size: 25)
        labelName.numberOfLines = 0
        labelName.textColor = UIColor.whiteColor()
        labelName.text = self.resume.about["name"]
        
        yPosition = labelName.frame.origin.y + labelName.frame.height + 5
        
        var i = 0
        
        for (key, contact) in self.resume.contact {
            
            let label = UILabel(frame: CGRectMake(20, yPosition, self.view.frame.width - 40, 30))
            label.font = UIFont(name: self.titleFont, size: 20)
            label.numberOfLines = 0
            label.textColor = UIColor.whiteColor()
            label.text = key
            label.sizeToFit()
            
            var button = UIButton()
            
            if (key == "LinkedIn") {
                button = UIButton(frame: CGRectMake(20, label.frame.origin.y + label.frame.height, self.view.frame.width - 40, 50))
            } else {
                button = UIButton(frame: CGRectMake(20, label.frame.origin.y + label.frame.height, self.view.frame.width - 40, 30))
            }
            
            button.backgroundColor = UIColor.clearColor()
            button.tag = i;
            button.setTitle(contact, forState: UIControlState.Normal)
            button.titleLabel!.font = UIFont(name: self.bodyFont, size: 20)
            button.setTitleColor(UIColor(red: 0.988, green: 0.702, blue: 0.227, alpha: 1.0), forState: UIControlState.Normal)
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.sizeToFit()
            button.addTarget(self, action: "buttonContactAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            labels.append(label)
            buttons.append(button)
            
            yPosition = button.frame.origin.y + button.frame.height + 5
            
            i++
        }
        
        self.changeContainerHeight(yPosition + 15);
        self.containerView.blurBackground(UIBlurEffectStyle.Light)
        self.containerView.addSubview(labelName)
        
        for (var i = 0; i < labels.count; i++) {
            self.containerView.addSubview(labels[i])
            self.containerView.addSubview(buttons[i])
        }
    }
    
    func loadThanksInfo() {
        self.changeTitleLabelText(self.menuStates.description.uppercaseString)
        
        self.titleLabel.alpha = 0.0
        
        UIView.animateWithDuration(0.75, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.titleLabelCenter = self.titleLabel.center
            self.titleLabel.alpha = 1.0
            self.titleLabel.center = CGPointMake(self.titleLabel.center.x, (self.view.frame.height * 0.62))
            self.titleLabel.transform = CGAffineTransformScale(self.titleLabel.transform, 1.5, 1.5)
            
            }, completion: nil)
    }
    
    // MARK: > Title Lable
    
    func initTitleLabel() {
        self.titleLabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.width, 40))
        self.titleLabel.center = CGPointMake(self.containerView.center.x, (self.view.frame.height * 0.4))
        self.titleLabel.font = UIFont(name: self.bodyFont, size: 40)
        self.titleLabel.textColor = UIColor.lightGrayColor()
        self.titleLabel.textAlignment = NSTextAlignment.Center
        
        self.titleLabelCenter = self.titleLabel.center
        
        self.view.addSubview(self.titleLabel)
    }
    
    func changeTitleLabelText(string: String) {
        self.titleLabel.hidden = false
        
        self.titleLabel.center = self.titleLabelCenter
        self.titleLabel.transform = CGAffineTransformIdentity
        
        self.titleLabel.text = string
    }
    
    // MARK: - Check Radians
    
    func checkRadians() {
        if (self.radians > CGFloat((M_PI * 2))) {
            self.radians = CGFloat(M_PI_4);
        } else if (self.radians < CGFloat(M_PI_4)) {
            self.radians = CGFloat(M_PI * 2)
        }
    }
    
    // MARK: - Experience View Delegate Method
    
    func didPressButton(sender: AnyObject) {
        if let expView = sender as? ExperienceView {
            UIApplication.sharedApplication().openURL(NSURL(string: expView.url)!)
        }
    }
    
    // MARK: - Button Action
    
    func buttonContactAction(sender: UIButton!) {
        switch sender.tag {
        case 0:
            if let phone = sender.titleLabel?.text {
                if UIApplication.sharedApplication().canOpenURL(NSURL(string: "tel:\(phone)")!) {
                    UIApplication.sharedApplication().openURL(NSURL(string: "tel:\(phone)")!)
                } else {
                    println(String(format: "It was not possible to open tel:%@", phone))
                }
            }
        case 1:
            if let url = sender.titleLabel?.text {
                if UIApplication.sharedApplication().canOpenURL(NSURL(string: url)!) {
                    UIApplication.sharedApplication().openURL(NSURL(string: url)!)
                } else {
                    println(String(format: "It was not possible to open %@", url))
                }
            }
        case 2:
            if let url = sender.titleLabel?.text {
                if UIApplication.sharedApplication().canOpenURL(NSURL(string: url)!) {
                    UIApplication.sharedApplication().openURL(NSURL(string: url)!)
                } else {
                    println(String(format: "It was not possible to open %@", url))
                }
            }
        case 3:
            if let email = sender.titleLabel?.text {
                if UIApplication.sharedApplication().canOpenURL(NSURL(string: "mailto:\(email)")!) {
                    UIApplication.sharedApplication().openURL(NSURL(string: "mailto:\(email)")!)
                } else {
                    println(String(format: "It was not possible to open mailto:%@", email))
                }
            }
        default:
            break
        }
    }
    
    func buttonProjectAction(sender: UIButton!) {
        switch sender.tag {
        case 0:
            let optionMenu = UIAlertController(title: nil, message: "Please, choose a video", preferredStyle: .ActionSheet)
            
            let video1Action = UIAlertAction(title: "POC App Field Test Video", style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                if let url = NSBundle.mainBundle().URLForResource("Ludwig-1", withExtension: "m4v") {
                    
                    let moviePlayer = MPMoviePlayerViewController(contentURL: url)
                    
                    if let player = moviePlayer {
                        player.moviePlayer.fullscreen = true
                        player.moviePlayer.allowsAirPlay = true
                        player.moviePlayer.controlStyle = MPMovieControlStyle.Fullscreen
                        
                        self.presentViewController(moviePlayer!, animated: true, completion: { _ in
                            player.moviePlayer.play()
                        })
                    } else {
                        println("No player available")
                    }
                } else {
                    println("File not found")
                }
            })
            
            let video2Action = UIAlertAction(title: "Final App Video", style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                if let url = NSBundle.mainBundle().URLForResource("Ludwig-2", withExtension: "m4v") {
                    
                    let moviePlayer = MPMoviePlayerViewController(contentURL: url)
                    
                    if let player = moviePlayer {
                        player.moviePlayer.fullscreen = true
                        player.moviePlayer.allowsAirPlay = true
                        player.moviePlayer.controlStyle = MPMovieControlStyle.Fullscreen
                        
                        self.presentViewController(moviePlayer!, animated: true, completion: { _ in
                            player.moviePlayer.play()
                        })
                    } else {
                        println("No player available")
                    }
                } else {
                    println("File not found")
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                println("Cancelled")
            })
            
            optionMenu.addAction(video1Action)
            optionMenu.addAction(video2Action)
            optionMenu.addAction(cancelAction)
            
            self.presentViewController(optionMenu, animated: true, completion: nil)
            
        default:
            if let url = self.resume.projects[sender.tag]["url"] {
                if UIApplication.sharedApplication().canOpenURL(NSURL(string: url)!) {
                    UIApplication.sharedApplication().openURL(NSURL(string: url)!)
                } else {
                    println(String(format: "It was not possible to open %@", url))
                }
            }
        }
    }
}
