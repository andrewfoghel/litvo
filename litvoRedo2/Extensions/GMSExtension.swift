//
//  GMSExtension.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/15/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit
import GooglePlaces

extension SetEventVC: GMSAutocompleteViewControllerDelegate {
        
        // Handle the user's selection.
        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            name = place.name
            locationTextField.text = place.name
            address = place.formattedAddress
            loadFirstPhoto(placeId: place.placeID)
            dismiss(animated: true, completion: nil)
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            // TODO: handle the error.
            print("Error: \(error)")
            dismiss(animated: true, completion: nil)
        }
        
        // User cancelled the operation.
        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            print("Autocomplete was cancelled.")
            dismiss(animated: true, completion: nil)
        }
    
    func loadFirstPhoto(placeId: String){
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeId) { (photos, error) in
            if let err = error{
                appDelegate.errorView(message: err.localizedDescription, color: colorSmoothRed)
                print(err.localizedDescription)
                return
            }
            if let firstPhotoMetadata = photos?.results.first{
                self.loadImageForMetaData(photoMetaData: firstPhotoMetadata)
            }
        }
    }
    
    func loadImageForMetaData(photoMetaData: GMSPlacePhotoMetadata){
        GMSPlacesClient.shared().loadPlacePhoto(photoMetaData) { (image, error) in
            if let err = error{
                appDelegate.errorView(message: err.localizedDescription, color: colorSmoothRed)
                print(err.localizedDescription)
                return
            }
            self.addPhotoBtn.image = image
            self.addPhotoBtn.layer.cornerRadius = self.addPhotoBtn.frame.height/2
        }
    }
    
}

