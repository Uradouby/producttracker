//
//  productTableViewController.swift
//  producttracker
//
//  Created by njuios on 2020/11/9.
//

import UIKit
import os.log
class productTableViewController: UITableViewController {
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedProducts = loadProducts() {
              products += savedProducts
          }
          else {
              // Load the sample data.
              loadSampleProducts()
          }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
            
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    private func loadProducts() -> [Product]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Product.ArchiveURL.path) as? [Product]
    }
    private func saveProducts() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(products, toFile: Product.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    private func loadSampleProducts() {
        
        let photo1 = UIImage(named: "p1")
        let photo2 = UIImage(named: "p2")
        let photo3 = UIImage(named: "p3")
        
        guard let product1 = Product(name: "p1", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate p1")
        }
        
        guard let product2 = Product(name: "p2", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate p2")
        }
        
        guard let product3 = Product(name: "p3", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate p3")
        }
        
        products += [product1, product2, product3]
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ProductTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? productTableViewCell  else {
                fatalError("The dequeued cell is not an instance of ProductTableViewCell.")
            }
            
            // Fetches the appropriate meal for the data source layout.
            let product = products[indexPath.row]
            
            cell.namelabel.text = product.name
            cell.photoimageview.image = product.photo
            cell.ratingcontrol.rating = product.rating
            
            return cell
    }
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ProductViewController, let product = sourceViewController.product {
               
               if let selectedIndexPath = tableView.indexPathForSelectedRow {
                   // Update an existing meal.
                   products[selectedIndexPath.row] = product
                   tableView.reloadRows(at: [selectedIndexPath], with: .none)
               }
               else {
                   // Add a new meal.
                   let newIndexPath = IndexPath(row: products.count, section: 0)
                   
                   products.append(product)
                   tableView.insertRows(at: [newIndexPath], with: .automatic)
               }
            saveProducts()
           }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let productDetailViewController = segue.destination as? ProductViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? productTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedProduct = products[indexPath.row]
            productDetailViewController.product = selectedProduct
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            products.remove(at: indexPath.row)
            saveProducts()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}
