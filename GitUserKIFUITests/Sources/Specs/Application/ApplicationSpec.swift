//
//  ApplicationSpec.swift
//

import KIF
import XCTest

final class ApplicationTests: KIFSpec {

    override func setUp() {
        super.setUp()
        // Setup code: Navigate to the testing screen
    }

    override func tearDown() {
        // Teardown code: Navigate to neutral state
        super.tearDown()
    }

    func testGitUserScreen_whenOpens_showsUIComponents() {
        // Act: Wait for the view with the expected accessibility label
        ApplicationTests.tester().waitForView(withAccessibilityLabel: "Github Users")
    }
}
