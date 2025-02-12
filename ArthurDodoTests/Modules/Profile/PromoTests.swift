import XCTest
@testable import ArthurDodo


// MARK: - Spy objects
final class PromoViewControllerSpy: PromoViewInput {

    // MARK: - Properties
    var setupInitialStateCalled = false
    var showLoadingCalled = false
    var showErrorCalled = false
    var configureDataCalled = false
    var applyPromoCalled = false
    var configureCalledWithData: Promo?

    // MARK: - Methods
    func setupInitialState() {
        setupInitialStateCalled = true
    }
    
    func showLoading() {
        showLoadingCalled = true
    }
    
    func configure(with data: Promo) {
        configureDataCalled = true
        configureCalledWithData = data
    }
    
    func showError() {
        showErrorCalled = true
    }

    func updateUIWithAppliedPromo() {
        applyPromoCalled = true
    }
}

final class MockPromoStorage: PromoStorageProtocol {
    func setSelectedPromo(_ promo: Promo) {

    }
    
    func getSelectedPromo() -> Promo? {
        return nil
    }
}

// MARK: - Testing
final class PromoPresenterTests: XCTestCase {
    var mockStorage: PromoStorageProtocol!
    var presenter: PromoPresenter!
    var spyView: PromoViewControllerSpy!

    override func setUp() {
        super.setUp()
        
        mockStorage = MockPromoStorage()
        spyView = PromoViewControllerSpy()
        presenter = PromoPresenter(storage: mockStorage)

        presenter.view = spyView
    }

    func testViewLoadedSetupInitialState() {
        // Act
        presenter.viewLoaded()

        // Assert
        XCTAssertTrue(spyView.setupInitialStateCalled)
    }

    func testViewShowLoading() {
        presenter.loadData()

        XCTAssertTrue(spyView.showLoadingCalled)
    }

    func testViewShowError() {
        // Arrange
        let promo: Promo? = nil
        presenter.promo = promo

        // Act
        presenter.checkDataAndUpdateView()

        let expectation = XCTestExpectation(description: "Wait for data loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            expectation.fulfill()
        }
        wait(for: [expectation])

        // Assert
        XCTAssertTrue(spyView.showErrorCalled)
    }

    func testViewUpdateUI() {
        // Arrange
        let promo = Promo(name: "Test Promo", details: "Test Details", date: "12.12.2020", imageName: "test")
        presenter.promo = promo

        // Act
        presenter.checkDataAndUpdateView()

        let expectation = XCTestExpectation(description: "Wait for data loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            expectation.fulfill()
        }
        wait(for: [expectation])

        // Assert
        XCTAssertTrue(spyView.configureDataCalled)
        XCTAssertEqual(spyView.configureCalledWithData?.name, promo.name)
    }

    func testViewActionSelectPromo() {
        // Act
        presenter.sendAction(.applyPromo)

        // Assert
        XCTAssertTrue(spyView.applyPromoCalled)
    }

    func testViewCoordinatorShowError() {
        // Arrange
        let promo: Promo? = nil
        presenter.promo = promo
        var coordinatorShowErrorModule = false

        presenter.coordinatorEventHandler = { event in
            XCTAssertEqual(event, .showError)
            coordinatorShowErrorModule = true
        }

        // Act
        presenter.checkDataAndUpdateView()

        let expectation = XCTestExpectation(description: "Wait for data loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            expectation.fulfill()
        }
        wait(for: [expectation])

        // Assert
        XCTAssertTrue(coordinatorShowErrorModule)
    }
}
