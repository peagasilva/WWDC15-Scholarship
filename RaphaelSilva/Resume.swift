//
//  Resume.swift
//  RaphaelSilva
//
//  Created by Raphael Silva on 4/18/15.
//  Copyright (c) 2015 Raphael Silva. All rights reserved.
//

import Foundation

class Resume {
    
    var about: [String:String]!
    var experiences: [[String:String]]!
    var education: [[String:String]]!
    var techSkills: [String]!
    var projects: [[String:String]]!
    var contact: [String: String]!
    
    init() {
        var resume = PlistManager().resumeDictionary
        
        if let about = resume["about"] as? [String:String],
            experiences = resume["experiences"] as? [[String:String]],
            education = resume["education"] as? [[String:String]],
            techSkills = resume["tech-skills"] as? [String],
            projects = resume["projects"] as? [[String:String]],
            contact = resume["contact"] as? [String:String] {
                
                self.about = about
                self.experiences = experiences
                self.education = education
                self.techSkills = techSkills
                self.projects = projects
                self.contact = contact
                
        } else {
            println("It was not possible to create Resume Class.")
        }
    }
    
}
