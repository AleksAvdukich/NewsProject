//
//  EditProfileTableViewController.swift
//  NewsProject
//
//  Created by Aleksandr Avdukich on 17/05/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController {
    
    
    // MARK: Private Data Structures
    
    private enum CellTitle {
        static let name = "Имя"
        static let city = "Родной город"
        static let email = "Email"
        static let description = "О себе"
    }
    
    private enum Strings {
        static let cellID = "cellID"
        static let cancel = "Отмена"
    }
    
    
    // MARK: Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupTableView()
    }

    
    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 4
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: EditPhotoTableViewCell.name, for: indexPath) as! EditPhotoTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.name, for: indexPath) as! InfoTableViewCell
            cell.accessoryType = .disclosureIndicator
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Strings.cellID, for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 275
        default:
            return 66
        }
    }
    
    
    // MARK: Private
    
    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Strings.cancel, style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        
        tableView.register(InfoTableViewCell.nib, forCellReuseIdentifier: InfoTableViewCell.name)
        tableView.register(EditPhotoTableViewCell.nib, forCellReuseIdentifier: EditPhotoTableViewCell.name)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Strings.cellID)
    }
}
