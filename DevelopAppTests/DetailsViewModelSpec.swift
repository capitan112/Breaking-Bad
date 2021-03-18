//
//  FetchCharactersSpec.swift
//  DevelopAppTests
//
//  Created by Oleksiy Chebotarov on 17/03/2021.
//

@testable import DevelopApp
import Foundation
import Nimble
import Quick

class DetailsViewModelSpec: QuickSpec {
    override func spec() {
        var subject: DetailsViewModelType!
        var characters: [Character]!

        describe("fetch characters in ViewModel") {
            context("should get real data of list of characters") {
                beforeEach {
                    characters = self.fetchJSON(json: charactersJson)
                }

                afterEach {
                    subject = nil
                    characters = nil
                }

                it("first characters properties should be equal") {
                    guard let character = characters.first else {
                        fail()
                        return
                    }
                    subject = DetailsViewModel(character: character)
                    let url = URL(string: "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg")!
                    expect(subject.imageURL).to(equal(url))
                    expect(subject.name).to(equal("Walter White"))
                    let occupation = character.occupation.joined(separator: "\n")
                    expect(subject.occupation).to(equal(occupation))
                    expect(subject.status).to(equal("Status: Presumed dead"))
                    expect(subject.nickname).to(equal("Nickname: Heisenberg"))
                    expect(subject.seasonAppearance).to(equal("Season appearance: \n1, 2, 3, 4, 5"))
                }

                it("last movies properties should be equal") {
                    guard let expectedCharacter = characters.last else {
                        fail()
                        return
                    }
                    subject = DetailsViewModel(character: expectedCharacter)
                    let url = URL(string: "https://vignette.wikia.nocookie.net/breakingbad/images/9/95/JesseS5.jpg/revision/latest?cb=20120620012441")!
                    expect(subject.imageURL).to(equal(url))
                    expect(subject.name).to(equal("Jesse Pinkman"))
                    let occupation = expectedCharacter.occupation.joined(separator: "\n")
                    expect(subject.occupation).to(equal(occupation))
                    expect(subject.status).to(equal("Status: Alive"))
                    expect(subject.nickname).to(equal("Nickname: Cap n' Cook"))
                    expect(subject.seasonAppearance).to(equal("Season appearance: \n1, 2"))
                }
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

let charactersJson = """
[
  {
    "char_id": 1,
    "name": "Walter White",
    "birthday": "09-07-1958",
    "occupation": [
      "High School Chemistry Teacher",
      "Meth King Pin"
    ],
    "img": "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg",
    "status": "Presumed dead",
    "nickname": "Heisenberg",
    "appearance": [
      1,
      2,
      3,
      4,
      5
    ],
    "portrayed": "Bryan Cranston",
    "better_call_saul_appearance": []
  },
  {
    "char_id": 2,
    "name": "Jesse Pinkman",
    "birthday": "09-24-1984",
    "occupation": [
      "Meth Dealer"
    ],
    "img": "https://vignette.wikia.nocookie.net/breakingbad/images/9/95/JesseS5.jpg/revision/latest?cb=20120620012441",
    "status": "Alive",
    "nickname": "Cap n' Cook",
    "appearance": [
      1,
      2
    ],
    "portrayed": "Aaron Paul",
    "better_call_saul_appearance": []
  }
]
"""
