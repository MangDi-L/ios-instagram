//
//  SearchController.swift
//  Instagram
//
//  Created by mangdi on 5/25/24.
//

import UIKit

final class SearchController: UITableViewController {
    
    // MARK: - Properties
    private let reuseIdentifier = "UserCell"
    private var users: [User] = []
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        fetchUsers()
    }
    
    // MARK: - API
    
    private func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func configureTableView() {
        view.backgroundColor = .systemBackground
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
    }
}

// MARK: - UITableViewDataSource

extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? UserCell ?? UserCell()
        cell.user = users[indexPath.row]
        return cell
    }
}
