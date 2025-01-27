import XCTest
@testable import ArthurDodo

// MARK: - Spy objects
final class ProfileViewControllerSpy: ProfileViewInput {

    // MARK: - Properties
    var setupInitialStateCalled = false
    var showLoadingCalled = false
    var showErrorCalled = false
    var configureDataCalled = false
    var configureCalledWithData: (profile: User, promo: [Promo])?

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

    func configure(with data: (profile: User, promo: [Promo]) ) {
        configureDataCalled = true
        configureCalledWithData = data
    }
}

final class ProfileStorageMock: ProfileStorageProtocol {

    // MARK: - Properties
    var mockUserData: User?
    var mockPromo: [Promo] = []
    var mockSelectedPromo: Promo?

    // MARK: - Methods
    func setUserData(_ user: User) {
        print("1")
    }
    
    func getUserData() -> User? {
        mockUserData
    }
    
    func getUserAddresses() -> [Address]? {
        return nil

    }
    
    func isUserDataLoaded() -> Bool {
        return false
    }
    
    func setPromo(_ promos: [Promo]) {
        print("1")
    }
    
    func getPromo() -> [Promo] {
        mockPromo
    }

    func setSelectedPromo(_ promo: Promo) {
        print("1")
    }

    func getSelectedPromo() -> Promo? {
        return nil
    }
}

// MARK: - Testing
final class ProfilePresenterTests: XCTestCase {
    var mockStorage: ProfileStorageMock!
    var presenter: ProfilePresenter!
    var spyView: ProfileViewControllerSpy!

    override func setUp() {
        super.setUp()
        mockStorage = ProfileStorageMock()
        presenter = ProfilePresenter(storage: mockStorage)
        spyView = ProfileViewControllerSpy()

        presenter.view = spyView
    }

    // После того как сработал метод viewLoaded у view должны отработать методы setupInitialState и showLoading
    func testViewLoadedSetupInitialState() {
        presenter.viewLoaded()

        XCTAssertTrue(spyView.setupInitialStateCalled)
        XCTAssertTrue(spyView.showLoadingCalled)
    }

    func testSuccessfullyLoadedUserData() {
        // Arrange
        let user = User(userId: "1", firstName: "Test", phoneNumber: "+79123456789", email: "test@test.ru", dateOfBirth: "1990-01-01", agreeOfSending: true, dodoCoins: 0, orders: 0, address: [])
        let promo: [Promo] = []

        mockStorage.mockUserData = user
        mockStorage.mockPromo = promo

        // Act
        presenter.viewLoaded()

        let expectation = XCTestExpectation(description: "Wait for data loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation])

        // Assert
        XCTAssertTrue(spyView.configureDataCalled)
        XCTAssertEqual(spyView.configureCalledWithData?.profile.dodoCoins, user.dodoCoins)
        XCTAssertEqual(spyView.configureCalledWithData?.promo.count, promo.count)
    }

    func testErrorState() {
        // Arrange
        let user: User? = nil

        mockStorage.mockUserData = user
        mockStorage.mockPromo = []

        // Act
        presenter.viewLoaded()

        let expectation = XCTestExpectation(description: "Wait for data loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation])

        // Assert
        XCTAssertTrue(spyView.showErrorCalled)
    }

    func testUpdateViewWithNilData() {
        // Arrange
//        let user: User? = nil

//        mockStorage.mockUserData = user

        // Act
        presenter.checkDataAndUpdateView()

        let expectation = XCTestExpectation(description: "Wait for data loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation])

        // Assert
        XCTAssertFalse(spyView.configureDataCalled)
    }

    func testPromoTapped() {
        // Arrange
        let promo: Promo = Promo(name: "test", details: "test", date: "test", imageName: "test")
        var showPromoModule = false

        presenter.coordinatorEventHandler = { event in
            XCTAssertEqual(event, .showPromoModule)
            showPromoModule = true
        }

        // Act
        presenter.sendAction(.promoTapped(promo))

        // Assert
        XCTAssertTrue(showPromoModule)
    }

    func testSendActionShowSupport() {
        // Arrange
        var showSupportModule = false
        presenter.coordinatorEventHandler = { event in
            XCTAssertEqual(event, .showSupportModule)
            showSupportModule = true
        }

        // Act
        presenter.sendAction(.chatAlertButtonTapped)

        // Assert
        XCTAssertTrue(showSupportModule)
    }

    func testSendActionDismissButton() {
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

    func testSendActionShowPersonalData() {
        // Arrange
        var personalDataModule = false
        presenter.coordinatorEventHandler = { event in
            XCTAssertEqual(event, .showPersonalDataModule)
            personalDataModule = true
        }

        // Act
        presenter.sendAction(.personalDataButtonTapped)

        // Assert
        XCTAssertTrue(personalDataModule)
    }

    func testSendActionShowChooseAddress() {
        // Arrange
        var chooseAddressModule = false
        presenter.coordinatorEventHandler = { event in
            XCTAssertEqual(event, .showChooseAddressModule)
            chooseAddressModule = true
        }

        // Act
        presenter.sendAction(.addressCellTapped)

        // Assert
        XCTAssertTrue(chooseAddressModule)
    }
}
