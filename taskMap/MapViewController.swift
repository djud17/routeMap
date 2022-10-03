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
        let button = createButton()
        button.setTitle("Add adress", for: .normal)
        return button
    }()
    private lazy var routeButton: UIButton = {
        let button = createButton()
        button.setTitle("Route", for: .normal)
        return button
    }()
    private lazy var resetButton: UIButton = {
        let button = createButton()
        button.setTitle("Reset", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(mapView)
        mapView.addSubview(navigationView)
        navigationView.addSubview(stackViewButton)
        stackViewButton.addArrangedSubview(addAdressButton)
        stackViewButton.addArrangedSubview(routeButton)
        stackViewButton.addArrangedSubview(resetButton)
        
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
    
    private func createButton() -> UIButton {
        let button = UIButton()
        button.setTitleColor(.red, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 2
        return button
    }
}
