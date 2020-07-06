
import UIKit
import XCTest

public class Room : Decodable {
    var name: String
    var capacity: String
    var level: String
    var availability: [String: String]
    var availabilityKeysSorted:[String]?
}


class RoomTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodingStandardType() {
        let json = """
        {
            "name": "Kopi-O",
            "capacity": "8",
            "level": "7",
            "availability": {
                "08:00": "1"
            }
        }
        """.data(using: .utf8)!
        
        let room = try! JSONDecoder().decode(Room.self, from: json)
        
        XCTAssertEqual(room.name, "Kopi-O")
        XCTAssertEqual(room.capacity, "8")
        XCTAssertEqual(room.level, "7")
        XCTAssertEqual(room.availability["08:00"], "1")
    }
    
    func testDecoding_whenMissingNamee_itThrows() throws {
        let json = """
               {
                   "name1": "Kopi-O",
                   "capacity": "8",
                   "level": "7",
                   "availability": {
                       "08:00": "1"
                   }
               }
               """.data(using: .utf8)!
        
        assertThrowsKeyNotFound("name", decoding: Room.self, from: json)
    }
    
    func assertThrowsKeyNotFound<T: Decodable>(_ expectedKey: String, decoding: T.Type, from data: Data) {
        XCTAssertThrowsError(try JSONDecoder().decode(decoding, from: data)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual(expectedKey, key.stringValue, "Expected missing key '\(key.stringValue)' to equal '\(expectedKey)'.")
            } else {
                XCTFail("Expected '.keyNotFound(\(expectedKey))' but got \(error)")
            }
        }
    }
    
    


}
