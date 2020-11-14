//
//  GoodsTableViewController.swift
//  ShoppingList
//
//  Created by nju on 2020/11/14.
//

import UIKit
import os.log

class GoodsTableViewController: UITableViewController {
    
    //商品仓库
    var storehouse = [Goods]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //左边按钮edit——对tableview里面的cell进行删除操作
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved goods, otherwise load sample data.
        if let savedGoods = loadGoods() {
            storehouse += savedGoods
        }
        else {
            print("Test Point 1")
            loadsampleGoods()
        }
    }
    
    private func loadGoods() -> [Goods]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Goods.ArchiveURL.path) as? [Goods]
    }
    
    private func loadsampleGoods() {
        let photo1 = UIImage(named: "p1")
        let photo2 = UIImage(named: "p2")
        let photo3 = UIImage(named: "p3")

        guard  let  goods1 = Goods(name: "p1", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate goods1")
        }
        guard let goods2 = Goods(name: "p2", photo: photo2, rating: 3) else {
            fatalError("Unable to instantiate goods2")
        }
        guard let goods3 = Goods(name: "p3", photo: photo3, rating: 4) else {
            fatalError("Unable to instantiate good3")
        }
        
        storehouse += [goods1,goods2,goods3]
    }
    
    private func saveGoods() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(storehouse, toFile: Goods.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Goods successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Goods...", log: OSLog.default, type: .error)
        }
    }
    
    
    //override some func to show storehous
    //1.返回stroehouse里面的数量
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storehouse.count;
    }
    
    //2.之后看一下什么意思吧
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
 
    //3.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //4.显示storehouse里面的商品
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "GoodsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GoodsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of GoodsTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let goods = storehouse[indexPath.row]
        
        cell.namelabel.text = goods.name
        cell.photoimage.image = goods.photo
        cell.ratingcontrol.rating = goods.rating
        
        return cell
    }
    
    //5.edit里的删除操作
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            storehouse.remove(at: indexPath.row)
            saveGoods()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            //Continue TODO
        }
    }
    
    
    
    //override some func to complete nevigator
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new goods.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let goodsDetailViewController = segue.destination as? GoodsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? GoodsTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = storehouse[indexPath.row]
            goodsDetailViewController.goods = selectedMeal
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    //action for what?
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? GoodsViewController, let goods = sourceViewController.goods {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                storehouse[selectedIndexPath.row] = goods
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: storehouse.count, section: 0)
                
                storehouse.append(goods)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the meals.
            saveGoods()
        }
    }
}

