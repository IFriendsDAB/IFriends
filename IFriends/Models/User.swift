//
//  User.swift
//  IFriends
//
//  Created by Barsha Chaudhary on 4/18/24.
//

import Foundation
import ParseSwift

struct User: ParseUser {

    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String: [String: String]?]?
    var lastPostedDate: Date?
    var fullname: String?
    var country: String?
    var profilePicture: ParseFile?

}
