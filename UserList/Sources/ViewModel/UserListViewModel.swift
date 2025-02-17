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
	init(repository: UserListRepository) { //repository est une instance de UserListRepository
		self.repository = repository //crée le lien entre le repository et le viewmodel
	}
	// MARK: - Outputs
 //propriétés suivies dans la view, qui se met à jour à chaque modif
	@Published var users: [User] = []
	@Published var isLoading = false
	@Published var isGridView = false
	
	func shouldLoadMoreData(currentItem item: User) -> Bool {
			guard let lastItem = users.last else { return false }
			return !isLoading && item.id == lastItem.id
	}
	
	// MARK: - Inputs
// lien entre repository et view
	func fetchUsers() { //charge les utilisateurs
		isLoading = true
		Task {[weak self] in
			guard let self = self else { return } //asynchrone : ne bloque pas la fluidité de l'interface utilisateur
			do {
				let users = try await repository.fetchUsers(quantity: 20)
				await MainActor.run {
					self.users.append(contentsOf: users)
					self.isLoading = false
				}
			} catch {
				await MainActor.run {
					self.isLoading = false
				}
				print("Error fetching users: \(error.localizedDescription)")
			}
		}
}

	func reloadUsers() {
		users.removeAll()
		fetchUsers()
	}
	
	func loadMoreDataIfNeeded(currentItem: User) {
		if shouldLoadMoreData(currentItem: currentItem) && !isLoading {
	  fetchUsers()
  }
}
	

}

//#Preview {
//    ViewModel()
//}

