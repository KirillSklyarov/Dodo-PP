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
    var fetchedUserAddresses: [Address] = []
    var fetchedToppings: [Topping] = []
    var fetchedStories: [Story] = []
    private var fetchedItems: [Item] = []
    private var fetchedPromo: [Promo] = []

    var category: [CategoryName] = []

    var order: [Order] = []
    private var specialOfferArray: [Item] = []
    private var selectedItem: Item?

    // MARK: - Callbacks
    var onDataFetchedSuccessfully: (() -> Void)?
    var onToppingsFetchedSuccessfully: (([Topping]) -> Void)?
    var onStoriesFetchedSuccessfully: (([Story]) -> Void)?
    var onItemsFetchedSuccessfully: (([Item]) -> Void)?
    var onPromoFetchedSuccessfully: (([Promo]) -> Void)?
}

// MARK: - User Addresses
extension DataStorage {
    func fetchUserAddresses() {
        NetworkManager.shared.fetchData(.userAddress) { [weak self] (result: Result<[Address], NetworkError>) in
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

// MARK: - Toppings
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

// MARK: - Items
extension DataStorage {
    func fetchItems() {
        NetworkManager.shared.fetchData(.products) { [weak self] (result: Result<[Item], NetworkError>) in
            guard let self else { return }
            switch result {
            case .success(let items):
                fetchedItems = items.sorted { $0.category.rawValue < $1.category.rawValue }
                getArrayOfRandomItems(4)
                getCategoriesFromCatalog()
                onItemsFetchedSuccessfully?(items)
            case .failure(let error):
                print(error)
            }
        }
    }

    func getCatalog() -> [Item] {
        fetchedItems
    }

    func sendSelectedItemToStorage(_ item: Item) {
        selectedItem = item
    }

    func getSelectedItemFromStorage() -> Item? {
        selectedItem
    }
}

// MARK: - Promo
extension DataStorage {
    func fetchPromo() {
        NetworkManager.shared.fetchData(.promo) { [weak self] (result: Result<[Promo], NetworkError>) in
            guard let self else { return }
            switch result {
            case .success(let promo):
                fetchedPromo = promo
                onPromoFetchedSuccessfully?(fetchedPromo)
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Categories
extension DataStorage {
    func getCategoriesFromCatalog() {
        let set = Set(fetchedItems.compactMap(\.category))
        let sorted = Array(set).sorted { $0.rawValue < $1.rawValue }
        category = sorted
    }

    func getCategories() -> [CategoryName] {
        category
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

// MARK: - Special Offers
extension DataStorage {
    func getSpecialOffersArray() -> [Item] {
        specialOfferArray
    }

    func getArrayOfRandomItems(_ countOfElements: Int) {
        specialOfferArray = SpecialOffer.configRandomOffer(fetchedItems, countOfElements)
    }

    func getRandomItems(_ countOfElements: Int) -> [Item] {
        let result = SpecialOffer.configRandomOffer(fetchedItems, countOfElements)
        return result
    }
}
