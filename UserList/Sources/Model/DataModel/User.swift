import Foundation
//model
struct User: Identifiable, Hashable {
	var id = UUID()
	let name: Name
	let dob: Dob
	let picture: Picture

	// MARK: - Init
	init(user: UserListResponse.User) { 
		self.name = .init(title: user.name.title, first: user.name.first, last: user.name.last)//crée un objet Name
		self.dob = .init(date: user.dob.date, age: user.dob.age)
		self.picture = .init(large: user.picture.large, medium: user.picture.medium, thumbnail: user.picture.thumbnail)
	}
	// MARK: - Dob
	struct Dob: Codable, Hashable {
		let date: String
		let age: Int
	}

	// MARK: - Name
	struct Name: Codable, Hashable {
		let title, first, last: String
	}

	// MARK: - Picture
	struct Picture: Codable, Hashable {
		let large, medium, thumbnail: String
	}
}
