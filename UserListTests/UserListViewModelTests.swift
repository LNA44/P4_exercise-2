//
//  UserListViewModelTests.swift
//  UserListTests
//
//  Created by Ordinateur elena on 05/03/2025.
//

import XCTest
@testable import UserList

final class UserListViewModelTests: XCTestCase {
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
		let initialUsers = viewModel.users
		//When
		await viewModel.reloadUsers()
		//Then
		for user in viewModel.users {
			XCTAssertFalse(initialUsers.contains(where: { $0.id == user.id }),"Each user should be different after reload")
			// chaque élément d'initialUsers =/= chaque élément de viewModel.users
		}
		expectation.fulfill()
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
	
	func testLoadMoreDataIfNeededSuccess() async throws {
		//Given
		validResponse = true
		setupTestEnvironment()
		let expectation = XCTestExpectation(description: "reload users after first fetch")
		let isLoading = false
		await viewModel.fetchUsers() //2 users
		let shouldLoadMoreData = viewModel.shouldLoadMoreData(currentItem: viewModel.users[1])
		//When
		await viewModel.loadMoreDataIfNeeded(currentItem: viewModel.users[1]) // 2+2 users
		//Then
		XCTAssertEqual(viewModel.users.count,4)
		XCTAssertTrue(shouldLoadMoreData)
		XCTAssertFalse(isLoading)
		expectation.fulfill()
		await fulfillment(of: [expectation], timeout: 10)
	}
}
