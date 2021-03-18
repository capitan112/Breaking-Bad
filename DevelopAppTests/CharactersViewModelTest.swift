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
    override func spec() {
        var subject: CharactersViewModelType!
        var characters: [Character]!

        context("when viewModel is loaded") {
            beforeEach {
                subject = MockCharactersViewModel()
                subject.fetchData()
                characters = self.fetchJSON(json: charactersJson)
            }

            afterEach {
                subject = nil
                characters = nil
            }

            it("it should filter characters by seasons 1") {
                expect(subject.characters?.count).to(equal(2))
                subject.isFiltering = true
                subject.filterCharacters(by: 1)
                expect(subject.characters?.count).to(equal(2))
            }

            it("it should filter characters by seasons 3") {
                expect(subject.characters?.count).to(equal(2))
                subject.filterCharacters(by: 3)
                subject.isFiltering = true
                expect(subject.characters?.count).to(equal(1))
            }

            it("it should search characters by name") {
                guard let expectedCharacter = characters.first else {
                    fail()
                    return
                }

                subject.searchCharacters(by: "Walter White")
                let character = subject.characters?.first
                expect(character?.name).to(equal("Walter White"))
                let occupation = expectedCharacter.occupation
                expect(character?.occupation).to(equal(occupation))
            }

            it("it should search characters by name with space") {
                subject.searchCharacters(by: " ")
                subject.isFiltering = true
                expect(subject.characters?.count).to(equal(2))
            }

            it("it should search Characters by name with empty value") {
                expect(subject.characters?.count).to(equal(2))
                subject.searchCharacters(by: "")
                subject.isFiltering = true
                expect(subject.characters?.count).to(equal(0))
            }
        }
    }

    private func fetchJSON(json: String) -> [Character] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let jsonData = json.data(using: .utf8)!
        let details = try! decoder.decode([Character].self, from: jsonData)

        return details
    }
}
