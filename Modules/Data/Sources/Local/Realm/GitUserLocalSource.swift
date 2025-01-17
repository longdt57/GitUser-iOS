//
//  GitUserLocalSource.swift
//  Git Users
//
//  Created by Long Do on 31/12/2024.
//

import RealmSwift

public protocol GitUserLocalSource {

    func getUsers(since: Int, perPage: Int) throws -> [GitUser]
    func upsert(users: [GitUser])
}

public class GitUserLocalSourceImpl: GitUserLocalSource {

    public init() {}

    public func getRealm() throws -> Realm {
        try! Realm()
    }

    public func getUsers(since: Int, perPage: Int) throws -> [GitUser] {
        let realm = try! getRealm()

        // Fetch all results sorted by 'id'
        let sortedResults = realm.objects(GitUser.self)
            .sorted(byKeyPath: "id")

        // Ensure the offset (since) is within bounds
        guard since < sortedResults.count else {
            return [] // Return empty if offset exceeds available results
        }

        // Calculate the range for pagination
        let startIndex = since
        let endIndex = min(startIndex + perPage, sortedResults.count)

        // Slice results
        let pagedResults = Array(sortedResults[startIndex ..< endIndex])

        return pagedResults
    }

    public func upsert(users: [GitUser]) {
        do {
            let realm = try getRealm()
            try! realm.write {
                for user in users {
                    realm.add(user, update: .modified)
                }
            }
        } catch {
            #if DEBUG
                print(error)
            #endif
        }
    }
}
