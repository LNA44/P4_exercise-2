import XCTest
@testable import UserList

final class UserListRepositoryTests: XCTestCase {
	var viewModel: UserListViewModel!
	var dataMock = DataMock()
	var repository: UserListRepository!
	
	override func setUp(){ 
		super.setUp()
		dataMock.validResponse = true
		repository = UserListRepository(executeDataRequest: dataMock.executeRequest)
		viewModel = UserListViewModel(repository: repository)
	}
	
	
	override func tearDown() {
		viewModel = nil
		repository = nil
		super.tearDown()
	}
	
	func testFetchUsersSuccess() async throws {
		// Given
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
	
	func testFetchUsersFailIncorrectResponse() async throws {
		// Given
		dataMock.validResponse = false
		let quantity = 2
		// When
		do {
			_ = try await repository.fetchUsers(quantity: quantity)
		} catch {
			//Then
			XCTAssertTrue(error is DecodingError)
		}
	}
}
