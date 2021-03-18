//
//  CharactersViewControllerTest.swift
//  DevelopAppTests
//
//  Created by Oleksiy Chebotarov on 17/03/2021.
//

@testable import DevelopApp
import Foundation
import Nimble
import Quick

class CharactersViewControllerTest: QuickSpec {
    override func spec() {
        var subject: CharactersViewController!
        var viewModel: CharactersViewModelType!
        var cell: CharacterTableViewCell!

        context("when view is loaded") {
            beforeEach {
                subject = CharactersViewController.instantiate(storyboardName: "Main")
                viewModel = MockCharactersViewModel()
                viewModel.fetchData()
                subject.viewModel = viewModel
                _ = subject.view

                cell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CharacterTableViewCell
            }

            it("it should load 2 characters") {
                expect(subject.tableView.numberOfRows(inSection: 0)).toEventually(equal(2))
            }

            it("it should get navigationItem rightBarButton with name filter") {
                expect(subject.navigationItem.rightBarButtonItems?.first?.title).to(equal("Filter"))
            }

            it("it should get tap rightBarButton with name filter and get alert controler") {
                let action = subject.navigationItem.rightBarButtonItems?.first?.action
                let target = subject.navigationItem.rightBarButtonItems?.first?.target
                let control = UIControl()
                control.sendAction(action!, to: target, for: nil)
                expect(subject.alertController.title).to(equal("Filter by season"))
            }

            it("it should get navigationItem leftBarButton with name search") {
                expect(subject.navigationItem.leftBarButtonItems?.first?.title).to(equal("Search"))
            }

            it("tableview cell should contain movie title and genre", closure: {
                expect(cell.nameLabel.text).to(equal("Walter White"))
            })
        }
    }
}

class MockCharactersViewModel: CharactersViewModel {
    override func fetchData() {
        originCharacters = fetchJSON(json: charactersJson)
    }

    private func fetchJSON(json: String) -> [Character] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let jsonData = json.data(using: .utf8)!
        let details = try! decoder.decode([Character].self, from: jsonData)

        return details
    }
}
