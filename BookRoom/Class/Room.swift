//
//  Room.swift
//  BookRoom
//
//  The Room class that store property of a room
//


public enum Sort {
    case Location
    case Capacity
    case Availability
    case Default
}

public class Room : Decodable {
    var name: String
    var capacity: String
    var level: String
    var availability: [String: String]
    var availabilityKeysSorted:[String]?
}


