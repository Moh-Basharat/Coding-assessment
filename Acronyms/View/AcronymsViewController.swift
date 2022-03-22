//
//  ViewController.swift
//  Acronyms
//
//  Created by Mohammad on 22/03/22.
//

import UIKit

/// Protocol to notify reload with binding object
protocol BindableObject: AnyObject {
    func reloadData()
    func showDisplayError(message: String)
}

/// Abstraction for AcronymsViewController to deal with any view model which implments these rules
protocol AcronymsDesignable {
    var acronyms: [String] { get }
    var searchText: String? { get set }
    var screenTitle: String { get }
    var searchPlacehoder: String { get }
    func bind(withObject objet: BindableObject?)
}

class AcronymsViewController: UIViewController {
    
    private lazy var viewModel: AcronymsDesignable = AcronymsViewModel()
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSearchicon()
        self.title = viewModel.screenTitle
        viewModel.bind(withObject: self)
    }
    
    private func addSearchicon() {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.titleView = searchBar
        searchBar.placeholder = viewModel.searchPlacehoder
        searchBar.showsCancelButton = true
        self.searchBar.delegate = self
    }
    
    lazy var searchBar = UISearchBar(frame: CGRect.init(origin: .zero, size: CGSize.init(width: .greatestFiniteMagnitude, height: 40.0)))
}

// MARK: UITableViewDataSource
extension AcronymsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.acronyms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.acronyms[indexPath.row]
        return cell
    }
}

// MARK: UISearchBarDelegate
extension AcronymsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count > 1 else { return }
        viewModel.searchText = searchText
    }

    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        viewModel.searchText = searchBar.text
    }
 
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}
extension AcronymsViewController: BindableObject {
    func reloadData() {
        tableView.reloadData()
    }
    func showDisplayError(message: String) {
        print("error message === \(message)")
    }
}



