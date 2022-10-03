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
        let button = createButton(nil)
        button.setTitle("Add adress", for: .normal)
        button.addTarget(self, action: #selector(addAdressButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var routeButton: UIButton = {
        let button = createButton(false)
        button.setTitle("Route", for: .normal)
        button.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var resetButton: UIButton = {
        let button = createButton(false)
        button.setTitle("Reset", for: .normal)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()
    private var isAdressAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
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
    
    private func createButton(_ isEnabled: Bool?) -> UIButton {
        let button = UIButton()
        var color: UIColor = .red
        if let isEnabled = isEnabled {
            color = .lightGray
            button.isEnabled = isEnabled
        }
        button.setTitleColor(color, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 2
        return button
    }
    
    @objc private func addAdressButtonTapped(_ sender: UIButton) {
        print("add adress")
    }
    
    @objc private func resetButtonTapped(_ sender: UIButton) {
        print("reset")
    }
    
    @objc private func routeButtonTapped(_ sender: UIButton) {
        print("route")
    }
}
