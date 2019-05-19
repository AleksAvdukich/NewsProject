//
//  ProfilePhotoAndNameTableViewCell.swift
//  Chat
//
//  Created by Timur Saidov on 18/03/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class ProfilePhotoEditButtonTableViewCell: UITableViewCell, NibLoadable {
    
    
    // MARK: Public Properties
    
    var delegate: EditProfileButtonDelegate?
    
    
    // MARK: Outlets

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    
    // MARL: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }
    
    
    // MARK: Private
    
    private func setupCell() {
        backgroundColor = .clear
        
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 45
        photoImageView.layer.borderWidth = 1
        photoImageView.layer.borderColor = UIColor.white.cgColor
        
        editButton.clipsToBounds = true
        editButton.layer.cornerRadius = 18
        editButton.backgroundColor = .black
        editButton.setTitleColor(.white, for: .normal)
//        editButton.isEnabled = false
        editButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
    }
    
    @objc private func handleEdit() {
        delegate?.displayEditProfileController(sender: editButton)
    }
}
