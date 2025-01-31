import Foundation
//réponse d'une API contenant plusieurs objets utilisateurs
struct UserListResponse: Codable { //l'objet UserListResponse contient tous les utilisaéteurs
	let results: [User] //récupère les données sous forme de tableau d'utilisateurs

	// MARK: - User
	struct User: Codable {
		let name: Name
		let dob: Dob
		let picture: Picture

		// MARK: - Dob
		struct Dob: Codable {
			let date: String
			let age: Int
		}

		// MARK: - Name
		struct Name: Codable {
			let title, first, last: String
		}

		// MARK: - Picture
		struct Picture: Codable {
			let large, medium, thumbnail: String
		}
	}
}
