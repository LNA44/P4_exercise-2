import XCTest
@testable import UserList
//tests et mocks dans même fichier

final class UserListRepositoryTests: XCTestCase {
	var viewModel: UserListViewModel!
	var dataMock = DataMock()
	var repository: UserListRepository!
	var validResponse = false
	
	/*override func setUp(){ //avant chaque test de la classe
		super.setUp()
		if validResponse == true {
			print("Valid response is being set")
			repository = UserListRepository(executeDataRequest: dataMock.validMockResponse)
			viewModel = UserListViewModel(repository: repository)
		} else {
			repository = UserListRepository(executeDataRequest: dataMock.invalidMockResponse)
			viewModel = UserListViewModel(repository: repository)
		}
		
		// TODO: Trouver une solution pour ne pas forcer à avoir tjrs réponse valide
	}
	*/
	//permet d'être appelée après la déclaration de variables dans les tests
	private func setupTestEnvironment() {
			if validResponse {
				print("Valid response is being set")
				repository = UserListRepository(executeDataRequest: dataMock.validMockResponse)
			} else {
				repository = UserListRepository(executeDataRequest: dataMock.invalidMockResponse)
			}
			viewModel = UserListViewModel(repository: repository)
		}
	
	override func tearDown() { // après chaque test
		viewModel = nil
		repository = nil
		validResponse = false
		super.tearDown()
		
	}
	
	func testFetchUsersSuccess() async throws { //old
		validResponse = true
		setupTestEnvironment()
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
	
	// CAS : EMPTY DATA ET STATUSCODE 500?
	func testFetchUsersFailIncorrectResponse() async throws { //old
		// Given
		validResponse = false
		setupTestEnvironment()
		let quantity = 2
		// When
		let users = try await repository.fetchUsers(quantity: quantity)
		// Then
		XCTAssertTrue(users.isEmpty, "users array should be empty")
	}
	
	func testUserShouldLoadMoreData() async throws { //VALIDE
		validResponse = true
		setupTestEnvironment()
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
	// CAS : CURRENTITEM IS NOT LAST
	func testShouldNotLoadMoreData() async throws { //VALIDE
		validResponse = true
		setupTestEnvironment()
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
	
	//ERREUR AVEC TASK: POURQUOI?
	func testReloadUsersSuccess() async throws { //new
		//Given
		validResponse = true
		setupTestEnvironment()
		let expectation = XCTestExpectation(description: "reload users after first fetch")
		//Task {
		await viewModel.fetchUsers() //récupération de users = mock:UserListResponse -> repo.fetchUsers:[User] -> viewModel.fetchUsers:let users=repo.fetchUsers
		//problème d'attente de récup
		let initialUsers = viewModel.users
		//When
		await viewModel.reloadUsers()
		//Then
		for user in viewModel.users {
			XCTAssertFalse(initialUsers.contains(where: { $0.id == user.id }),"Each user should be different after reload")
			// chaque élément d'initialUsers =/= chaque élément de viewModel.users
			expectation.fulfill()
		}
		await fulfillment(of: [expectation], timeout: 10)
		//}
	}
	// BON CAS? ET BONNES VERIF?
	func testReloadUsersFail() async throws { //new
		//Given
		validResponse = false
		setupTestEnvironment()
		let expectation = XCTestExpectation(description: "reload users after first fetch")
		//Task {
		await viewModel.fetchUsers() //récupération de users = mock:UserListResponse -> repo.fetchUsers:[User] -> viewModel.fetchUsers:let users=repo.fetchUsers
		//problème d'attente de récup
		let initialUsers = viewModel.users
		//When
		await viewModel.reloadUsers()
		//Then
		XCTAssertTrue(initialUsers.isEmpty)
			XCTAssertTrue(viewModel.users.isEmpty)
			expectation.fulfill()
		await fulfillment(of: [expectation], timeout: 10)
		//}
		
	}
}
