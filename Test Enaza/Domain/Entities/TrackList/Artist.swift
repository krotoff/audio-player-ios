//
//  Artist.swift
//  Test Enaza
//
//  Created by Andrew Krotov on 16/04/2019.
//  Copyright © 2019 Andrew Krotov. All rights reserved.
//

public struct Artist: Codable {
    var id: String
    var name: String
    
    public enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
