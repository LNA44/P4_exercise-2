//
//  ViewModel.swift
//  UserList
//
//  Created by Ordinateur elena on 31/01/2025.
//

import SwiftUI

class ViewModel: ObservableObject {
	
	// MARK: - Private properties
	private let repository : UserListRepository
	// MARK: - Public properties
	
	// MARK: - Init
	init(repository: UserListRepository) { //repository est une instance de UserListRepository
		self.repository = repository //crée le lien entre le repository et le viewmodel
	}
	// MARK: - Outputs

	@Published var users: [User] = []
	@Published var isLoading = false
	@Published var isGridView = false
	
	func shouldLoadMoreData(currentItem item: User) -> Bool {
			guard let lastItem = users.last else { return false }
			return !isLoading && item.id == lastItem.id
	}
	
	// MARK: - Inputs

	func fetchUsers() { //charge les utilisateurs
		self.isLoading = true
		Task { //asynchrone : ne bloque pas la fluidité de l'interface utilisateur
			do {
				let users = try await repository.fetchUsers(quantity: 20)
				self.users.append(contentsOf: users)
				isLoading = false
			} catch {
				print("Error fetching users: \(error.localizedDescription)")
			}
		}
	}

	func reloadUsers() {
		users.removeAll()
		fetchUsers()
	}
	
	

}

//#Preview {
//    ViewModel()
//}

