import UIKit

final class CpfcTableView: AppTableView {

    private let cellHeight: CGFloat = 30

    init(dataSource: UITableViewDataSource&UITableViewDelegate) {
        super.init(frame: .zero, style: .plain)
        self.dataSource = dataSource
        delegate = dataSource
        registerCell(CpfcTableViewCell.self)
        backgroundColor = .clear
        rowHeight = cellHeight
        estimatedRowHeight = UITableView.automaticDimension
        isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
