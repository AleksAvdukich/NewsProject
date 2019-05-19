//
//  ProfileTableViewController.swift
//  NewsProject
//
//  Created by Aleksandr Avdukich on 17/05/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController, EditProfileButtonDelegate {
    
    
    // MARK: Private Data Structures
    
    private enum SectionTitle {
        static let city = "Родной город"
        static let description = "О себе"
    }
    
    private enum Strings {
        static let cellID = "cellID"
    }
    
    
    // MARK: Private Properties
    
    private let profileService = ProfileServiceAssembly()
    private var profilePhotoEditButtonCell: ProfilePhotoEditButtonTableViewCell?
    
    
    // MARK: Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        profilePhotoEditButtonCell?.delegate = nil
    }
    
    deinit {
        print("ProfileTableViewController \(#function)")
    }

    
    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return SectionTitle.city
        case 2:
            return SectionTitle.description
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfilePhotoEditButtonTableViewCell.name, for: indexPath) as! ProfilePhotoEditButtonTableViewCell
            if profilePhotoEditButtonCell == nil {
                cell.delegate = self
                profilePhotoEditButtonCell = cell
            }
            return cell
        case 1:
            return setupProfileCell(with: "", indexPath: indexPath)
        case 2:
            return setupProfileCell(with: "", indexPath: indexPath)
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Strings.cellID, for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 142
        default:
            return 44
        }
    }
    
    
    // MARK: Private
    
    private func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = TitleConstants.profile
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.register(ProfilePhotoEditButtonTableViewCell.nib, forCellReuseIdentifier: ProfilePhotoEditButtonTableViewCell.name)
        tableView.register(ProfileTableViewCell.nib, forCellReuseIdentifier: ProfileTableViewCell.name)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Strings.cellID)
    }
    
    @discardableResult
    private func setupProfileCell(with text: String, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.name, for: indexPath) as! ProfileTableViewCell
        return cell
    }
    
    
    // MARK: EditProfileButtonDelegate
    
    func displayEditProfileController(sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { [weak self] (_) in
            UIView.animate(withDuration: 0.1, animations: {
                sender.transform = CGAffineTransform.identity
            }, completion: { [weak self] (_) in
                guard let self = self else { return }
                
                let editProfileController = self.profileService.editProfileController
                let navigationController = UINavigationController(rootViewController: editProfileController)
                
                self.present(navigationController, animated: true, completion: nil)
            })
        }
    }
}
