//
//  Post.swift
//  IFriends
//
//  Created by Barsha Chaudhary on 4/18/24.
//

import Foundation
import ParseSwift

struct Post: ParseObject {

    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?


    var caption: String?
    var user: User?
    var imageFile: ParseFile?
    var profilePicture: ParseFile?
}
