//
//  DatabaseManager.swift
//  Messanger
//
//  Created by Rama Muhammad S on 31/05/22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    
    static let shared = DatabaseManager()
    
    private let db = Database.database().reference()
    
}

extension DatabaseManager{
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> Void)){
        db.child(email).observeSingleEvent(of: .value, with: {
            snapshot in
            guard snapshot.value as? String != nil else{
                completion(false)
                return
            }
            completion(true)
        })
        
    }
    
    public func insertUser(with user: ChatAppUser){
        db.child(user.emailAddress).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName])
    }
}
