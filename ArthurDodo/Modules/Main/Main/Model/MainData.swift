
struct MainData {
    var headerData: HeaderData?
    var order: OrderDetails?
    var stories: [Story]?
    var promoItems: [Item]?
    var categories: [Category]?
    var catalog: [Item]?
    var cartPrice: Int?
    var featureToggle: [FeatureType: Bool]?
}

struct HeaderData {
    var mainAddress: String?
    var userDodoCoins: Int?
}

struct OrderDetails {
    var isActiveOrder: Bool?
    var orderPrice: Int?
    var orderStatus: String?
}
