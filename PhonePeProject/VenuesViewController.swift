//
//  ViewController.swift
//  PhonePeProject
//
//  Created by LOVISH on 25/11/23.
//

import UIKit

class VenuesViewController: UIViewController, GetPlacesProtocolDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var distanceSlider: UISlider!
    
    var searchText = "" {
        didSet {
            // reset the venues list
            viewModel.places = []
            viewModel.currentPage = 0
            viewModel.getVenuesList(range: Int(distanceSlider.value), searchQuery: searchText)
            
        }
    }
    
    var viewModel = VenuesViewModel()
    var loader: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.retrieveCachedVenues()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loader = showLoader()
    }
    
    private func setup() {
        tableView.register(UINib.init(nibName: "VenueTableViewCell", bundle: nil), forCellReuseIdentifier: "VenueTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self
        LocationService.shared.getUpdatedLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute:  { [self] in
            self.viewModel.getVenuesList(range: Int(self.distanceSlider.value), searchQuery: self.searchText)
        })
    }
    
    @IBAction func onDistanceValueChange(_ sender: UISlider) {
        var newDistanceValue = Int(sender.value)
        // reset the venues list
        viewModel.places = []
        viewModel.currentPage = 0
        viewModel.getVenuesList(range: newDistanceValue, searchQuery: searchText)
    }
    
    
    func showNearbyPlaces(places: [Venue], isCachedData: Bool) {
        // clear cached data from places array when getting data from network call
        if !isCachedData && viewModel.currentPage == 1 {
            viewModel.places = []
        }
        // append new places in existing list and reload the view
        viewModel.places.append(contentsOf: places)
        DispatchQueue.main.async {
            self.stopLoader(loader: self.loader ?? UIAlertController())
            self.tableView.reloadData()
        }
        viewModel.saveVenuesToCache()
    }

}

extension VenuesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.places.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VenueTableViewCell", for: indexPath) as? VenueTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureUI(model: viewModel.places[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    // for pagination -> when user has scrolled to third last place, search for new places
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (viewModel.places.count ?? 0) - 3 {
        
            viewModel.getVenuesList(range: Int(distanceSlider.value), searchQuery: searchText)
            
        }
    }
}

extension VenuesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
}

extension VenuesViewController {
    func showLoader() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Loading", preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        indicator.style = .large
        alert.view.addSubview(indicator)
        present(alert, animated: true)
        return alert
    }
    
    func stopLoader(loader: UIAlertController) {
        DispatchQueue.main.async {
            loader.dismiss(animated: true)
        }
    }
 }

