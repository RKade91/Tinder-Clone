//
//  ContactsViewController.swift
//  ParseStarterProject
//
//  Created by Rohit Kumar on 2015-08-07.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ContactsViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

   
    var usernames = [String]()
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var query = PFUser.query()!
        query.whereKey("accepted", equalTo: PFUser.currentUser()!.objectId!) // we want the accepted array to include our current users id (this checks that they accepted us)
        query.whereKey("objectId", containedIn: PFUser.currentUser()?["accepted"] as! [String]) //checks if we accepted them
        
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
        
            if let results = results {
            
                for result in results as! [PFUser]{
                
                    self.usernames.append(result.username!)
                    
                    let imageFile = result["image"] as! PFFile
                    
                    imageFile.getDataInBackgroundWithBlock{
                        (imageData: NSData?, error: NSError?) -> Void in
                        
                        if error != nil {
                            
                            print(error)
                        } else {
                            
                            if let data = imageData {
                                
                                self.images.append(UIImage(data: data)!)
                                
                                self.tableView.reloadData()
                                
                            }
                            
                        }
                        
                        
                    }

                    
                }
                
                self.tableView.reloadData()
                
            }
        
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warni3g Incomplete implementation, return the number of rows
        return usernames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = usernames[indexPath.row]
        
        if images.count > indexPath.row { //if this is the case, the iamge we're loking for exists, if not dont load it
        
                cell.imageView?.image = images[indexPath.row]
        
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
