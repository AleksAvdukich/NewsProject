//
//  LoadingTableViewCell.swift
//  NewsProject
//
//  Created by Aleksandr Avdukich on 17/05/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell, NibLoadable {

    
    // MARK: Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: Public
    
    func startLoading() {
        activityIndicator.startAnimating()
    }
}
