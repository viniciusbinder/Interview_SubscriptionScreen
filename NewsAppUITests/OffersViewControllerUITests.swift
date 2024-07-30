//
//  OffersViewControllerUITests.swift
//  NewsAppUITests
//
//  Created by Vinícius on 29/07/24.
//

import XCTest

class OffersViewControllerUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("Testing")
        app.launch()

        // MARK: Navigate to OffersViewController

        let button = app.buttons["NavigateToOffersButton"]
        let spinner = app.activityIndicators["LoadingSpinner"]

        // Wait for spinner to disappear
        let exists = NSPredicate(format: "exists == false")
        expectation(for: exists, evaluatedWith: spinner, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)

        XCTAssertEqual(button.label, "Subscribe", "Button should be available")
        button.tap()
    }

    func testUIElementsExistence() throws {
        let scrollView = app.scrollViews["ScrollView"]
        let containerView = app.otherElements["ContainerView"]
        let backButton = app.buttons["BackButton"]
        let header = app.otherElements["Header"]
        let coverImage = app.images["CoverImage"]
        let titleView = app.otherElements["TitleView"]
        let selectionView = app.otherElements["SelectionView"]
        let benefitsView = app.otherElements["BenefitsView"]
        let subscribeView = app.otherElements["SubscribeView"]

        XCTAssertTrue(scrollView.exists, "The scroll view should exist")
        XCTAssertTrue(containerView.exists, "The container view should exist")
        XCTAssertTrue(backButton.exists, "The back button should exist")
        XCTAssertTrue(header.exists, "The header should exist")
        XCTAssertTrue(coverImage.exists, "The cover image should exist")
        XCTAssertTrue(titleView.exists, "The title view should exist")
        XCTAssertTrue(selectionView.exists, "The selection view should exist")
        XCTAssertTrue(benefitsView.exists, "The benefits view should exist")
        XCTAssertTrue(subscribeView.exists, "The subscribe view should exist")
    }

    func testBackButton() throws {
        let backButton = app.buttons["BackButton"]
        let previousScreen = app.otherElements["HomeViewController"]
        backButton.tap()

        XCTAssertTrue(previousScreen.exists, "The previous screen should be displayed")
    }

    func testOffer1DefaultSelection() throws {
        let subscribeButton = app.buttons["SubscribeButton"]
        subscribeButton.tap()

        let alert = app.alerts["Subscription Confirmation"]
        XCTAssertTrue(alert.exists, "The confirmation alert should be displayed")

        let alertMessage = alert.staticTexts["Buy $35.99 subscription?"]
        XCTAssertTrue(alertMessage.exists, "Alert message should be displayed")

        let confirmButton = alert.buttons["Confirm"]
        XCTAssertTrue(confirmButton.exists, "The confirm button should be present in the alert")
        let cancelButton = alert.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "The cancel button should be present in the alert")

        let previousScreen = app.otherElements["HomeViewController"]
        confirmButton.tap()
        XCTAssertFalse(alert.exists, "The alert should be dismissed after tapping cancel")
        XCTAssertTrue(previousScreen.exists, "The previous screen should be displayed")
    }

    func testOffer1SelectionAfterOffer2Selection() throws {
        // Select 2
        let offer2View = app.otherElements["Offer2View"]
        offer2View.tap()

        let subscribeButton = app.buttons["SubscribeButton"]
        subscribeButton.tap()

        let alert = app.alerts["Subscription Confirmation"]
        XCTAssertTrue(alert.exists, "The confirmation alert should be displayed")

        let alertMessage = alert.staticTexts["Buy $25.99 subscription?"]
        XCTAssertTrue(alertMessage.exists, "Alert message should be displayed")

        let confirmButton = alert.buttons["Confirm"]
        XCTAssertTrue(confirmButton.exists, "The confirm button should be present in the alert")
        let cancelButton = alert.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "The cancel button should be present in the alert")

        // Cancel
        cancelButton.tap()
        XCTAssertFalse(alert.exists, "The alert should be dismissed after tapping cancel")

        // Select 1
        let offer1View = app.otherElements["Offer1View"]
        offer1View.tap()
        subscribeButton.tap()
        XCTAssertTrue(alert.exists, "The confirmation alert should be displayed")

        let newAlertMessage = alert.staticTexts["Buy $35.99 subscription?"]
        XCTAssertTrue(newAlertMessage.exists, "Alert message should be displayed")

        XCTAssertTrue(confirmButton.exists, "The confirm button should be present in the alert")
        XCTAssertTrue(cancelButton.exists, "The cancel button should be present in the alert")

        // Confirm
        let previousScreen = app.otherElements["HomeViewController"]
        confirmButton.tap()
        XCTAssertFalse(alert.exists, "The alert should be dismissed after tapping cancel")
        XCTAssertTrue(previousScreen.exists, "The previous screen should be displayed")
    }

    func testOffer2Selection() throws {
        let offer2View = app.otherElements["Offer2View"]
        offer2View.tap()

        let subscribeButton = app.buttons["SubscribeButton"]
        subscribeButton.tap()

        let alert = app.alerts["Subscription Confirmation"]
        XCTAssertTrue(alert.exists, "The confirmation alert should be displayed")

        let alertMessage = alert.staticTexts["Buy $25.99 subscription?"]
        XCTAssertTrue(alertMessage.exists, "Alert message should be displayed")

        let confirmButton = alert.buttons["Confirm"]
        XCTAssertTrue(confirmButton.exists, "The confirm button should be present in the alert")
        let cancelButton = alert.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "The cancel button should be present in the alert")

        let previousScreen = app.otherElements["HomeViewController"]
        confirmButton.tap()
        XCTAssertFalse(alert.exists, "The alert should be dismissed after tapping cancel")
        XCTAssertTrue(previousScreen.exists, "The previous screen should be displayed")
    }
}
