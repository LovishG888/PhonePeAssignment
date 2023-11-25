//
//  VenuesViewModel.swift
//  PhonePeProject
//
//  Created by LOVISH on 25/11/23.
//

import Foundation

protocol GetPlacesProtocolDelegate {
    func showNearbyPlaces(places: [Venue], isCachedData: Bool)
}

class VenuesViewModel {
    var places: [Venue] = [Venue]()
    var delegate: GetPlacesProtocolDelegate?
    var currentPage: Int = 0
    var clientId = "Mzg0OTc0Njl8MTcwMDgxMTg5NC44MDk2NjY5"
    var pageLimit = 10
    
    
    func getVenuesList(range: Int, searchQuery: String) {
        currentPage = currentPage + 1
        let currentLat = LocationService.shared.currentLat ?? 12.971599
        let currentLng = LocationService.shared.currentLng ?? 77.594566
        guard let url = URL(string: "https://api.seatgeek.com/2/venues?per_page=10&page=\(currentPage)&client_id=\(clientId)&lat=\(currentLat)&lon=\(currentLng)&range=\(range)mi&q=\(searchQuery)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, reponse, error) in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let responseModel = try JSONDecoder().decode(VenuesResponse.self, from: data)
                self.delegate?.showNearbyPlaces(places: responseModel.venues, isCachedData: false)
            }catch {
                print("error")
            }
        }.resume()
    }
    
    func saveVenuesToCache() {
        do {
            let encodedData = try JSONEncoder().encode(places)
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedData, forKey: "venues")
        } catch {
            print(error)
        }
    }
    
    func retrieveCachedVenues() {
        let userDefaults = UserDefaults.standard
        if let savedData = userDefaults.object(forKey: "venues") as? Data {
            do{
                let savedVenues = try JSONDecoder().decode([Venue].self, from: savedData)
                self.delegate?.showNearbyPlaces(places: savedVenues, isCachedData: true)
            } catch {
                print(error)
            }
        }
    }
    
}
