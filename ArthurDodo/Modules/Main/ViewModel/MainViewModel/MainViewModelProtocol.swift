import Foundation
import Combine

protocol MainViewModelProtocol: BaseViewControllerOutputOLD where ActionType == MainAction  {

    var cartPricePublisher: Published<Int?>.Publisher { get }
    var storiesPublisher: Published<[Story]?>.Publisher { get }
    var categoriesPublisher: Published<[Category]?>.Publisher { get }
    var promoItemsPublisher: Published<[Item]?>.Publisher { get }
    var catalogPublisher: Published<[Item]?>.Publisher { get }
    var statePublisher: Published<ScreenState>.Publisher { get }
    var isShowOrderViewPublisher: Published<Bool?>.Publisher { get }
    var isShowProfileButtonPublisher: Published<Bool?>.Publisher { get }

    var headerStatePublisher: Published<ScreenState?>.Publisher { get }

    var addressDodoCoins: Publishers.CombineLatest<Published<String?>.Publisher, Published<Int?>.Publisher> { get }
    var orderPublisher: Publishers.CombineLatest<Published<String?>.Publisher, Published<Int?>.Publisher> { get }

    var onProfileButtonTapped: (() -> Void)? { get set }
    var onAddressButtonTapped: (() -> Void)? { get set }
    var onStoryTapped: ((IndexPath) -> Void)? { get set }
    var onProductDetailsTapped: (() -> Void)? { get set }
    var onCartButtonTapped: (() -> Void)? { get set }
}
