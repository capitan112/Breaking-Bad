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
    private var characters: [Character]?
    private var searchingCharacters: [Character]?
    private var isFiltering = false
    private var filterButton: UIBarButtonItem!
    private var searchButton: UIBarButtonItem!
    private var cancelButton: UIBarButtonItem!

    private var cancelAction: UIAlertAction {
        return UIAlertAction(title: "Cancel", style: .cancel, handler: { [unowned self] _ in
            self.resetSearching()
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

    private func updateStateForMode(isFilteringMode: Bool) {
        isFiltering = isFilteringMode
        navigationItem.rightBarButtonItems = isFilteringMode ? [cancelButton] : [filterButton]
    }

    private func updateStateForMode(isSearchingMode: Bool) {
        isFiltering = isSearchingMode
        navigationItem.leftBarButtonItems = isSearchingMode ? [cancelButton] : [searchButton]
    }

    private func setupBindings() {
        viewModel?.characters.bind { characters in
            if let characters = characters {
                self.characters = characters
                self.reloadTableView()
            }
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
    @objc func cancelButtonTapped() {
        resetSearching()
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
            searchingCharacters = viewModel?.searchCharacters(by: userInput)
            updateStateForMode(isSearchingMode: true)
        } else {
            updateStateForMode(isSearchingMode: false)
            resetSearching()
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
            searchingCharacters = viewModel?.filterCharacters(by: season)
            updateStateForMode(isFilteringMode: true)
        } else {
            updateStateForMode(isFilteringMode: false)
            resetSearching()
        }

        reloadTableView()
    }

    private func alertAction(title: String, handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default, handler: handler)
    }

    private func resetSearching() {
        isFiltering = false
        searchingCharacters = characters
    }

    private func alertController(title: String, style: UIAlertController.Style = .alert) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: style)
        alertController.addTextField()

        return alertController
    }
}

extension CharactersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return isFiltering ? searchingCharacters?.count ?? 0 : characters?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CharacterTableViewCell

        if let character = isFiltering ? searchingCharacters?[indexPath.row] : characters?[indexPath.row] {
            let cellViewModel = CharacterCellViewModel(character: character)
            cell.viewModel = cellViewModel
        }

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = isFiltering ? searchingCharacters : characters

        guard let character = details?[indexPath.row] else { return }
        coordinator?.coordinateToDetails(with: character)
    }
}
