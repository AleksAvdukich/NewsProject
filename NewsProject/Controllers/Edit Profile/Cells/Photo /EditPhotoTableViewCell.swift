//
//  EditPhotoTableViewCell.swift
//  Chat
//
//  Created by Aleksandr Avdukich on 17/05/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import UIKit
import AVKit

class EditPhotoTableViewCell: UITableViewCell, NibLoadable {
    
    
    // MARK: Outlets

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }
    
    
    // MARK: Private
    
    private func setupCell() {
        backgroundColor = .clear
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 45
        profileImageView.contentMode = .scaleAspectFill
        
        cameraButton.clipsToBounds = true
        cameraButton.layer.cornerRadius = 45
        cameraButton.layer.borderWidth = 1
        cameraButton.layer.borderColor = UIColor.white.cgColor
        
//        cameraButton.addTarget(self, action: #selector(handleCamera), for: .touchUpInside)
    }
}
