//
//  CharactersViewController.swift
//  DevelopApp
//
//  Created by Oleksiy Chebotarov on 16/03/2021.
//

import UIKit

class CharactersViewController: UIViewController, Storyboarded {
    var viewModel: CharactersViewModelType? {
        didSet {
            setupBindings()
        }
    }

    var coordinator: CharacterDetailsFlow?
    private var filterButton: UIBarButtonItem!
    private var searchButton: UIBarButtonItem!
    private var cancelButton: UIBarButtonItem!
    private var cancelAction: UIAlertAction {
        return UIAlertAction(title: "Cancel", style: .cancel, handler: { [unowned self] _ in
            viewModel?.resetSearching()
            self.reloadTableView()
        })
    }

    var alertController: UIAlertController!

    @IBOutlet var tableView: UITableView!
    let cellID = CharacterTableViewCell.reuseIdentifierCell

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBarTitle()
        hideEpmtyCells()
        configNavigationItems()
    }

    private func configNavigationItems() {
        filterButton = createBarButton(title: "Filter", selector: #selector(filterTapped))
        searchButton = createBarButton(title: "Search", selector: #selector(searchTapped))
        cancelButton = createBarButton(title: "Cancel", selector: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = filterButton
        navigationItem.leftBarButtonItem = searchButton
    }

    private func createBarButton(title: String, selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: title, style: .plain, target: self, action: selector)
    }

    private func hideEpmtyCells() {
        tableView.tableFooterView = UIView()
    }

    private func setupBindings() {
        viewModel?.reload.bind { [unowned self] _ in
            self.reloadTableView()
        }
    }

    private func reloadTableView() {
        performUIUpdatesOnMain { [unowned self] in
            self.tableView.reloadData()
        }
    }

    private func configNavigationBarTitle() {
        let navLabel = UILabel()
        navLabel.textAlignment = .center
        let font = UIFont.systemFont(ofSize: 22, weight: .regular)
        let navTitle = NSMutableAttributedString(string: "Characters",
                                                 attributes: [
                                                     NSAttributedString.Key.foregroundColor: UIColor.black,
                                                     NSAttributedString.Key.font: font,
                                                 ])
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
    }
}

extension CharactersViewController {
    private func updateStateForMode(isFilteringMode: Bool) {
        viewModel?.isFiltering = isFilteringMode
        navigationItem.rightBarButtonItems = isFilteringMode ? [cancelButton] : [filterButton]
    }

    private func updateStateForMode(isSearchingMode: Bool) {
        viewModel?.isFiltering = isSearchingMode
        navigationItem.leftBarButtonItems = isSearchingMode ? [cancelButton] : [searchButton]
    }

    @objc func cancelButtonTapped() {
        viewModel?.resetSearching()
        updateStateForMode(isFilteringMode: false)
        updateStateForMode(isSearchingMode: false)
        reloadTableView()
    }

    @objc func searchTapped() {
        cancelButtonTapped()
        alertController = alertController(title: "Search by name")
        let searchAlert = alertAction(title: "Search", handler: searchedHandler)
        alertController.addAction(searchAlert)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    private func searchedHandler(alert _: UIAlertAction) {
        let userInput = alertController.textFields?[0].text?.lowercased() ?? ""
        if !userInput.isEmpty {
            viewModel?.searchCharacters(by: userInput)
            updateStateForMode(isSearchingMode: true)
        } else {
            updateStateForMode(isSearchingMode: false)
            viewModel?.resetSearching()
        }

        reloadTableView()
    }

    @objc func filterTapped() {
        cancelButtonTapped()
        alertController = alertController(title: "Filter by season")

        let filterAction = alertAction(title: "Filter", handler: filterHandler)
        alertController.addAction(filterAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    private func filterHandler(alert _: UIAlertAction) {
        let userInput = alertController.textFields?[0].text ?? "0"

        if !userInput.isEmpty, let season = Int(userInput) {
            viewModel?.filterCharacters(by: season)
            updateStateForMode(isFilteringMode: true)
        } else {
            updateStateForMode(isFilteringMode: false)
            viewModel?.resetSearching()
        }

        reloadTableView()
    }

    private func alertAction(title: String, handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default, handler: handler)
    }

    private func alertController(title: String, style: UIAlertController.Style = .alert) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: style)
        alertController.addTextField()

        return alertController
    }
}

extension CharactersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel?.rows ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CharacterTableViewCell

        if let character = viewModel?.characters?[indexPath.row] {
            let cellViewModel = CharacterCellViewModel(character: character)
            cell.viewModel = cellViewModel
        }

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let character = viewModel?.characters?[indexPath.row] else { return }
        coordinator?.coordinateToDetails(with: character)
    }
}
