//
//  ApiMock.swift
//  Livesport-assignment
//
//  Created by Alex Solonevich on 01.08.2023.
//

import Foundation

extension Array where Element == SearchResponseItem {
    static let mock = Self(
        [
            SearchResponseItem(
                id: "IoIhUqIN",
                url: "arthur-fils",
                gender: Gender(id: 1, name: .men),
                name: "Fils Arthur",
                type: TypeItem(id: 3, name: .player),
                participantTypes: [ParticipantTypeItem(id: 2, name: .player)],
                sport: Sport(id: 2, name: .tennis),
                favouriteKey: FavouriteKey(web: "2_IoIhUqIN", portable: "2_IoIhUqIN"),
                flagID: nil,
                defaultCountry: DefaultCountry(id: 77, name: "France"),
                images: [ResponseImage(path: "nZEq0gf5-YujFhJ2T.png", usageID: 3, variantTypeID: 15)],
                teams: [],
                defaultTournament: nil
            ),
            SearchResponseItem(
                id: "hA1Zm19f",
                url: "arsenal",
                gender: Gender(id: 1, name: .men),
                name: "Arsenal",
                type: TypeItem(id: 2, name: .team),
                participantTypes: [ParticipantTypeItem(id: 1, name: .team)],
                sport: Sport(id: 1, name: .soccer),
                favouriteKey: FavouriteKey(web: "1_hA1Zm19f", portable: "1_hA1Zm19f"),
                flagID: nil,
                defaultCountry: DefaultCountry(id: 198, name: "England"),
                images: [ResponseImage(path: "pfchdCg5-vcNAdtF9.png", usageID: 2, variantTypeID: 15)],
                teams: nil,
                defaultTournament: nil
            )
        ]
    )
}
