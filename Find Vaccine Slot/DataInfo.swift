//
//  DataInfo.swift
//  Find Vaccine Slot
//
//  Created by Dev01 on 16/06/21.
//

import Foundation

struct DataInfo: Codable {
    let sessions: [Session]?
}

// MARK: - Session
struct Session: Codable,Identifiable {
    let id = UUID()
    let centerID: Int?
    let name, address, stateName, districtName: String?
    let blockName: String?
    let pincode: Int?
    let from, to: String?
    let lat, long: Int?
    let feeType, sessionID, date: String?
    let availableCapacityDose1, availableCapacityDose2, availableCapacity: Int?
    let fee: String?
    let minAgeLimit: Int?
    let vaccine: String?
    let slots: [String]?

    enum CodingKeys: String, CodingKey {
        case centerID = "center_id"
        case name, address
        case stateName = "state_name"
        case districtName = "district_name"
        case blockName = "block_name"
        case pincode, from, to, lat, long
        case feeType = "fee_type"
        case sessionID = "session_id"
        case date
        case availableCapacityDose1 = "available_capacity_dose1"
        case availableCapacityDose2 = "available_capacity_dose2"
        case availableCapacity = "available_capacity"
        case fee
        case minAgeLimit = "min_age_limit"
        case vaccine, slots
    }
}
