//
//  DatabaseHelper.swift
//  Password Manager
//
//  Created by Apple on 29/07/24.
//

import Foundation
import UIKit
import CoreData
class DatabaseHelper{
    let manageContex = (UIApplication.shared.delegate as! AppDelegate).persitentContainer.viewContext
    
    static var shared = DatabaseHelper()
    // MARK: - Entity
    private lazy var PasswordEntity: NSEntityDescription = {
        return NSEntityDescription.entity(forEntityName: "Password", in: manageContex)!
    }()
    // MARK: - Save Password Data
    public func savePasswordData(username: String, accountname: String, password: String, completion: @escaping (Bool) -> Void) {
        let fetchRequest: NSFetchRequest<Password> = Password.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username = %@", "\(username)")
    
        let dataModel = Password(entity: PasswordEntity, insertInto: manageContex)
        dataModel.id = "\(Int.random(in: 10000000...99999999))"
        dataModel.accountname = accountname
        dataModel.password = password
        dataModel.username = username
        do {
            try manageContex.save()
            print("FavoritePDF Successfully Added...")
            completion(true)
        } catch {
            print("Storing data Failed: \(error)")
            completion(false)
        }
    }
    // MARK: - Get Password Data
    public func getPasswordData(complition: @escaping ([Password]) -> Void){
        let historyFatch: NSFetchRequest<Password> = Password.fetchRequest()
        do {
            let results = try manageContex.fetch(historyFatch)
            complition(results)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    // MARK: - Delete Password Data
    public func deletePassword(id: String, complition: @escaping (Bool) -> Void) {
        let historyFatch: NSFetchRequest<Password> = Password.fetchRequest()
        historyFatch.predicate = NSPredicate(format: "id = %@", "\(id)")
        do {
            let fetchedResults =  try manageContex.fetch(historyFatch)
            for entity in fetchedResults {
                manageContex.delete(entity)
            }
            print("FavoritePDF Successfully Deleted...")
            try manageContex.save()
            complition(true)
        } catch {
            print("Could not delete. \(error)")
            complition(false)
        }
    }
    // MARK: - Edit Password Data
    public func editPassword(id: String,username: String, accountname: String, password: String, complition: @escaping (Bool) -> Void) {
        let historyFatch: NSFetchRequest<Password> = Password.fetchRequest()
        historyFatch.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        do {
            let dataModel = try manageContex.fetch(historyFatch)
            if dataModel.count != 0 {
                dataModel[0].accountname = accountname
                dataModel[0].password = password
                dataModel[0].username = username
            }
            try manageContex.save()
            print(dataModel)
            complition(true)
            
        } catch {
            print("Could not delete. \(error)")
            complition(false)
        }
    }
}
