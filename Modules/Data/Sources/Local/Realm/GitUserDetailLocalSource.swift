//
//  GitUserDetailLocalSource.swift
//  iOS MVVM
//
//  Created by Long Do on 31/12/2024.
//

import RealmSwift

public protocol GitUserDetailLocalSource {

    func getUserDetailByLogin(login: String) throws -> GitUserDetail?
    func upsert(userDetail: GitUserDetail)
}

public class GitUserDetailLocalSourceImpl: GitUserDetailLocalSource {
    public init() {}

    // Fetch the user detail by login
    public func getUserDetailByLogin(login: String) throws -> GitUserDetail? {
        let realm = try! Realm()
        // Retrieve the GitUserDetail object where login matches
        return realm.objects(GitUserDetail.self).filter("login == %@", login).first
    }

    // Save the user detail to the local database
    public func upsert(userDetail: GitUserDetail) {
        do {
            let realm = try! Realm()
            // Write to the Realm database
            try! realm.write {
                realm.add(userDetail, update: .modified)
            }
        } catch {
            #if DEBUG
                print("\(error)")
            #endif
        }
    }
}
