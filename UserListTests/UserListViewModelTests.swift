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
	
	func testUserShouldLoadMoreData() async {
		//Given
		await viewModel.fetchUsers() // création d'un tableau comprenant plusieurs User
		let currentItem = viewModel.users.last!
		//When
		let shouldLoadMoreData = viewModel.shouldLoadMoreData(currentItem: currentItem)
		//Then
		XCTAssertTrue(shouldLoadMoreData)
	}
	
	func testShouldNotLoadMoreData() async {
		//Given
		await viewModel.fetchUsers()
		let currentItem = viewModel.users.first!
		//When
		let shouldLoadMoreData = viewModel.shouldLoadMoreData(currentItem: currentItem)
		//Then
		XCTAssertFalse(shouldLoadMoreData)
	}
	
	func testReloadUsersSuccess() async { 
		//Given
		await viewModel.fetchUsers()
		let initialUsers = viewModel.users
		//When
		await viewModel.reloadUsers()
		//Then
		for user in viewModel.users {
			XCTAssertFalse(initialUsers.contains(where: { $0.id == user.id }),"Each user should be different after reload")
		}
	}
	
	func testReloadUsersFail() async {
		//Given
		dataMock.validResponse = false
		await viewModel.fetchUsers()
		let initialUsers = viewModel.users
		//When
		await viewModel.reloadUsers()
		//Then
		XCTAssertTrue(initialUsers.isEmpty)
		XCTAssertTrue(viewModel.users.isEmpty)
		XCTAssertNotNil(viewModel.networkError)
	}
	
	func testLoadMoreDataIfNeededSuccess() async {
		//Given
		await viewModel.fetchUsers() //2 users
		let shouldLoadMoreData = viewModel.shouldLoadMoreData(currentItem: viewModel.users[1])
		//When
		await viewModel.loadMoreDataIfNeeded(currentItem: viewModel.users[1]) // 2+2 users
		//Then
		XCTAssertEqual(viewModel.users.count,4)
		XCTAssertTrue(shouldLoadMoreData)
	}
	
	func testUserListIsEmptyWhenFetchUserErrorOccurs() async {
		//Given
		dataMock.validResponse = false
		//When
		await viewModel.fetchUsers()
		//Then
		XCTAssertTrue(viewModel.users.isEmpty)
		XCTAssertFalse(viewModel.isLoading)
		XCTAssertNotNil(viewModel.networkError)
	}
}
