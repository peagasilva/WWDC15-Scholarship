//
//  MenuStates.swift
//  RaphaelSilva
//
//  Created by Raphael Silva on 4/16/15.
//  Copyright (c) 2015 Raphael Silva. All rights reserved.
//

import Foundation

enum MenuStates: String, Printable {
    case Intro = "Intro"
    case About = "About Me"
    case Experience = "Experience"
    case Education = "Education"
    case TechSkills = "Technical Skills"
    case Projects = "Projects"
    case ContactInfo = "Contact"
    case Thanks = "Thank you!"
    
    var description: String {
        get {
            return self.rawValue
        }
    }
}