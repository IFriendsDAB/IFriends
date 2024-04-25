//
//  Comment.swift
//  IFriends
//
//  Created by Barsha Chaudhary on 4/25/24.
//

import Foundation
import ParseSwift

struct Comment: ParseObject {

    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?


    var comment: String?
    var user: User?
    var profilePicture: ParseFile?
    var post: Pointer<Post>?
}

