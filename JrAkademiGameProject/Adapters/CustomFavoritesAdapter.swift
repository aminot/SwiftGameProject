

//
//  customizeAdapter.swift
//  JrAkademiGameProject
//
//  Created by ufuk donmez on 5.06.2023.
//
import UIKit
import Carbon
import CoreData

class CustomFavoritesAdapter: UITableViewAdapter{
    weak var favoritesVC: FavoritesVC?
    // ... Your other code ...
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        // Implement your logic here
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedObjectContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            fetchRequest.predicate = NSPredicate(format: "id == %d", favoritesVC?.gameArray[indexPath.row].id ?? "")
            
            do {
                let results = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
                if let object = results.first {
                    managedObjectContext.delete(object)
                    try managedObjectContext.save()
                }
            } catch let error as NSError {
                print("Could not delete data: \(error), \(error.userInfo)")
            }
            favoritesVC?.getData()
            tableView.reloadData() // Update the table view after deletion
        }
    }
    /* Sola Kaydırma zımbırtısı */
    /*
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (action, view, completion) in
            // Perform your delete action here
            self?.tableView(tableView, commit: .delete, forRowAt: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
*/


}
