import XCTest
@testable import UserList
//tests et mocks dans même fichier

final class UserListRepositoryTests: XCTestCase {
	// Happy path test case
	func testFetchUsersSuccess() async throws {
		// Given
		let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
		let quantity = 2
		
		// When
		let users = try await repository.fetchUsers(quantity: quantity)
		
		// Then
		XCTAssertEqual(users.count, quantity)
		XCTAssertEqual(users[0].name.first, "John")
		XCTAssertEqual(users[0].name.last, "Doe")
		XCTAssertEqual(users[0].dob.age, 31)
		XCTAssertEqual(users[0].picture.large, "https://example.com/large.jpg")
		
		XCTAssertEqual(users[1].name.first, "Jane")
		XCTAssertEqual(users[1].name.last, "Smith")
		XCTAssertEqual(users[1].dob.age, 26)
		XCTAssertEqual(users[1].picture.medium, "https://example.com/medium.jpg")
	}
	
	//Happy path test case
	func testShouldLoadMoreDataSuccess() async throws {
		//Given
		let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
		let viewModel = UserListViewModel(repository:repository) // car shouldLoadMoreData est dans le viewmodel
		// Récupérer les utilisateurs avec la fonction fetchUsers
		let users = try await repository.fetchUsers(quantity: 2)
		// Injecter les utilisateurs dans viewModel.users
		viewModel.users = users
		// Définir isLoading à false
		viewModel.isLoading = false
		// Créer l'élément courant (currentItem) que nous voulons tester
		let currentItem = users.last! // On prend le dernier utilisateur de la liste
			
		// When
		let shouldLoadMoreData = viewModel.shouldLoadMoreData(currentItem: currentItem)
		
		//Then
		XCTAssertTrue(shouldLoadMoreData)
	}
	
	
	//Happy path test case
	func testReloadUsersSuccess() async throws {
		//Given
		let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
		let viewModel = UserListViewModel(repository:repository)
		let initialUsers = try await repository.fetchUsers(quantity: 2)
		viewModel.users = initialUsers
		
		//When
		viewModel.reloadUsers()
		
		//Then
		for user in viewModel.users {
			XCTAssertTrue(initialUsers.contains(where: { $0.id != user.id }), "Each user should be different after reload")
		}
	}

	// Unhappy path test case: Invalid JSON response
	func testFetchUsersInvalidJSONResponse() async throws {
		// Given
		let invalidJSONData = "invalid JSON".data(using: .utf8)!
		let invalidJSONResponse = HTTPURLResponse(
			url: URL(string: "https://example.com")!,
			statusCode: 200,
			httpVersion: nil,
			headerFields: nil
		)!
		
		let mockExecuteDataRequest: (URLRequest) async throws -> (Data, URLResponse) = { _ in
			return (invalidJSONData, invalidJSONResponse)
		}
		
		let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
		
		// When
		do {
			_ = try await repository.fetchUsers(quantity: 2)
			XCTFail("Response should fail")
		} catch {
			// Then
			XCTAssertTrue(error is DecodingError)
		}
	}
	
	//Unhappy path test case: Empty JSON array
	func testFetchUsersEmptyJSONResponse() async throws {
		let repository = UserListRepository(executeDataRequest: mockExecuteDataRequestEmptyJSON)
		let quantity = 2

		// When
		let users = try await repository.fetchUsers(quantity: quantity)
		
		//Then
		XCTAssertTrue(users.isEmpty, "The users list should be empty for an empty JSON response")
		
	}
	
	//Unhappy path test : case empty users
	func testShouldLoadMoreDataResponse() async throws {
		//Given
		let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
		let viewModel = UserListViewModel(repository:repository) // car shouldLoadMoreData est dans le viewmodel
		let users = try await repository.fetchUsers(quantity: 0)
		// Injecter les utilisateurs dans viewModel.users
		viewModel.users = users
		// Définir isLoading à false
		viewModel.isLoading = false
		// Créer l'élément courant (currentItem) que nous voulons tester
		let currentItem = User(user: mockUserResponse()) // On crée un utilisateur fictif que l'on suppose être le dernier de la liste
				
		// When
		let shouldLoadMoreData = viewModel.shouldLoadMoreData(currentItem: currentItem)
			
		//Then
		XCTAssertFalse(shouldLoadMoreData, "with an empty list, shouldLoadMoreData should return false")
	}
	
	
}

private extension UserListRepositoryTests {
    // Define a mock for executeDataRequest that returns predefined data
    func mockExecuteDataRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        // Create mock data with a sample JSON response
        let sampleJSON = """
            {
                "results": [
                    {
                        "name": {
                            "title": "Mr",
                            "first": "John",
                            "last": "Doe"
                        },
                        "dob": {
                            "date": "1990-01-01",
                            "age": 31
                        },
                        "picture": {
                            "large": "https://example.com/large.jpg",
                            "medium": "https://example.com/medium.jpg",
                            "thumbnail": "https://example.com/thumbnail.jpg"
                        }
                    },
                    {
                        "name": {
                            "title": "Ms",
                            "first": "Jane",
                            "last": "Smith"
                        },
                        "dob": {
                            "date": "1995-02-15",
                            "age": 26
                        },
                        "picture": {
                            "large": "https://example.com/large.jpg",
                            "medium": "https://example.com/medium.jpg",
                            "thumbnail": "https://example.com/thumbnail.jpg"
                        }
                    }
                ]
            }
        """
        
        let data = sampleJSON.data(using: .utf8)!
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (data, response)
    }
	
	func mockExecuteDataRequestEmptyJSON(_ request:URLRequest) async throws -> (Data, URLResponse) {
		let emptyJSON = """
		{
		"results" : []
		}
		"""
		let data = emptyJSON.data(using: .utf8)! //encodage en JSON
		let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
		return (data, response)
	}
	
	func mockUserResponse() -> UserListResponse.User {
		return UserListResponse.User(
				   name: UserListResponse.User.Name(title: "Mr", first: "Test", last: "User"),
				   dob: UserListResponse.User.Dob(date: "1990-01-01", age: 30),
				   picture: UserListResponse.User.Picture(large: "large.jpg", medium: "medium.jpg", thumbnail: "thumbnail.jpg")
			   )
	}
}
