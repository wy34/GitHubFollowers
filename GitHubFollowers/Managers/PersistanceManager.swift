//
//  PersistanceManager.swift
//  GitHubFollowers
//
//  Created by William Yeung on 3/23/21.
//

import Foundation

enum PersistanceActionType {
    case add
    case remove
}

enum PersistanceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Follower, actionType: PersistanceActionType, completed: @escaping (GFError?) -> ()) {
        retrieveFavorites { (result) in
            switch result {
                case .success(let favorites):
                    var retrievedFavorites = favorites
                    
                    switch actionType {
                        case .add:
                            guard !retrievedFavorites.contains(favorite) else { completed(.alreadyInFavorites); return }
                            retrievedFavorites.append(favorite)
                        case .remove:
                            retrievedFavorites.removeAll { $0.login == favorite.login }
                            print(retrievedFavorites)
                    }
                    
                    completed(save(favorites: retrievedFavorites))
                case .failure(let error):
                    completed(error)
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> ()) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else { completed(.success([])); return }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToComplete))
        }
    }
    
    static func save(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.setValue(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return GFError.unableToFavorite
        }
    }
}
