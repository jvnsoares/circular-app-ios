//
//  ViewController.swift
//  circular
//
//  Created by Vitor Nunes on 29/12/17.
//  Copyright © 2017 Jose Soares. All rights reserved.
//

import UIKit
import GoogleMaps
import CocoaMQTT

class MapViewController: UIViewController{

    var mapView : GMSMapView?
    var circularMarkers : [Int:GMSMarker] = [:]
    var mQTTConnection : MQTTConnection?
    let circularRoute = RouteData()
    let circularStops = StopsData()

    override func viewDidLoad() {
        super.viewDidLoad()

        initGMap()
        drawStops()
        drawCircularPaths()

        mQTTConnection = MQTTConnection()
        //        updateMarker(latitude: -1.472107, longitude: -48.458738)
        mQTTConnection!.onReceive = updateCircularMarker
        mQTTConnection!.connect()
    }

    func drawStops(){
        for i in 0..<circularStops.stopsLocation.count{
            let marker = GMSMarker(position:
                CLLocationCoordinate2D(latitude: circularStops.stopsLocation[i]["latitude"]!,
                                       longitude:  circularStops.stopsLocation[i]["longitude"]!))
            marker.title = circularStops.stopsData[i]["title"]
            marker.snippet = circularStops.stopsData[i]["snippet"]
            marker.icon = GMSMarker.markerImage(with: .blue)
            marker.map = mapView
        }
    }

    func drawCircularPaths(){
        let firstPath = GMSPolyline(path: circularRoute.firstPath)
        let secondPath = GMSPolyline(path: circularRoute.secondPath)

        firstPath.strokeColor = .orange
        firstPath.strokeWidth = 1.5
        secondPath.strokeColor = .blue
        secondPath.strokeWidth = 2.5
        
        secondPath.map = mapView
        firstPath.map = mapView
    }

    func initGMap(){
        let camera = GMSCameraPosition.camera(withLatitude: -1.471588, longitude: -48.450289, zoom: 15.2)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView!.settings.myLocationButton = true
        mapView!.settings.zoomGestures = true
        mapView!.settings.compassButton = true
        mapView!.isMyLocationEnabled = false
        mapView!.settings.allowScrollGesturesDuringRotateOrZoom = true
        view = mapView
    }

    func updateCircularMarker(circularId : Int, latitude: Double, longitude: Double){
        let isIndexValid = self.circularMarkers[circularId] != nil
        if isIndexValid{
            self.circularMarkers[circularId]!.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.circularMarkers[circularId] = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            self.circularMarkers[circularId]!.icon = UIImage(named:"circularMarkerIcon")?.scaleToSize(aSize: CGSize(width: 35.0, height: 35.0))
        }
        self.circularMarkers[circularId]!.title = "Circular \(circularId)"
        self.circularMarkers[circularId]!.map = mapView
    }
}




