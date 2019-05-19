//
//  Profile.swift
//  NewsProject
//
//  Created by Aleksandr Avdukich on 17/05/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import UIKit

class Profile {
    var name: String
    var city: String
    var email: String
    var image: UIImage? = nil
    
    init(name: String, city: String, email: String) {
        self.name = name
        self.city = city
        self.email = email
    }
}
