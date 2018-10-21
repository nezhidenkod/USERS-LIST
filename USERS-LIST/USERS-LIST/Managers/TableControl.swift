//
//  TableControl.swift
//  WRF-Reserve
//
//  Created by Nezhidenko Dmitriy on 5/23/18.
//  Copyright © 2018 Nezhidenko Dmitriy. All rights reserved.
//

import UIKit

protocol ActionsDelegate: class {}

// MARK: - BaseTableViewCell
class BaseTableViewCell: UITableViewCell {

    // - Some actions in cell
    weak var actionsDelegate: ActionsDelegate?

    // - Required override
    func configure(withModel model: Any) {
        fatalError("Override: `func configure(withModel model:)`")
    }
}


// MARK: - CellModel
struct CellModel {
    let cell: String
    let viewModel: Any
    var cellHeight: CGFloat?
    
    init(viewModel: Any, cell: String, cellHeight: CGFloat? = nil) {
        self.cell = cell
        self.viewModel = viewModel
        self.cellHeight = cellHeight
    }
}

// MARK: - SectionModel
struct SectionModel {
    var cellModels: [CellModel]
    let sectionView: UIView?
    
    init(cellModels: [CellModel], sectionView: UIView? = nil) {
        self.cellModels = cellModels
        self.sectionView = sectionView
    }
}

// MARK: - Callbacks
struct DelegatedCall<Input> {
    
    private(set) var callback: ((Input) -> Void)?
    
    mutating func delegate<Object: AnyObject>(to object: Object, with callback: @escaping(Object, Input) -> Void) {
        
        self.callback = { [weak object] input in
            guard let object = object else { return }
            callback(object, input)
        }
    }
    
}

// MARK: - TablePagination
class TablePagination {
    
    // MARK: Public Properties
    var loadData = DelegatedCall<Int>()
    
    // MARK: Private Properties
    private var load = true
    private var currentPage = 1
    private let itemsPerBatch: Int
    
    // MARK: Initializers
    init(itemsPerBatch: Int) {
        self.itemsPerBatch = itemsPerBatch
    }
    
    // MARK: Public funcs
    func update() {
        self.load = true
        self.currentPage += 1
    }
    
    func loadMore() {
        
        guard load else { return }
        print("Fetching page \(currentPage)")
        load = false
        loadData.callback?(currentPage)
    }
}

// MARK: - TableControl
class TableControl: NSObject {
    
    
    // MARK: Required
    var sections = [SectionModel]()
    
    
    // MARK: Optional
    var pagination: TablePagination?
    var didScroll = DelegatedCall<UIScrollView>()
    var didSelectCell = DelegatedCall<IndexPath>()
    var didEndDecelerating = DelegatedCall<UIScrollView>()
    
    weak var actionsDelegate: ActionsDelegate?
    
    
    // MARK: Initializers
    init(tableView: UITableView) {
        super.init()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: Initializers BaseTableViewCell
    private func getCell(tableView: UITableView, indexPath: IndexPath) -> BaseTableViewCell {
        
        let cellID = sections[indexPath.section].cellModels[indexPath.row].cell
        let model = sections[indexPath.section].cellModels[indexPath.row].viewModel
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! BaseTableViewCell
        cell.actionsDelegate = actionsDelegate
        cell.configure(withModel: model)
        return cell
    }
    
}

// MARK: - UITableViewDataSource
extension TableControl: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.isHidden = sections.count == 0
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cellModels.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let sectionView = sections[section].sectionView {
            return sectionView.frame.size.height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(tableView: tableView, indexPath: indexPath)
    }
}


// MARK: - UITableViewDelegate
extension TableControl: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Use in ViewController: tableControl.didSelectCell.delegate(to: self) { (self, indexPath) in }
        didSelectCell.callback?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let dataSource = self.sections[indexPath.section].cellModels
        if indexPath.row == dataSource.count - 1 {
            pagination?.loadMore()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = sections[indexPath.section].cellModels[indexPath.row].cellHeight {
            return height
        }
        return UITableView.automaticDimension
    }
}


//MARK: - UIScrollViewDelegate
extension TableControl: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Use in ViewController: tableControl.didScroll.delegate(to: self) { (self, scrollView) in }
        didScroll.callback?(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Use in ViewController: tableControl.didEndDecelerating.delegate(to: self) { (self, scrollView) in }
        didEndDecelerating.callback?(scrollView)
    }
}


// MARK: - UITableViewCell ReuseID extension
extension UITableViewCell {
    
    // - ReuseID
    public static var reuseID: String {
        return String(describing: self)
    }
}
