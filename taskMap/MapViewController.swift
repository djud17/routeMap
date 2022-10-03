//
//  ViewController.swift
//  taskMap
//
//  Created by Давид Тоноян  on 03.10.2022.
//

import UIKit
import MapKit
import CoreLocation
import SnapKit

final class MapViewController: UIViewController {
    private let mapView = MKMapView()
    private let navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let stackViewButton: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var addAdressButton: UIButton = {
        let button = createButton(isEnabled: true)
        button.setTitle("Add adress", for: .normal)
        button.addTarget(self, action: #selector(addAdressButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var routeButton: UIButton = {
        let button = createButton(isEnabled: false)
        button.setTitle("Route", for: .normal)
        button.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var resetButton: UIButton = {
        let button = createButton(isEnabled: false)
        button.setTitle("Reset", for: .normal)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()
    private var isAdressAdded = false {
        didSet {
            [routeButton, resetButton].forEach { enabledButton(button: $0, isEnabled: isAdressAdded) }
        }
    }
    private let alertController = AlertController.shared
    private var annotationsArray = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.addSubview(navigationView)
        navigationView.addSubview(stackViewButton)
        [addAdressButton, routeButton, resetButton].forEach{stackViewButton.addArrangedSubview($0)}
        
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        navigationView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
        }
        
        stackViewButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func createButton(isEnabled: Bool) -> UIButton {
        let button = UIButton()
        enabledButton(button: button, isEnabled: isEnabled)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        return button
    }
    
    private func enabledButton(button: UIButton, isEnabled: Bool) {
        let color: UIColor = isEnabled ? .red : .lightGray
        button.isEnabled = isEnabled
        button.setTitleColor(color, for: .normal)
        button.layer.borderColor = color.cgColor
    }
    
    @objc private func addAdressButtonTapped(_ sender: UIButton) {
        alertController.createAddAlertController(title: "Add",
                               placeholder: "Please type an adress") { [self] text in
            print(text)
            setupPlacemark(adressPlace: text)
        }
        present(alertController.addingAlertController, animated: true)
    }
    
    @objc private func resetButtonTapped(_ sender: UIButton) {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        annotationsArray.removeAll()
        isAdressAdded = false
    }
    
    @objc private func routeButtonTapped(_ sender: UIButton) {
        for index in 0..<annotationsArray.count - 1 {
            createDirectionRequest(startPoint: annotationsArray[index].coordinate,
                                   endPoint: annotationsArray[index + 1].coordinate)
        }
        mapView.showAnnotations(annotationsArray, animated: true)
    }
    
    private func setupPlacemark(adressPlace: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(adressPlace) { [self] (placemarks, error) in
            if let error = error {
                alertController.createErrorAlertController(title: "Error", message: "\(error.localizedDescription) - Please try again!")
                present(alertController.errorAlertController, animated: true)
            } else {
                guard let placemarks = placemarks else { return }
                let placemark = placemarks.first
                
                let annotation = MKPointAnnotation()
                annotation.title = adressPlace
                
                guard let placemarkLocation = placemark?.location else { return }
                annotation.coordinate = placemarkLocation.coordinate
                
                annotationsArray.append(annotation)
                
                if annotationsArray.count > 2 {
                    isAdressAdded = true
                }
                
                mapView.showAnnotations(annotationsArray, animated: true)
            }
        }
    }
    
    private func createDirectionRequest(startPoint: CLLocationCoordinate2D,
                                        endPoint: CLLocationCoordinate2D) {
        let startLocation = MKPlacemark(coordinate: startPoint)
        let destinationLocation = MKPlacemark(coordinate: endPoint)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destinationLocation)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        let direction = MKDirections(request: request)
        direction.calculate { [self] (response, error) in
            if let error = error {
                alertController.createErrorAlertController(title: "Error", message: "\(error.localizedDescription) - Please try again!")
                present(alertController.errorAlertController, animated: true)
            }
            
            guard let response = response else {
                alertController.createErrorAlertController(title: "Error", message: "Route is not acailable - Please try again!")
                present(alertController.errorAlertController, animated: true)
                return
            }
            
            var minimalRoute = response.routes[0]
            response.routes.forEach { route in
                if route.distance < minimalRoute.distance {
                    minimalRoute = route
                }
            }
            mapView.addOverlay(minimalRoute.polyline)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = .red
        return renderer
    }
}
