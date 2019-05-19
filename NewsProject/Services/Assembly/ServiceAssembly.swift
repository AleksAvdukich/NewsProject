//
//  ServiceAssembly.swift
//  NewsProject
//
//  Created by Aleksandr Avdukich on 17/05/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import Foundation

class ServiceAssembly {
    
    
    // MARK: Public Properties
    
    var settingController: SettingsTableViewController {
        return SettingsTableViewController()
    }
    
    var detailController: DetailNewsViewController {
        return DetailNewsViewController()
    }
}
