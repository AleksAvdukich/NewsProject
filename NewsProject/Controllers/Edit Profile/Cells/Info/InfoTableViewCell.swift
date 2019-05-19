//
//  InfoTableViewCell.swift
//  Chat
//
//  Created by Aleksandr Avdukich on 17/05/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell, NibLoadable {
    
    
    // MARK: Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userTextLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
}
