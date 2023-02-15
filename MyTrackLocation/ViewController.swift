//
//  ViewController.swift
//  MyTrackLocation
//
//  Created by Ade Fajr Ariav on 15/02/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var trackSwitch: UISwitch!
    
    // MARK: Inisialisasi Array MKPointAnnotion untuk menampung pin yang nantinya dimunculkan di MapView.
    private var locations: [MKPointAnnotation] = []
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        // Do any additional setup after loading the view.
    //    }
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
    
    // MARK: Menghidupkan dan mematikan Track Location.
    @IBAction func trackSwitch(_ sender: UISwitch) {
      if sender.isOn {
        locationManager.startUpdatingLocation()
      } else {
        locationManager.stopUpdatingLocation()
      }
    }
    
}


// MARK: Ini adalah implementasi dari CLLocationManagerDelegate.
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        
        // MARK: Mendapatkan lokasi terakhir pengguna.
        guard let mostRecentLocation = locations.last else { return }
        
        // MARK: Membuat variabel untuk menampung latitude dan longitude.
        let annotationToAdd = MKPointAnnotation()
        annotationToAdd.coordinate = mostRecentLocation.coordinate
        
        // MARK: Menambahkan lokasi terakhir ke array Locations.
        self.locations.append(annotationToAdd)
        
        // MARK: Ketika titik lebih dari 50 akan dihapus dari MapView
        while self.locations.count > 50 {
            if let annotationToRemove = self.locations.first {
                self.locations.remove(at: 0)
                mapView.removeAnnotation(annotationToRemove)
            }
        }
        
        // MARK: Memunculkan lokasi terakhir di MapView.
        mapView.showAnnotations(self.locations, animated: true)
        
        // MARK: Ketika Track Location berjalan di background akan mencetak informasi detailnya.
        if UIApplication.shared.applicationState == .background {
            print("Aplikasi dalam background state. Lokasi baru saat ini ", mostRecentLocation)
        }
    }
}
