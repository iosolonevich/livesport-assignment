//
//  SearchResponseItem.swift
//  Livesport-assignment
//
//  Created by Alex Solonevich on 01.08.2023.
//

import Foundation

// MARK: - SearchResponseItem
struct SearchResponseItem: Decodable, Equatable, Identifiable, Hashable {
    let id, url: String
    let gender: Gender
    let name: String
    let type: TypeItem
    let participantTypes: [ParticipantTypeItem]?
    let sport: Sport
    let favouriteKey: FavouriteKey
    let flagID: Int?
    let defaultCountry: DefaultCountry
    let images: [ResponseImage]
    let teams: [Team]?
    let defaultTournament: DefaultTournament?

    enum CodingKeys: String, CodingKey {
        case id, url, gender, name, type, participantTypes, sport, favouriteKey
        case flagID = "flagId"
        case defaultCountry, images, teams, defaultTournament
    }
}

// MARK: - Gender
struct Gender: Decodable, Equatable, Hashable {
    let id: Int
    let name: GenderName
}

enum GenderName: String, Decodable, Equatable {
    case men = "Men"
    case women = "Women"
}

// MARK: - TypeItem
struct TypeItem: Decodable, Equatable, Hashable {
    let id: Int
    let name: TypeName
}

enum TypeName: String, Decodable, Equatable {
    case tournament = "TournamentTemplate"
    case team = "Team"
    case player = "Player"
    case playerInTeam = "PlayerInTeam"
}

// MARK: - ParticipantTypeItem
struct ParticipantTypeItem: Decodable, Equatable, Hashable {
    let id: Int
    let name: ParticipantTypeName
}

enum ParticipantTypeName: String, Decodable, Equatable {
    case tournament = "TournamentTemplate"
    case team = "Team"
    case player = "Player"
    case playerInTeam = "PlayerInTeam"
    case national = "National"
    
    case forward = "Forward"
    case midfielder = "Midfielder"
    case goalkeeper = "Goalkeeper"
    case defender = "Defender"
}


// MARK: - Sport
struct Sport: Decodable, Equatable, Hashable {
    let id: Int
    let name: SportName
}

enum SportName: String, Decodable, Equatable, CaseIterable {
    case soccer = "Soccer"
    case tennis = "Tennis"
    case basketball = "Basketball"
    case hockey = "Hockey"
    case americanFootball = "American football"
    case baseball = "Baseball"
    case handball = "Handball"
    case rugby = "Rugby Union"
    case floorball = "Floorball"
}

// MARK: - FavouriteKey
struct FavouriteKey: Decodable, Equatable, Hashable {
    let web, portable: String?
}

// MARK: - DefaultCountry
struct DefaultCountry: Decodable, Equatable, Hashable {
    let id: Int
    let name: String
}

// MARK: - Image
struct ResponseImage: Decodable, Equatable, Hashable {
    let path: String
    let usageID, variantTypeID: Int

    enum CodingKeys: String, CodingKey {
        case path
        case usageID = "usageId"
        case variantTypeID = "variantTypeId"
    }
}

// MARK: - Team
struct Team: Decodable, Equatable, Hashable, Identifiable {
    let id, name: String
    let kind: Kind
    let participantType: TeamParticipantType
}

enum Kind: String, Decodable, Equatable {
    case nomination = "NOMINATION"
    case team = "TEAM"
}

// MARK: - ParticipantType
struct TeamParticipantType: Decodable, Equatable, Hashable {
    let id: Int
    let name: TeamParticipantTypeName
}

enum TeamParticipantTypeName: String, Decodable, Equatable {
    case national = "National"
    case team = "Team"
}

// MARK: - DefaultTournament
struct DefaultTournament: Decodable, Equatable, Hashable {
    let id, name: String
    let stageWithStatsDataIDS: [String]

    enum CodingKeys: String, CodingKey {
        case id, name
        case stageWithStatsDataIDS = "stageWithStatsDataIds"
    }
}
