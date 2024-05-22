//
//  LovationPickerViewController.swift
//  Messenger
//
//  Created by Асанали Батырхан on 22.05.2024.
//

import UIKit
import CoreLocation
import MapKit

class LocationPickerViewController: UIViewController {
    
    public var completion: ((CLLocationCoordinate2D) -> Void)?
    private var coordinates: CLLocationCoordinate2D?
    private var isPickable = true
    private let map: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    init(coordinates: CLLocationCoordinate2D?) {
        self.coordinates = coordinates
        // to make map not pinnable
        self.isPickable = false
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isPickable {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send",
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(sendButtonTapped))
            let gesture = UITapGestureRecognizer(target: self,
                                              action: #selector(didTapMap(_:)))
            gesture.numberOfTouchesRequired = 1
            gesture.numberOfTapsRequired = 1
            map.addGestureRecognizer(gesture)
        }
        else {
            guard let coordinates = self.coordinates else {
                return
            }
            
            let pin = MKPointAnnotation()
            pin.coordinate = coordinates
            map.addAnnotation(pin)
        }
        view.backgroundColor = .systemBackground
        view.addSubview(map)
        map.isUserInteractionEnabled = true
    }
    
    @objc func sendButtonTapped() {
        guard let coordinates = self.coordinates else {
            return
        }
        navigationController?.popViewController(animated: true)
        completion?(coordinates)
        
    }
    
    @objc func didTapMap(_ gesture: UIGestureRecognizer) {
        let locationInView = gesture.location(in: map)
        let coordinates = map.convert(locationInView, toCoordinateFrom: map)
        self.coordinates = coordinates
        // drop a pin on that location
        
        // delete previous annotations before placing another one
        for annotation in map.annotations{
            map.removeAnnotation(annotation)
        }
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        map.addAnnotation(pin)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }

}
