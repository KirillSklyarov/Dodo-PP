//
//  OrderStorageService.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 27.09.2024.
//

import Foundation

final class DataStorage {

    // MARK: - Singleton
    static var shared = DataStorage()
    private init() {}

    // MARK: - Properties
    var fetchedUserAddresses: [AddressModel] = []
    var fetchedToppings: [Topping] = []
    var fetchedStories: [Story] = []

    var order: [Order] = []
    var onDataFetchedSuccessfully: (() -> Void)?
    var onToppingsFetchedSuccessfully: (([Topping]) -> Void)?
    var onStoriesFetchedSuccessfully: (([Story]) -> Void)?
}

// MARK: - User Addresses
extension DataStorage {
    func fetchUserAddresses() {
        NetworkManager.shared.fetchData(.userAddress) { [weak self] (result: Result<[AddressModel], NetworkError>) in
            guard let self else { return }
            switch result {
            case .success(let addresses):
                fetchedUserAddresses = addresses
                onDataFetchedSuccessfully?()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Stories
extension DataStorage {
    func fetchStories() {
        NetworkManager.shared.fetchData(.stories) { [weak self] (result: Result<[Story], NetworkError>) in
            guard let self else { return }
            switch result {
            case .success(let stories):
                fetchedStories = stories
                onStoriesFetchedSuccessfully?(fetchedStories)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension DataStorage {
    func fetchToppings() {
        NetworkManager.shared.fetchData(.toppings) { [weak self] (result: Result<[Topping], NetworkError>) in
            guard let self else { return }
            switch result {
            case .success(let topping):
                fetchedToppings = topping
                onToppingsFetchedSuccessfully?(fetchedToppings)
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Orders
extension DataStorage {

    func sendToOrderStorage(_ order: Order) {
        self.order.append(order)
    }

    func increaseCountOfItem(_ indexPath: IndexPath, _ value: Int) {
        order[indexPath.row].count = value
    }

    func removeItemFromOrderStorage(_ indexPath: IndexPath) {
        order.remove(at: indexPath.row)
    }

    func getOrderFromStorage() -> [Order] {
        order
    }

    func getTotalOrderPrice() -> Int {
        order.compactMap{ $0.price * $0.count }.reduce(0, +)
    }
}
