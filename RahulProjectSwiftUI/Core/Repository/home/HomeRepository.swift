//
//  HomeRepository.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 08/04/25.
//


///
 /***
  
       🔁 Data Flow (Correct)
              API
               ↓
              Repository
               ↓
              CoreDataManager.performBackgroundTask()
               ↓
              NSPersistentContainer
               ↓
              SwiftUI Environment (managedObjectContext)
               ↓
              @FetchRequest
               ↓
              UI auto-updates
  */

///

import Foundation
import CoreData

actor HomeRepository : HomeRepositoryProtocol {
    
    
   
    //static let shared = HomeRepository()
    private let coreDataManager: CoreDataManager
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol,
        coreDataManager: CoreDataManager = .shared) {
        self.apiService = apiService
        self.coreDataManager = coreDataManager
    }
    
    
    func getMealCategory() async throws -> CategoryResponse? {
        
        let customBaseURL = APIProvider.mealDBBaseURL + "categories.php"
        let response : CategoryResponse? = try await
        
        apiService.request(
            endpoint: "",
            method: .get,
            urlType: .custom(customBaseURL),
            headers: nil,
            body: nil,
            queryItems: nil
        )
        return response
    }
    
    
   
    func syncMealCategories() async throws {
        
        let customBaseURL = APIProvider.mealDBBaseURL + "categories.php"
        // Or use APIProvider
        
        // 1. Fetch from API
        let response: CategoryResponse = try await apiService.request(
            endpoint: "",
            method: .get,
            urlType: .custom(customBaseURL),
            headers: nil,
            body: nil,
            queryItems: nil
        )
        
        let categories = response.categories
        guard !categories.isEmpty else { return }
        
        // 2. Save to Core Data (Background Thread)
        // We use a 'Continuation' to make sure we wait for the save to finish
        await withCheckedContinuation { continuation in
            
            coreDataManager.performBackgroundTask { context in
                
                // Batch processing: Loop through API data
                for apiItem in categories {
                    // UPSERT LOGIC: Check if item exists
                    let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
                    request.predicate = NSPredicate(format: "idCategory == %@", apiItem.idCategory)
                    request.fetchLimit = 1
                    
                    let entity: CategoryEntity
                    
                    if let existing = try? context.fetch(request).first {
                        entity = existing // Update existing
                    } else {
                        entity = CategoryEntity(context: context) // Create new
                    }
                    
                    // Map Properties
                    entity.idCategory = apiItem.idCategory
                    entity.strCategory = apiItem.strCategory
                    entity.strCategoryThumb = apiItem.strCategoryThumb
                    entity.strCategoryDescription = apiItem.strCategoryDescription
                }
                
                // performBackgroundTask automatically saves changes
                continuation.resume()
            }
        }
    }
    
    
    
    func getMeals( category: String) async throws -> MealResponse {
        let url = APIProvider.mealDBBaseURL + "filter.php?c=\(category)"
        return try await apiService.request(
            endpoint: "",
            method: .get,
            urlType: .custom(url),
            headers: nil,
            body: nil,
            queryItems: nil
        )
    }
    
    func getMealDetails(byId id: String) async throws -> MealDetailResponse {
        let url = APIProvider.mealDBBaseURL + "lookup.php?i=\(id)"
        return try await apiService.request(
            endpoint: "",
            method: .get,
            urlType: .custom(url),
            headers: nil,
            body: nil,
            queryItems: nil
        )
    }

    
    func getFoodDetails() async throws -> DishCategoryResponse? {
      
       // let headers = ["token": Configuration.token]
        
        let customBaseURL = "https://yummie.glitch.me/dish-categories"
        let response : DishCategoryResponse = try await
        
        apiService.requestSimple(
            endpoint: "",
            method: .get,
            urlType: .custom(customBaseURL)
         
        )
        

        // Option 2: Provide all required parameters
                /*
                let customBaseURL = "https://yummie.glitch.me/dish-categories"
                return try await apiService.request(
                    endpoint: "",
                    method: .get,
                    urlType: .custom(customBaseURL),
                    headers: nil,
                    body: nil,
                    queryItems: nil
                )
                */
                
                // Option 3: Use external API request
                /*
                return try await apiService.requestExternalAPI(
                    url: "https://yummie.glitch.me/dish-categories",
                    method: .get,
                    headers: nil,
                    body: nil,
                    queryItems: nil
                )
                */
        return response
        
    }
    
    
    
    
}

