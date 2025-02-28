//
//  DataMock.swift
//  UserList
//
//  Created by Ordinateur elena on 27/02/2025.
//
import Foundation
@testable import UserList

class DataMock {
	// MARK: - Properties
	let mockUser1: UserListResponse.User
	let mockUser2: UserListResponse.User
	let userListResponseMock: UserListResponse
	
	// MARK: - Init
	
	init() {
		mockUser1 = UserListResponse.User(
			name: UserListResponse.User.Name(title: "mr", first: "john", last: "doe"),
			dob: UserListResponse.User.Dob(date: "1990-02-12", age: 19),
			picture: UserListResponse.User.Picture(
				large: "https://randomuser.me/api/portraits/men/83.jpg",
				medium: "https://randomuser.me/api/portraits/med/men/85.jpg",
				thumbnail: "https://randomuser.me/api/portraits/thumb/men/86.jpg"
			)
		)
		mockUser2 = UserListResponse.User(
			name: UserListResponse.User.Name(title: "mr", first: "joe", last: "smith"),
			dob: UserListResponse.User.Dob(date: "1990-02-13", age: 20),
			picture: UserListResponse.User.Picture(
				large: "https://randomuser.me/api/portraits/men/90.jpg",
				medium: "https://randomuser.me/api/portraits/med/men/91.jpg",
				thumbnail: "https://randomuser.me/api/portraits/thumb/men/92.jpg"
			)
		)
		userListResponseMock = UserListResponse(results: [mockUser1, mockUser2])
	}
	
	// MARK: - Methods
	
	private func encodeData() throws -> Data {
		return try JSONEncoder().encode(userListResponseMock)
	}
	
	func validMockResponse(request: URLRequest) async throws -> (Data, URLResponse) { //mock de executeDataRequest
		let data = try encodeData()
		let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
		return (data, response)
	}
	
	// TODO: Méthode invalidMockResponse
	func invalidMockResponse(request: URLRequest) async throws -> (Data, URLResponse) {
		let data = try encodeData()
		let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
		return (data, response)
	}
}

