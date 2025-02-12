import XCTest
@testable import ArthurDodo

// MARK: - Spy objects
final class SupportViewSpy: SupportViewInput {

    // MARK: - Properties
    var setupInitialStateCalled = false
    var hideContentStackCalled = false
    var showContentStackCalled = false

    // MARK: - Methods
    func setupInitialState() {
        setupInitialStateCalled = true
    }

    func hideContentStack() {
        hideContentStackCalled = true
    }

    func showContentStack() {
        showContentStackCalled = true
    }
}

// MARK: - Testing
final class SupportPresenterTests: XCTestCase {
    var presenter: SupportPresenter!
    var viewSpy: SupportViewSpy!

    override func setUp() {
        super.setUp()

        presenter = SupportPresenter()
        viewSpy = SupportViewSpy()

        presenter.view = viewSpy
    }

    func testSetupInitialState() {
        // Act
        presenter.viewLoaded()

        // Assert
        XCTAssertTrue(viewSpy.setupInitialStateCalled)
    }

    func testShowContentStack() {
        // Act
        presenter.viewLoaded()

        let expectation = XCTestExpectation(description: "Wait for data loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation])

        // Assert
        XCTAssertTrue(viewSpy.showContentStackCalled)
    }

    func testHideContentStack() {
        // Act
        presenter.sendAction(.dismiss)

        let expectation = XCTestExpectation(description: "Wait for data loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation])

        // Assert
        XCTAssertTrue(viewSpy.hideContentStackCalled)
    }

    func testCoordinator() {
        // Arrange
        var coordinatorCalled = false

        presenter.coordinatorEventHandler = { event in
            XCTAssertEqual(event, .dismissModule)
            coordinatorCalled = true
        }

        // Act
        presenter.sendAction(.dismiss)

        // Assert
        XCTAssertTrue(coordinatorCalled)
    }
}
