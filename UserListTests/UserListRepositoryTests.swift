import XCTest
@testable import UserList
//tests et mocks dans même fichier

final class UserListRepositoryTests: XCTestCase {
	var viewModel: UserListViewModel!
	let dataMock = DataMock()
	var repository = UserListRepository()
	var validResponse = false
	
	override func setUp(){ //avant chaque test de la classe
		super.setUp()
		if validResponse == true {
			repository = UserListRepository(executeDataRequest: dataMock.validMockResponse)
			viewModel = UserListViewModel(repository: repository)
		} else {
			repository = UserListRepository(executeDataRequest: dataMock.invalidMockResponse)
			viewModel = UserListViewModel(repository: repository)
		}
		
		// TODO: Trouver une solution pour ne pas forcer à avoir tjrs réponse valide
	}
	
	override func tearDown() { // après chaque test 
		viewModel = nil
		super.tearDown()
		
	}
	
	func testFetchUsersSuccess() async throws { //old
		// Given
		validResponse = true
		let quantity = 2
		// When
		let users = try await repository.fetchUsers(quantity: quantity)
		
		// Then
		XCTAssertEqual(users.count, quantity)
		XCTAssertEqual(users[0].name.first, "john")
		XCTAssertEqual(users[0].name.last, "doe")
		XCTAssertEqual(users[0].dob.age, 19)
		XCTAssertEqual(users[0].picture.large, "https://randomuser.me/api/portraits/men/83.jpg")
		
		XCTAssertEqual(users[1].name.first, "joe")
		XCTAssertEqual(users[1].name.last, "smith")
		XCTAssertEqual(users[1].dob.age, 20)
		XCTAssertEqual(users[1].picture.medium, "https://randomuser.me/api/portraits/med/men/91.jpg")
	}
		
	func testUserShouldLoadMoreData() async throws { //VALIDE
		validResponse = true
		let expectation = XCTestExpectation(description: "fetch last user")
		
		Task {
			await viewModel.fetchUsers() //récupération de users = mock:UserListResponse -> repo.fetchUsers:[User] -> viewModel.fetchUsers:let users=repo.fetchUsers
			
			let currentItem = viewModel.users.last!
			let shouldLoadMoreData = viewModel.shouldLoadMoreData(currentItem: currentItem)
			
			XCTAssertTrue(shouldLoadMoreData)
			expectation.fulfill()
		}
		await fulfillment(of: [expectation], timeout: 10)
	}
	
	func testShouldNotLoadMoreData() async throws { //VALIDE
		validResponse = false
		let expectation = XCTestExpectation(description: "fetchLastUser")
		
		Task {
			await viewModel.fetchUsers()
			
			let currentItem = viewModel.users.first!
			let shouldLoadMoreData = viewModel.shouldLoadMoreData(currentItem: currentItem)
			
			XCTAssertFalse(shouldLoadMoreData)
			expectation.fulfill()
		}
		await fulfillment(of: [expectation], timeout: 10)
	}
	//ERREUR
	func testReloadUsersSuccess() async throws { //new
		//Given
		validResponse = true
		let expectation = XCTestExpectation(description: "reload users after first fetch")
		Task {
			await viewModel.fetchUsers() //récupération de users = mock:UserListResponse -> repo.fetchUsers:[User] -> viewModel.fetchUsers:let users=repo.fetchUsers
			//XCTAssertNotNil(viewModel.users)
			let initialUsers = viewModel.users
			//XCTAssertEqual(initialUsers, viewModel.users)
			//When
			await viewModel.reloadUsers()
			//XCTAssertNotEqual(viewModel.users, initialUsers)
			//Then
			for user in viewModel.users {
				XCTAssertFalse(initialUsers.contains(where: { $0.id == user.id }),"Each user should be different after reload")
				// chaque élément d'initialUsers =/= chaque élément de viewModel.users
				expectation.fulfill()
			}
			await fulfillment(of: [expectation], timeout: 10)
		}
	}
		
	func testReloadUsersFail() async throws { //new
		
		
	}
		
	/*func testReloadUsersSuccess() async throws { //new
		//Given
		let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
		let viewModel = UserListViewModel(repository:repository)
		let initialUsers = try await repository.fetchUsers(quantity: 2)
		viewModel.users = initialUsers
		
		//When
		await viewModel.reloadUsers()
		
		//Then
		for user in viewModel.users {
			XCTAssertFalse(initialUsers.contains(where: { $0.id == user.id }),"Each user should be different after reload")
			// chaque élément d'initialUsers =/= chaque élément de viewModel.users
		}
	}
	
	//case: Empty JSON array
	func testFetchUsersSuccessEmptyJSONResponse() async throws { //new
		let repository = UserListRepository(executeDataRequest: mockExecuteDataRequestEmptyJSON)
		let quantity = 2

		// When
		let users = try await repository.fetchUsers(quantity: quantity)
		
		//Then
		XCTAssertTrue(users.isEmpty, "The users list should be empty for an empty JSON response")
		
	}
	
	func testShouldLoadMoreDataFailCurrentItemIsNotLast() async throws { //new
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
		let currentItem = viewModel.users[0] // On prend le 1er utilisateur de la liste
		// When
		let shouldLoadMoreData = viewModel.shouldLoadMoreData(currentItem: currentItem)
		
		//Then
		XCTAssertFalse(shouldLoadMoreData)
	}
	
	func testShouldLoadMoreDataFailisLoadingTrue() async throws { //new
		//Given
		let repository = UserListRepository(executeDataRequest: mockExecuteDataRequest)
		let viewModel = UserListViewModel(repository:repository) // car shouldLoadMoreData est dans le viewmodel
		// Récupérer les utilisateurs avec la fonction fetchUsers
		let users = try await repository.fetchUsers(quantity: 2)
		// Injecter les utilisateurs dans viewModel.users
		viewModel.users = users
		// Définir isLoading à true
		viewModel.isLoading = true
		// Créer l'élément courant (currentItem) que nous voulons tester
		let currentItem = users.last! // On prend le dernier utilisateur de la liste
		// When
		let shouldLoadMoreData = viewModel.shouldLoadMoreData(currentItem: currentItem)
		
		//Then
		XCTAssertFalse(shouldLoadMoreData)
	}
	
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
	
	func testShouldLoadMoreDataFalseFetchUsersQuantityZero() async throws { //new
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
   // func mockExecuteDataRequest(_ request: URLRequest) async throws -> (Data, URLResponse) { //old
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

	func mockExecuteDataRequestEmptyJSON(_ request:URLRequest) async throws -> (Data, URLResponse) { //new
		let emptyJSON = """
		{
		"results" : []
		}
		"""
		let data = emptyJSON.data(using: .utf8)! //encodage en JSON
		let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
		return (data, response)
	}
	
	func mockUserResponse() -> UserListResponse.User { //new
		return UserListResponse.User(
				   name: UserListResponse.User.Name(title: "Mr", first: "Test", last: "User"),
				   dob: UserListResponse.User.Dob(date: "1990-01-01", age: 30),
				   picture: UserListResponse.User.Picture(large: "large.jpg", medium: "medium.jpg", thumbnail: "thumbnail.jpg")
			   )
	}
	 */
}
