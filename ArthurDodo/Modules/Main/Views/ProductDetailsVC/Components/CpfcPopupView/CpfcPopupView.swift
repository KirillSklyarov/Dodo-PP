import UIKit

enum CPFCData: String, Codable, CaseIterable {
    case weight = "Вес"
    case calories = "Пищевая ценность"
    case proteins = "Белки"
    case fats = "Жиры"
    case carbohydrates = "Углеводы"
}


final class CpfcPopupView: UIViewController {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(type: .smallHeader)
    private lazy var subLabel = AppLabel(type: .smallTitle, text: "Пищевая ценность на 100 г")
    private lazy var infoLabel = AppLabel(type: .smallTitle, text: "Может содержать: глютен, молоко и продукты его переработки (в том числе лактозу), а так же некоторые другие аллергены")
    private lazy var cpfcTableView = CpfcTableView(dataSource: self)
    
    private lazy var contentStack = AppStackView([titleLabel, subLabel, cpfcTableView, infoLabel], axis: .vertical, distribution: .equalSpacing)

    // MARK: - Properties
    private let cornerRadius: CGFloat = 20

    private let cpfcNames = CPFCData.allCases
    private var item: Item?
    private var productDetails: WeightPrice?

    // MARK: - Init
    init(item: Item? = nil) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getItem(_ item: Item?) {
        if let item { self.item = item }
        updateUI()
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }

    // MARK: - Public methods
    func setProductDetails(_ productDetails: WeightPrice) {
        self.productDetails = productDetails
        cpfcTableView.reloadData()
    }
}

// MARK: - Setup popUp View
extension CpfcPopupView {
    func setupPopupView(sourceView: UIView, sourceRect: CGRect) {
        modalPresentationStyle = .popover
        preferredContentSize = CGSize(width: 300, height: 310)
        popoverPresentationController?.sourceView = sourceView
        popoverPresentationController?.sourceRect = sourceRect
        popoverPresentationController?.permittedArrowDirections = .right
        popoverPresentationController?.delegate = sourceView as? UIPopoverPresentationControllerDelegate
    }
}

// MARK: - Setup UI
private extension CpfcPopupView {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStack)
        setupLayout()
    }

    func setupLayout() {
        contentStack.setConstraints(insets: UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 20))
    }
}

// MARK: - Update UI
private extension CpfcPopupView {
    func updateUI() {
        titleLabel.text = item?.name
        isOneSize()
    }

    // Если есть 1 размер, то показывай его, если больше чем 1 размер, то показывать средний
    func isOneSize() {
        if let oneSize = item?.itemSize.oneSize {
            productDetails = oneSize
        } else {
            productDetails = item?.itemSize.medium
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CpfcPopupView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cpfcNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(indexPath) as CpfcTableViewCell 
        guard let item = productDetails else { print("We have no productDetails"); return cell }

        let title = cpfcNames[indexPath.row]
        let value: String =
            switch title {
            case .weight: item.weight.description
            case .calories: item.cpfc.calories.description
            case .proteins: item.cpfc.protein.description
            case .fats: item.cpfc.fat.description
            case .carbohydrates: item.cpfc.carbohydrates.description
            }

        cell.configureCell(title: title.rawValue, cpfcValue: value)
        return cell
    }
}
