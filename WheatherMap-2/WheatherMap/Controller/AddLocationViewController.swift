//
//  AddLocationViewController.swift
//  WheatherMap
//
//  Created by Somsubhra Dasgupta on 10/04/21.
//  Copyright © 2021 Somsubhra. All rights reserved.
//

import UIKit
import MapKit

protocol AddLocationViewControllerDelegate {
    func reloadLocationList()
}

class AddLocationViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    var delegate : AddLocationViewControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.addTapGestureToMapView()
    }
    
    func addTapGestureToMapView()
    {
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGesture(gestureRecognizer:)))
        gesture.numberOfTapsRequired = 1
        
        self.mapView.addGestureRecognizer(gesture)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func handleTapGesture(gestureRecognizer : UITapGestureRecognizer)
    {
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        let tappedPoint = gestureRecognizer.location(in: self.mapView)
        let tappedCoordinate = self.mapView.convert(tappedPoint, toCoordinateFrom: self.mapView)
        
        let annotation = CustomAnnotation(coordinate: tappedCoordinate, title: "Location")

        self.mapView.addAnnotation(annotation)
    }

    @IBAction func addLocation(_ sender: Any)
    {
        let alert = UIAlertController.init(title: "Add location title", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Add", style: .default) { [weak self](UIAlertAction) in
            
            if let textFields = alert.textFields,
                let textField = textFields[0] as? UITextField,
                let textFieldString = textField.text as? String
            {
                if let annotation = self?.mapView.annotations.first
                {
                    self?.updateLocalDatabaseAndUI(using: textFieldString, location_latitude: annotation.coordinate.latitude, location_longitude: annotation.coordinate.longitude)
                }

            }
            
        }
        action.isEnabled = true
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.isEnabled = true
            alertTextField.placeholder = "Type title here."
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func updateLocalDatabaseAndUI(using location_name:String, location_latitude: Double, location_longitude:Double)
    {
        CoreDatamanager.shared.addLocationDetails(using: location_name, location_latitude: location_latitude, location_longitude: location_longitude)
        self.navigationController?.popToViewController(self.delegate as! UIViewController, animated: true)
        self.delegate?.reloadLocationList()
    }
    
}

extension AddLocationViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      let identifier = "myGeotification"
      if annotation is CustomAnnotation {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotationView == nil {
          annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
          annotationView?.annotation = annotation
        }
        return annotationView
      }
      return nil
    }
}

class CustomAnnotation : NSObject,MKAnnotation
{
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate : CLLocationCoordinate2D, title : String) {
        self.coordinate = coordinate
        self.title = title
    }
    
}
