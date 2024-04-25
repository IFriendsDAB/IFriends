//
//  Message.swift
//  IFriends
//
//  Created by Amir Ince on 4/25/24.
//

import Foundation
import ParseSwift

struct Messages: ParseObject {

    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?


    var sender: String?
    var receiver: String?
    var message: String?
    
}
