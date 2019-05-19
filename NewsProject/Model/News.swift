//
//  Model.swift
//  NewsProject
//
//  Created by Aleksandr Avdukich on 17/05/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import Foundation

class News {
    let id: String
    let title: String
    var text: String? = nil
    var count: Int? = nil
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}
