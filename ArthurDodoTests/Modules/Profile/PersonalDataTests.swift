import XCTest
@testable import ArthurDodo

// MARK: - Spy objects
final class PersonalDataViewControllerSpy: PersonalViewInput {

    // MARK: - Properties
    var setupInitialStateCalled = false
    var showLoadingCalled = false
    var showErrorCalled = false
    var configureCalled = false
    var configureCalledWithData: User?

    // MARK: - Methods
    func setupInitialState() {
        setupInitialStateCalled = true
    }

    func showLoading() {
        showLoadingCalled = true
    }

    func showError() {
        showErrorCalled = true
    }

    func configure(with data: User) {
        configureCalled = true
        configureCalledWithData = data
    }
}

// MARK: - Testing
final class PersonalDataPresenterTests: XCTestCase {
    var mockStorage: ProfileStorageMock!
    var mockView: PersonalDataViewControllerSpy!

    var presenter: (any PersonalViewOutput)!

    override func setUp() {
        mockStorage = ProfileStorageMock()
        mockView = PersonalDataViewControllerSpy()
        presenter = PersonalPresenter(storage: mockStorage)

        presenter.view = mockView
    }

    func testSetupInitialState() {
        presenter.viewLoaded()
        
        XCTAssertTrue(mockView.setupInitialStateCalled)
        XCTAssertTrue(mockView.showLoadingCalled)
    }

    func testConfiguringViewWithData() {
        // Arrange
        let user = User(userId: "1", firstName: "Test", phoneNumber: "+79123456789", email: "test@test.ru", dateOfBirth: "1990-01-01", agreeOfSending: true, dodoCoins: 0, orders: 0, address: [])
        mockStorage.mockUserData = user

        // Act
        presenter.viewLoaded()

        let expectation = XCTestExpectation(description: "Wait for data loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation])

        // Assert
        XCTAssertTrue(mockView.configureCalled)
    }

    func testIsDataValid() {
        // Arrange
        let personalData: User? = nil

        mockStorage.mockUserData = personalData

        // Act
        presenter.viewLoaded()

        let expectation = XCTestExpectation(description: "Wait for data loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation])

        // Assert
        XCTAssertTrue(mockView.showErrorCalled)
    }

    func testSendActionDismiss() {
        // Arrange
        var dismissModule = false
        presenter.coordinatorEventHandler = { event in
            XCTAssertEqual(event, .dismissModule)
            dismissModule = true
        }

        // Act
        presenter.sendAction(.dismissButtonTapped)

        // Assert
        XCTAssertTrue(dismissModule)
    }

    func testSendActionShowURL() {
        // Arrange
        let URL = URL(string: "https://www.dodopizza.ru")!

        var showURL = false
        presenter.coordinatorEventHandler = { event in
            XCTAssertEqual(event, .showLegalInfoModule(URL))
            showURL = true
        }

        // Act
        presenter.sendAction(.showURLTapped)

        // Assert
        XCTAssertTrue(showURL)
    }
}
