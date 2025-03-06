import Foundation
//logique de récup des données depuis une API

protocol UserListRepositoryType {
	func fetchUsers(quantity: Int) async throws -> [User]
}

struct UserListRepository {
	
	private let executeDataRequest: (URLRequest) async throws -> (Data, URLResponse) //requête asynchrone retournant des données et une réponse
	
	init( //permet de garder la propriété executeDataRequest privée + de pouvoir modifier sa valeur avec celle du mock pour tests
		executeDataRequest: @escaping (URLRequest) async throws -> (Data, URLResponse) = URLSession.shared.data(for:) //appel reseau et récupère des datas et une réponse
	) { //data(for:) gère la tache et n'utilise pas resume() donc pas besoin de le mocker
		self.executeDataRequest = executeDataRequest
	}
	
	func fetchUsers(quantity: Int) async throws -> [User] {
		guard let url = URL(string: "https://randomuser.me/api/") else {
			throw URLError(.badURL)
		}
		
		let request = try URLRequest(
			url: url,
			method: .GET,
			parameters: [
				"results": quantity
			]
		)
		
		let (data, _) = try await executeDataRequest(request) //exécute la requête réseau et récupère les données, URLResponse ignorée
		
		let response = try JSONDecoder().decode(UserListResponse.self, from: data) //décode les données reçues en un objet UserListResponse
		
		return response.results.map(User.init) //retourne tableau User en utilisant response
	}
}
