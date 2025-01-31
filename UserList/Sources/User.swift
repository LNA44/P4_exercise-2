import Foundation
//représente un utilisateur individuel
struct User: Identifiable {
	var id = UUID()
	let name: Name
	let dob: Dob
	let picture: Picture

	// MARK: - Init
	init(user: UserListResponse.User) { //on ne prend qu'un utilisateur parmi le tableau
		self.name = .init(title: user.name.title, first: user.name.first, last: user.name.last)//crée un objet Name
		self.dob = .init(date: user.dob.date, age: user.dob.age)
		self.picture = .init(large: user.picture.large, medium: user.picture.medium, thumbnail: user.picture.thumbnail)
	}
//permet de créer un objet utilisateur à partir de la liste de UserListResponse
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
