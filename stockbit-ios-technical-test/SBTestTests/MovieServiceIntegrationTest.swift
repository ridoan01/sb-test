
import Foundation
import XCTest
@testable import SBTest

class MovieServiceIntegrationTest: XCTestCase {
	
	
    func testHitAPIrequestMovieList() {
//        #warning("implement this unit test")
		let serv = MockService()
		let expectation = self.expectation(description: "API Request Movielist expectation")
		
		serv.requestMovieList { result in
			switch result {
			case .success(let res):
				XCTAssertNotNil(res)
				expectation.fulfill()
			case .failure(let err):
				switch err {
				case .noInternet:
					XCTFail("No Internet")
				case .parsingFailure:
					XCTFail("Fail To Parse")
				case .dataNil:
					XCTFail("Data Nil")
				case .generalError(message: let mes):
					XCTFail(mes ?? "General Error")
				}
			}
		}
		self.waitForExpectations(timeout: 20.0, handler: nil)
		
    }
    
}

