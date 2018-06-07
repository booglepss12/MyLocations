//
//  FirstViewController.swift
//  MyLocations
//
//  Created by John Rooney on 2018-05-31.
//  Copyright © 2018 John Rooney. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var lattitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel:UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    let locationManager = CLLocationManager()
    var location:CLLocation?
    
    @IBAction func getLocation(){
        //get authorization for app to use GPS data
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
            return
        }
        if authStatus == .denied || authStatus == .restricted{
            showLocationServicesDeniedAlert()
            return
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    //alert if not using GPS data
    func showLocationServicesDeniedAlert(){
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please Enable location Services for this App in Settings", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated:  true, completion: nil)
    }
    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError, \(error)")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print ("didUpdateLocations \(newLocation)")
        location = newLocation
        updateLabels()
    }
    func updateLabels(){
        if let location = location{
            lattitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            tagButton.isHidden = false
            messageLabel.text = ""
        }else{
            lattitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
            messageLabel.text = "Tap 'Get My Location' to Start"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

