import CoreData
import Foundation
import SwiftUI
import SDWebImageSwiftUI

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "LikedPhotos")
    static var shared = DataController()
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
//            print("Data saved successfully. WUHU!!!")
        } catch {
            // Handle errors in our database
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func delete(id: String){
        let fetchRequest =  NSFetchRequest<LikedPhoto>(entityName: "LikedPhoto")
    
        fetchRequest.predicate = NSPredicate(format: "id== %@", id)
        let objects = try! self.container.viewContext.fetch(fetchRequest)
        for obj in objects {
            self.container.viewContext.delete(obj)
        }
        
        do {
            try self.container.viewContext.save() // <- remember to put this :)
        } catch {
        }
    }
    
    func addPhoto(photo: PhotoFull, context: NSManagedObjectContext) {
        let new_photo = LikedPhoto(context: context)
        new_photo.id = photo.id
        new_photo.created_at = photo.created_at
        new_photo.added_at = Date()
        new_photo.username = photo.user?.username
        new_photo.country = photo.location?.country
        new_photo.city = photo.location?.city
        new_photo.downloads = Int32(photo.downloads ?? 0)
        new_photo.color = photo.id
        if (photo.location != nil && photo.location?.lat != nil && photo.location?.lon != nil) {
            new_photo.lon = photo.location!.lon!
            new_photo.lat = photo.location!.lat!
        }
        new_photo.raw_url = photo.raw
        new_photo.thumb_url = photo.thumb
        save(context: context)
    }
    
    func isLiked(id: String)-> Bool {
        let req = NSFetchRequest<LikedPhoto>(entityName: "LikedPhoto")
        req.predicate = NSPredicate(format: "id == %@", id)
        do {
            let fetch = try self.container.viewContext.fetch(req)
            if (fetch.isEmpty)
            {
                return false
            }
            else {
                return true
            }
        }
        catch  {
            return false
        }
    }
}
