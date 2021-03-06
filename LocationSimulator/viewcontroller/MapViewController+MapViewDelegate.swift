//
//  MapViewController+MapViewDelegate.swift
//  LocationSimulator
//
//  Created by David Klopp on 18.08.19.
//  Copyright © 2019 David Klopp. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            fatalError("Could not cast overlay to MKPolyline.")
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = NSColor(calibratedRed: 0.0, green: 162.0/255.0, blue: 1.0, alpha: 1.0)
        //renderer.lineDashPattern = [0, 10]
        renderer.lineWidth = 8
        return renderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let pointAnnotation = annotation as? MKPointAnnotation, pointAnnotation == self.currentLocationMarker {
            var annotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: kAnnotationViewCurrentLocationIdentifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation,
                                                  reuseIdentifier: kAnnotationViewCurrentLocationIdentifier)
                annotationView!.image = #imageLiteral(resourceName: "UserLocation").resize(width: 24.0, height: 24.0)
                annotationView!.canShowCallout = true
                annotationView!.collisionMode = .circle
                annotationView!.isDraggable = true
                annotationView!.displayPriority = .required

                // add a drop shadow to the location marker
                let shadow = NSShadow()
                shadow.shadowColor = NSColor(calibratedWhite: 0.0, alpha: 0.6)
                shadow.shadowBlurRadius = 18.0
                shadow.shadowOffset = NSSize(width: 0.0, height: 0.0)
                annotationView!.shadow = shadow
            }

            annotationView?.annotation = pointAnnotation

            return annotationView
        }

        return nil
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending, let annotation = view.annotation {
            self.requestTeleportOrNavigation(toCoordinate: annotation.coordinate)
        }
    }
}
