//
//  GitUserDetailUiMapperImplTests.swift
//  DomainTests
//
//  Created by Long Do on 02/01/2025.
//

@testable import Domain
@testable import GitUser
import XCTest

final class GitUserDetailUiMapperImplTests: XCTestCase {

    private var uiMapper: GitUserDetailUiMapperImpl!

    // Test data setup
    private var oldUiModel: GitUserDetailUiModel!
    private var gitUserDetailModel: GitUserDetailModel!

    override func setUp() {
        super.setUp()
        uiMapper = GitUserDetailUiMapperImpl()

        // Sample old UI model to test
        oldUiModel = GitUserDetailUiModel(
            login: "user1",
            name: "Old Name",
            avatarUrl: "http://old-avatar.url",
            blog: "http://old-blog.url",
            location: "Old Location",
            followers: "50",
            following: "25"
        )

        // Sample Git user detail model to map to UI model
        gitUserDetailModel = GitUserDetailModel(
            id: 1,
            login: "user1",
            name: "New Name",
            avatarUrl: "http://new-avatar.url",
            blog: "http://new-blog.url",
            location: "New Location",
            followers: 120,
            following: 60
        )
    }

    override func tearDown() {
        uiMapper = nil
        oldUiModel = nil
        gitUserDetailModel = nil
        super.tearDown()
    }

    func testMapToUiModel_shouldMapValuesCorrectly() {
        // Act
        let uiModel = uiMapper.mapToUiModel(oldUiModel: oldUiModel, model: gitUserDetailModel)

        // Assert
        XCTAssertEqual(uiModel.name, "New Name", "The name should be updated to the new name.")
        XCTAssertEqual(
            uiModel.avatarUrl,
            "http://new-avatar.url",
            "The avatar URL should be updated to the new avatar URL."
        )
        XCTAssertEqual(uiModel.blog, "http://new-blog.url", "The blog URL should be updated to the new blog URL.")
        XCTAssertEqual(uiModel.location, "New Location", "The location should be updated to the new location.")
        XCTAssertEqual(uiModel.followers, "100+", "The followers should be formatted correctly as '100+'.")
        XCTAssertEqual(uiModel.following, "60", "The following count should be formatted correctly.")
    }

    func testMapToUiModel_whenNameIsNil_shouldUseLoginAsName() {
        // Arrange: GitUserDetailModel with nil name
        gitUserDetailModel.name = nil

        // Act
        let uiModel = uiMapper.mapToUiModel(oldUiModel: oldUiModel, model: gitUserDetailModel)

        // Assert
        XCTAssertEqual(uiModel.name, "user1", "The name should fallback to the login value when name is nil.")
    }

    func testMapToUiModel_whenLocationIsNil_shouldUseDefaultNotSet() {
        // Arrange: GitUserDetailModel with nil location
        gitUserDetailModel.location = nil

        // Act
        let uiModel = uiMapper.mapToUiModel(oldUiModel: oldUiModel, model: gitUserDetailModel)

        // Assert
        XCTAssertEqual(
            uiModel.location,
            R.string.localizable.not_set(),
            "The location should fallback to the 'not set' string when location is nil."
        )
    }

    func testMapToUiModel_shouldFormatFollowersAndFollowingCorrectly() {
        // Arrange: GitUserDetailModel with followers and following values
        gitUserDetailModel.followers = 120
        gitUserDetailModel.following = 60

        // Act
        let uiModel = uiMapper.mapToUiModel(oldUiModel: oldUiModel, model: gitUserDetailModel)

        // Assert: Check the formatted followers value
        XCTAssertEqual(
            uiModel.followers,
            "100+",
            "The followers should be formatted to '100+' as it exceeds the max value of 100."
        )

        // Assert: Check the formatted following value
        XCTAssertEqual(uiModel.following, "60", "The following count should be correctly formatted.")
    }
}
