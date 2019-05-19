//
//  ProfileServiceAssembly.swift
//  NewsProject
//
//  Created by Aleksandr Avdukich on 17/05/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import Foundation

class ProfileServiceAssembly {
    
    
    // MARK: Public Properties
    
    var profileController: ProfileTableViewController {
        return ProfileTableViewController()
    }
    
    var editProfileController: EditProfileTableViewController {
        return EditProfileTableViewController()
    }
}
