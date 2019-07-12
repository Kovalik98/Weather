    //  TableViewController.swift
    //  WeatherPllug
    //
    //  Created by Nazar Kovalik on 6/21/19.
    //  Copyright © 2019 Nazar Kovalik. All rights reserved.
    //

    import Foundation
    import UIKit
    import Alamofire
    import SwiftyJSON
    import NVActivityIndicatorView
    import CoreLocation
    import CoreData

    class TableViewController: UITableViewController, CLLocationManagerDelegate {
        var searchName = String()
        var tempSearchName = Int()
        var mainSerch = String()
        var tempmaxSerch = Int()
        var tempminSerch = Int()
        var degree = 273
        var lonSerch = Double()
        var long = Double()
        
         var apiKey: String {
           return "94f2badf85210574354e4c6af49a382b"
        }
        var lat = Double()
        
        var activityIndicator: NVActivityIndicatorView!
        let locationManager = CLLocationManager()
         var posts = [Course]()
        override func viewDidLoad() {
            super.viewDidLoad()
            let indicatorSize: CGFloat = 70
            let indicatorFrame = CGRect( x: (view.frame.width-indicatorSize)/2,
            y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
            activityIndicator = NVActivityIndicatorView(frame: indicatorFrame,
            type: .lineScale, color: UIColor.white, padding: 20.0)
            view.addSubview(activityIndicator)
            locationManager.requestWhenInUseAuthorization()
            activityIndicator.startAnimating()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }
            self.tableView.reloadData()
        }

        func addCity() {
            let person1: Course = Course(jsonName: searchName, temp: tempSearchName,
            jsonDescription: mainSerch, tempmax: tempmaxSerch, tempmin: tempminSerch, lon: long, lat: lat)
            if person1.jsonName.count > 0 {
                posts.append(person1)
            }
        }
       //MARK: - PORTABLE DATACHANGE ON TSELSI
        @IBAction func  tselisi(_ sender: Any) {
            degree = 273
            self.tableView.reloadData()
        }
        //MARK: - PORTABLE DATACHANGE ON KELVIN
        @IBAction func kelvin(_ sender: Any) {
            degree = 0
            self.tableView.reloadData()
                    }
        //MARK: - TABLE VIEW
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return  posts.count 
        }
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")

            let mainid = cell?.viewWithTag(1) as! UILabel
            mainid.text = "\(String(posts[indexPath.row].temp - degree))°"
            let maintitle = cell?.viewWithTag(2) as! UILabel
            maintitle.text = posts[indexPath.row].jsonName
            return cell!
        }

        //MARK: - PORTABLE DATA ON VIEW CONTROLLER
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "View" {

                let indexPath = self.tableView.indexPathForSelectedRow?.row
                let vc = segue.destination as! ViewController
                vc.jsonName = posts[indexPath!].jsonName
                vc.templabel = "\(String(posts[indexPath!].temp - degree))°"
                vc.tempmax = "\(String(posts[indexPath!].tempmax - degree))°"
                vc.tempmin = "\(String(posts[indexPath!].tempmin - degree))°"
                vc.jsonDescription = posts[indexPath!].jsonDescription
                vc.change = degree
                vc.apiKey = apiKey
                vc.lat = posts[indexPath!].lat
                vc.long = posts[indexPath!].lon
                
            }
        }
    }    
