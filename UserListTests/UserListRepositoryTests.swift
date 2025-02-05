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
		let isLoading = false
		let users = try await repository.fetchUsers(quantity:2)
		let lastItem = users.last
		
		//When
		let currentItem = users[1] //denrnier item
		let shouldLoadMoreData = !isLoading && currentItem.id == lastItem?.id
		
		//Then
		XCTAssertTrue(shouldLoadMoreData)
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
}
