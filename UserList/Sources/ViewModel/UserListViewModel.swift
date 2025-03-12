//
//  ViewModel.swift
//  UserList
//
//  Created by Ordinateur elena on 31/01/2025.
//

import SwiftUI
class UserListViewModel: ObservableObject {
	
	// MARK: - Private properties
	private let repository : UserListRepository
	// MARK: - Init
	init(repository: UserListRepository) {
		self.repository = repository
	}
	// MARK: - Outputs
	@Published var users: [User] = []
	@Published var isLoading = false
	@Published var isGridView = false
	@Published var networkError: String? = nil
	private let pageSize = 20
	
	
	internal func shouldLoadMoreData(currentItem item: User) -> Bool {
		guard let lastItem = users.last else { return false }
		return !isLoading && item.id == lastItem.id
	}
	
	// MARK: - Inputs
	@MainActor
	func fetchUsers() async {
		isLoading = true
		do {
			let users = try await repository.fetchUsers(quantity: pageSize) 
			self.users.append(contentsOf: users)
			self.isLoading = false
		} catch {
			self.isLoading = false
			self.networkError = "Error fetching users: \(error.localizedDescription)"
			print("Error fetching users: \(error.localizedDescription)")
		}
	}
	
	@MainActor
	func reloadUsers() async {
		users.removeAll()
		await fetchUsers()
	}
	
	@MainActor
	func loadMoreDataIfNeeded(currentItem: User) async {
		if shouldLoadMoreData(currentItem: currentItem) && !isLoading {
			await fetchUsers()
		}
	}
}

