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
    var subject: CharactersViewController!
    var cell: CharacterTableViewCell!
    
    override func spec() {
        context("when view is loaded") {
            beforeEach {
                self.subject = CharactersViewController.instantiate(storyboardName: "Main")
                let networkServiceLocal = NetworkServiceLocal(json: charactersJson)
                let localDataFetcher = NetworkDataFetcher(networkingService: networkServiceLocal)
                let mockViewModel = MockCharactersViewModel(dataFetcher: localDataFetcher)
                self.subject.viewModel = mockViewModel
                self.subject.viewModel?.fetchData()
                _ = self.subject.view

                self.cell = self.subject.tableView(self.subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CharacterTableViewCell
            }
            
            afterEach {
                self.subject = nil
                self.cell = nil
            }

            it("it should load 2 characters") {
                expect(self.subject.tableView.numberOfRows(inSection: 0)).toEventually(equal(2))
            }

            it("it should get navigationItem rightBarButton with name filter") {
                expect(self.subject.navigationItem.rightBarButtonItems?.first?.title).to(equal("Filter"))
            }

            it("it should get tap rightBarButton with name filter and get alert controler") {
                let action = self.subject.navigationItem.rightBarButtonItems?.first?.action
                let target = self.subject.navigationItem.rightBarButtonItems?.first?.target
                let control = UIControl()
                control.sendAction(action!, to: target, for: nil)
                expect(self.subject.alertController.title).to(equal("Filter by season"))
            }

            it("it should get navigationItem leftBarButton with name search") {
                expect(self.subject.navigationItem.leftBarButtonItems?.first?.title).to(equal("Search"))
            }

            it("tableview cell should contain movie title and genre") {
                expect(self.cell.nameLabel.text).to(equal("Walter White"))
            }
        }
    }
}

class MockCharactersViewModel: CharactersViewModel {}
