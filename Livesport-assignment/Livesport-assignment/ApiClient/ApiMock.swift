//
//  ApiMock.swift
//  Livesport-assignment
//
//  Created by Alex Solonevich on 01.08.2023.
//

import Foundation

extension SearchResponseItem {
    static let mock = Self(
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
    )
}
