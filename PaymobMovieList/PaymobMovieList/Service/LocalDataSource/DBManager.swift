//
//  DBManager.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

import CoreData
import UIKit
import Combine

final class DBManager {
    // MARK: - Properties
    
    static let shared = DBManager()
    
    private let container: NSPersistentContainer
    let favoritesDidChange = PassthroughSubject<Void, Never>()
    
    // MARK: - Initialization
    
    private init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to access AppDelegate")
        }
        self.container = appDelegate.persistentContainer
    }
    
    // MARK: - Public Methods
    
    func saveFavorite(movie: Movie) {
          guard let movieID = movie.id else {
              print("Movie ID is nil. Cannot save favorite.")
              return
          }
          
          performBackgroundTask { [weak self] context in
              do {
                  // Check if movie already exists
                  let predicate = NSPredicate(format: "id == %@", NSNumber(value: movieID))
                  let existingItems = try self?.fetchItems(with: predicate, in: context) ?? []
                  
                  if let existing = existingItems.first {
                      
                      self?.updateEntity(existing, from: movie)
                  } else {
                      
                      _ = self?.createEntity(from: movie, in: context)
                  }
                  
                  try context.save()
                  
                  self?.saveViewContext()
                  
                  self?.notifyFavoritesChanged()
                  
              } catch {
                  self?.handleError(error, operation: "saving favorite")
              }
          }
      }
    
    func deleteFavorite(movie: Movie) {
        guard let movieID = movie.id else {
            print("Movie ID is nil. Cannot delete favorite.")
            return
        }
        
        performBackgroundTask { [weak self] context in
            let predicate = NSPredicate(format: "id == %@", NSNumber(value: movieID))
            
            do {
                let itemsToDelete = try self?.fetchItems(with: predicate, in: context) ?? []
                
                for item in itemsToDelete {
                    context.delete(item)
                }
                
                try context.save()
                self?.saveViewContext()
                self?.notifyFavoritesChanged()
            } catch {
                self?.handleError(error, operation: "deleting favorite")
            }
        }
    }
    func fetchFavorites() -> [Item] {
        do {
            return try container.viewContext.fetch(Item.fetchRequest())
        } catch {
            handleError(error, operation: "fetching favorites")
            return []
        }
    }
    
    // MARK: - Private Methods
    
    private func performBackgroundTask(_ task: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask(task)
    }
    
    private func createEntity(from movie: Movie, in context: NSManagedObjectContext) -> Item {
          let entity = Item(context: context)
          updateEntity(entity, from: movie)
          return entity
      }
      
      private func updateEntity(_ entity: Item, from movie: Movie) {
          entity.id = Int32(movie.id ?? 0)
          entity.title = movie.title
          entity.overView = movie.overview
          entity.releaseDate = movie.releaseDate
          entity.voteCount = Int32(movie.voteCount)
          entity.image = movie.posterPath
          entity.backgroundImage = movie.backdropPath
          entity.genreIds = movie.genreIDS.map { String($0) }.joined(separator: ",")
          entity.isFavorite = movie.isFavorite
          entity.voteAverage = movie.voteAverage ?? 0.0
      }
    
    private func fetchItems(with predicate: NSPredicate, in context: NSManagedObjectContext) throws -> [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = predicate
        return try context.fetch(fetchRequest)
    }
    
    private func saveViewContext() {
           let viewContext = container.viewContext
           if viewContext.hasChanges {
               do {
                   try viewContext.save()
               } catch {
                   handleError(error, operation: "saving viewContext")
               }
           }
       }
    private func notifyFavoritesChanged() {
        DispatchQueue.main.async { [weak self] in
            self?.favoritesDidChange.send(())
        }
    }
    
    private func handleError(_ error: Error, operation: String) {
        #if DEBUG
        print("Error \(operation): \(error.localizedDescription)")
        #endif
    }
}
