//
//  ViewController.swift
//  MapTest
//
//  Created by 川村亮清 on 2017/03/10.
//  Copyright © 2017年 miraitranslate.com. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var lm: CLLocationManager!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    var mapView:MKMapView = MKMapView()
    
    var button1 : UIButton = UIButton()
    var button2 : UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocation()
        
//        mapView.delegate = self
//        mapView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(mapView)
//        
//        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
//        mapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
//        mapView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
//        mapView.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
//        
//        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
//        

    }
    
    internal func onClickTrackingButton(sender: UIButton){
        switch sender.tag {
        case 0:
            
                        var fromCoordinate: CLLocationCoordinate2D = mapView.centerCoordinate
                        fromCoordinate.latitude = latitude - 0.0025
                        fromCoordinate.longitude = longitude - 0.0025
            
            let distance = MKMetersBetweenMapPoints(MKMapPointForCoordinate(mapView.centerCoordinate),
                                                       MKMapPointForCoordinate(fromCoordinate))
            let altitude = (distance / tan(M_PI*(15/180.0)))
            let camera = MKMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: distance, pitch: CGFloat(altitude), heading: mapView.camera.heading)
                        
            print("1 + " + String(mapView.camera.altitude))
                        camera.altitude = mapView.camera.altitude - 100
                        mapView.setCamera(camera, animated: true)
            // mapView.camera.pitch = 70.0
            print("2 + " + String(mapView.camera.altitude))
        case 1:
            
            var fromCoordinate: CLLocationCoordinate2D = mapView.centerCoordinate
            fromCoordinate.latitude = latitude - 0.0025
            fromCoordinate.longitude = longitude - 0.0025
            
            let distance = MKMetersBetweenMapPoints(MKMapPointForCoordinate(mapView.centerCoordinate),
                                                    MKMapPointForCoordinate(fromCoordinate))
            let altitude = (distance / tan(M_PI*(15/180.0)))
            let camera = MKMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: distance, pitch: CGFloat(altitude), heading: mapView.camera.heading)
            
            
            print("1 - " + String(mapView.camera.altitude))
            camera.altitude = mapView.camera.altitude + 100
            mapView.setCamera(camera, animated: true)
            print("2 - " + String(mapView.camera.altitude))
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func initLocation(){
        // フィールドの初期化
        lm = CLLocationManager()
        
        // CLLocationManagerをDelegateに指定
        lm.delegate = self
        
        lm.requestAlwaysAuthorization()
        let status = CLLocationManager.authorizationStatus()
        
        switch status{
        case .restricted, .denied:
            break
        case .notDetermined:
            if (lm.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization))){
                // 精度の指定
                lm.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                // 位置情報取得の開始
                lm.startUpdatingLocation()
            }else{
                lm.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                lm.startUpdatingLocation()
            }
            
            longitude = CLLocationDegrees()
            latitude = CLLocationDegrees()
            
            NSLog("initial latiitude: \(latitude) , longitude: \(longitude)")
            
            // 位置情報の精度を指定．任意，
            // lm.desiredAccuracy = kCLLocationAccuracyBest
            // 位置情報取得間隔を指定．指定した値（メートル）移動したら位置情報を更新する．任意．
            lm.distanceFilter = 1000
            
        case .authorizedWhenInUse, .authorizedAlways:
            
            longitude = CLLocationDegrees()
            latitude = CLLocationDegrees()
            
            NSLog("initial latiitude: \(latitude) , longitude: \(longitude)")
            
            // 位置情報の精度を指定．任意，
            lm.desiredAccuracy = kCLLocationAccuracyBest
            // 位置情報取得間隔を指定．指定した値（メートル）移動したら位置情報を更新する．任意．
            // lm.distanceFilter = 1000
            
            // 従来の位置情報追跡リクエストの方法
            // lm.startUpdatingLocation()
            lm.requestLocation()
            // 方角も更新
            // 5度動いたらイベント起動
//            lm.headingFilter = 5.0
//            lm.startUpdatingHeading()
        }
    }
    
    var isInit = true
    var isInit3 = true
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        if(isInit){
            isInit = false
        // scale setting
//        var region:MKCoordinateRegion = mapView.region
//        // region.center = location
//        region.span.latitudeDelta = 0.005
//        region.span.longitudeDelta = 0.005
//        
//        mapView.setRegion(region, animated:false)
        mapView.setCenter((locations.last?.coordinate)!, animated: false)
            let fromCoordinate: CLLocationCoordinate2D = mapView.centerCoordinate
            let newAltitude = 100.0
            let camera : MKMapCamera = MKMapCamera(lookingAtCenter: mapView.centerCoordinate, fromEyeCoordinate: fromCoordinate, eyeAltitude: newAltitude)
            camera.pitch = 70.0
            mapView.setCamera(camera, animated: false)
        
        
                mapView.delegate = self
                mapView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mapView)
                mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
                mapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
                mapView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                mapView.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
            
            mapView.showsScale = true
            
            let userFollowWithHeadingButtonRect = CGRect(x: self.view.frame.maxX - 50, y: self.view.frame.maxY - 50, width: 30, height: 30)
            button1 = UIButton(frame: userFollowWithHeadingButtonRect)
            button1.setTitleColor(UIColor.black, for: .normal)
            button1.backgroundColor = UIColor.white
            button1.setTitle("+", for: .normal)
            button1.addTarget(self, action: #selector(onClickTrackingButton(sender:)), for: .touchUpInside)
            button1.tag = 0
            self.view.addSubview(button1)
            
            let userFollowWithHeadingButtonRect2 = CGRect(x: self.view.frame.maxX - 50, y: self.view.frame.maxY - 25, width: 30, height: 30)
            button2 = UIButton(frame: userFollowWithHeadingButtonRect2)
            button2.setTitleColor(UIColor.black, for: .normal)
            button2.backgroundColor = UIColor.white
            button2.setTitle("-", for: .normal)
            button2.addTarget(self, action: #selector(onClickTrackingButton(sender:)), for: .touchUpInside)
            button2.tag = 1
            self.view.addSubview(button2)
        }
        

    }
    
    var isInit2 = true
    func mapView(_ mapView: MKMapView,
                 regionDidChangeAnimated animated: Bool){
        if(isInit2){
        isInit2 = false
            print("regionDidChangeAnimated")
            lm.startUpdatingLocation()
            lm.startUpdatingHeading()
            mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failure")
    }
    
    
        func mapView(_ mapView: MKMapView,
                     didChange mode: MKUserTrackingMode,
                     animated: Bool){
            print("didChange")
            switch mode.rawValue {
            case MKUserTrackingMode.follow.rawValue:
                print("follow")
            case MKUserTrackingMode.followWithHeading.rawValue:
                print("followWithHeading")
            case MKUserTrackingMode.none.rawValue:
                print("none")
                if(!animated){
                    //mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: false)
                }
            default:
                print("default")
            }
            
        }
}

