//
//  NetworkAPITests.swift
//

@testable import Data
import OHHTTPStubs
import XCTest

final class NetworkAPITests: XCTestCase {

    private var networkAPI: NetworkAPI!
    private var requestConfiguration: DummyRequestConfiguration!

    override func setUpWithError() throws {
        try super.setUpWithError()
        requestConfiguration = DummyRequestConfiguration()
        networkAPI = NetworkAPI()
    }

    override func tearDownWithError() throws {
        NetworkStubber.removeAllStubs()
        networkAPI = nil
        requestConfiguration = nil
        try super.tearDownWithError()
    }

    func testPerformRequest_whenNetworkReturnsValue_shouldReturnExpectedMessage() async throws {
        // Arrange
        NetworkStubber.stub(requestConfiguration)

        // Act
        let response = try await networkAPI.performRequest(
            requestConfiguration,
            for: DummyNetworkModel.self
        )

        // Assert
        XCTAssertEqual(response.message, "Hello", "The response message should be 'Hello'")
    }

    func testPerformRequest_whenNetworkReturnsError_shouldThrowError() async throws {
        // Arrange
        NetworkStubber.stub(requestConfiguration, data: Data(), statusCode: 400)

        // Act & Assert
        do {
            _ = try await networkAPI.performRequest(
                requestConfiguration,
                for: DummyNetworkModel.self
            )
            XCTFail("Expected an error, but no error was thrown.")
        } catch {
            XCTAssertNotNil(error, "An error should be thrown when the network returns an error response.")
        }
    }
}
