//
//  LocationListViewController.swift
//  WheatherMap
//
//  Created by Somsubhra Dasgupta on 12/04/21.
//  Copyright © 2021 Somsubhra. All rights reserved.
//

import UIKit

class LocationListViewController: UIViewController {

    @IBOutlet weak var locationListTableVIew: UITableView!
    
    
    var locatonList : [Location]!
    var clickedRow = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchLocationList()
    }
    
    
    func fetchLocationList()
    {
        self.locatonList = CoreDatamanager.shared.fetchAllLocationList()
        self.locationListTableVIew.reloadData()
    }
    
    @IBAction func deleteAllSavedLocations(_ sender: Any)
    {
        let alert = UIAlertController.init(title: "Alert", message: "This will delete all saved locaions.", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Delete", style: .default) { [weak self](UIAlertAction) in
            
            CoreDatamanager.shared.removeAllLocationDetails(using: self?.locatonList ?? [])
            self?.locatonList.removeAll()
            self?.locationListTableVIew.reloadData()
        }
        action.isEnabled = true
        alert.addAction(action)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.isEnabled = true
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationSegue = segue.destination as? WeatherViewController
        {
            destinationSegue.latitude = self.locatonList[self.clickedRow].location_latitude
            destinationSegue.longitude = self.locatonList[self.clickedRow].location_longitude
            if let loc = self.locatonList[self.clickedRow].location_name
            {
                destinationSegue.locationName = loc
            }
        }
        else if let destinationSegue = segue.destination as? AddLocationViewController
        {
            destinationSegue.delegate = self
        }
        
    }

}

extension LocationListViewController: UITableViewDelegate,UITableViewDataSource
{
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locatonList.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmark", for: indexPath)

        if let locationDetailsCell = cell as? LocationInfoCellView
        {
            let locationInfo = self.locatonList[indexPath.row]
            
            locationDetailsCell.location.text = locationInfo.location_name
            locationDetailsCell.locationLat.text = String(format: "%.6f", locationInfo.location_latitude)
            locationDetailsCell.locationLong.text = String(format: "%.6f", locationInfo.location_longitude)
            
            locationDetailsCell.deleteBookmark.addTarget(self, action: #selector(clickOnDeleteButton), for: .touchDown)
            locationDetailsCell.deleteBookmark.tag = indexPath.row
            
            return locationDetailsCell
        }
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.clickedRow = indexPath.row
        DispatchQueue.main.async{
            self.performSegue(withIdentifier: "toCityWeatherViewController", sender: self)
        }
    }
    
    @objc func clickOnDeleteButton(sender:Any)
    {
        if let deleteButton = sender as? UIButton
        {
            let indexToRemove = deleteButton.tag
            CoreDatamanager.shared.removeLocationDetails(using: self.locatonList[indexToRemove])
            self.fetchLocationList()
            
        }
        
    }
}

extension LocationListViewController : AddLocationViewControllerDelegate
{
    func reloadLocationList() {
        self.fetchLocationList()
    }
    
}

class LocationInfoCellView: UITableViewCell
{
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var locationLat: UILabel!
    @IBOutlet weak var locationLong: UILabel!
    @IBOutlet weak var deleteBookmark: UIButton!
}
