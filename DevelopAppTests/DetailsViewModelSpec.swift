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

enum JsonDecodingError: Error {
    case invalidFormat
}

class DetailsViewModelSpec: QuickSpec {
    var subject: DetailsViewModelType!
    var characters: [Character]!
    @LazyInjected var localDataFetcher: NetworkDataFetcherProtocol

    override func spec() {
        describe("fetch characters in ViewModel") {
            context("should get real data of list of characters") {
                beforeEach {
                    self.subject = DetailsViewModel()
                    TestDependencyGraph.registerLocalSerives()

                    self.localDataFetcher.fetchDetails { response in
                        switch response {
                        case let .success(characters):
                            self.characters = characters
                        case let .failure(error):
                            debugPrint(error.localizedDescription)
                        }
                    }
                }

                afterEach {
                    self.subject = nil
                }

                it("first characters properties should be equal") {
                    guard let character = self.characters.first else {
                        fail()
                        return
                    }
                    self.subject.character = character
                    let url = URL(string: "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg")!
                    expect(self.subject.imageURL).to(equal(url))
                    expect(self.subject.name).to(equal("Walter White"))
                    let occupation = character.occupation.joined(separator: "\n")
                    expect(self.subject.occupation).to(equal(occupation))
                    expect(self.subject.status).to(equal("Status: Presumed dead"))
                    expect(self.subject.nickname).to(equal("Nickname: Heisenberg"))
                    expect(self.subject.seasonAppearance).to(equal("Season appearance: \n1, 2, 3, 4, 5"))
                }

                it("last movies properties should be equal") {
                    guard let character = self.characters.last else {
                        fail()
                        return
                    }
                    self.subject.character = character
                    let url = URL(string: "https://vignette.wikia.nocookie.net/breakingbad/images/9/95/JesseS5.jpg/revision/latest?cb=20120620012441")!
                    expect(self.subject.imageURL).to(equal(url))
                    expect(self.subject.name).to(equal("Jesse Pinkman"))
                    let occupation = character.occupation.joined(separator: "\n")
                    expect(self.subject.occupation).to(equal(occupation))
                    expect(self.subject.status).to(equal("Status: Alive"))
                    expect(self.subject.status).to(equal("Status: Alive"))
                    expect(self.subject.nickname).to(equal("Nickname: Cap n' Cook"))
                    expect(self.subject.seasonAppearance).to(equal("Season appearance: \n1, 2"))
                }
            }
        }
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
    "category": "Breaking Bad",
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
    "category": "Breaking Bad",
    "better_call_saul_appearance": []
  }
]
"""
