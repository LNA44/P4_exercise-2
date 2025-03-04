import Foundation
//réponse d'une API contenant plusieurs objets utilisateurs
//correspond à la réponse de l'API après parsing
struct UserListResponse: Codable { //l'objet UserListResponse contient tous les utilisateurs
	let results: [User]

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
