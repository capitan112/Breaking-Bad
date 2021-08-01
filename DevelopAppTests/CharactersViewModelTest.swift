//
//  CharactersViewModelTest.swift
//  DevelopAppTests
//
//  Created by Oleksiy Chebotarov on 18/03/2021.
//

@testable import DevelopApp
import Foundation
import Nimble
import Quick

class CharactersViewModelTest: QuickSpec {
    @LazyInjected var subject: CharactersViewModelType

    override func spec() {
        context("when viewModel is loaded") {
            beforeEach {
                DependencyGraph.registerAllComponents()
                DependencyGraph.registerLocalNetwork()
                self.subject.fetchData()
            }

            it("it should filter characters by seasons 1") {
                let filteredCharacters = self.subject.filterCharacters(by: 1)
                expect(filteredCharacters?.count).to(equal(2))
            }

            it("it should filter characters by seasons 3") {
                let filteredCharacters = self.subject.filterCharacters(by: 3)
                expect(filteredCharacters?.count).to(equal(1))
            }

            it("it should search Characters by name") {
                var downloadCharacters: [Character] = []

                self.subject.characters.bind { characters in
                    if let characters = characters {
                        downloadCharacters = characters
                    }
                }

                guard let expectedCharacter = downloadCharacters.first else {
                    fail()
                    return
                }

                guard let searchedCharacter = self.subject.searchCharacters(by: "Walter White")?.first else {
                    fail()
                    return
                }

                expect(searchedCharacter.name).to(equal("Walter White"))
                let occupation = expectedCharacter.occupation
                expect(searchedCharacter.occupation).to(equal(occupation))
            }

            it("it should search Characters by name with space") {
                guard let searchedCharacter = self.subject.searchCharacters(by: " ") else {
                    fail()
                    return
                }

                expect(searchedCharacter.count).to(equal(2))
            }

            it("it should search Characters by name with empty value") {
                guard let searchedCharacter = self.subject.searchCharacters(by: "") else {
                    fail()
                    return
                }

                expect(searchedCharacter.count).to(equal(0))
            }
        }
    }
}
