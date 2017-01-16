//
//  ViewController.swift
//  MultipleInfowindows-Swift
//
//  Created by eidan on 17/1/16.
//  Copyright © 2017年 AutoNavi. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,MAMapViewDelegate, AMapSearchDelegate{
    
    let KAPIKey = "dd622ce72744125b6b54199ad5d711e3"
    
    var mapView: MAMapView!         //地图
    var search: AMapSearchAPI!      // 地图内的搜索API类

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AMapServices.shared().apiKey = KAPIKey
        
        self.initMapViewAndSearch()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //初始化地图,和搜索API
    func initMapViewAndSearch() {
        self.mapView = MAMapView(frame: CGRect(x: CGFloat(0), y: CGFloat(64), width: CGFloat(self.view.bounds.size.width), height: CGFloat(self.view.bounds.size.height - 64)))
        self.mapView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.mapView.delegate = self
        self.view.addSubview(self.mapView)
        self.view.sendSubview(toBack: self.mapView)
        self.search = AMapSearchAPI()
        self.search.delegate = self
    }
    
    func searchPoiKeyword(_ keyword: String) {
        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = keyword
        request.city = "北京"
        request.offset = 20
        self.search.aMapPOIKeywordsSearch(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - AMapSearchDelegate
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        self.mapView .removeAnnotations(self.mapView.annotations)
        
        if response.pois.count == 0 {
            return;
        }
        
        var poiAnnotations = [POIAnnotation]()
        
        for (_, obj) in response.pois.enumerated() {
            
            let anno: POIAnnotation = POIAnnotation.init(poi: obj)
            poiAnnotations.append(anno)
            
        }
        
        /* 将结果以annotation的形式加载到地图上. */
        self.mapView.addAnnotations(poiAnnotations)
        
        if poiAnnotations.count == 1 { /* 如果只有一个结果，设置其为中心点. */
            self.mapView.setCenter(poiAnnotations[0].coordinate, animated: false)
        } else {
            self.mapView.showAnnotations(poiAnnotations, animated: false)
        }
        
    }
    
    // MARK: - MapViewDelegate
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        let poi: AMapPOI = (view.annotation as! POIAnnotation).poi
        print("poi:\(poi.name), address:\(poi.address)")
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: POIAnnotation.self) {
            
            //标注的view的初始化和复用
            let pointReuseIndetifier = "poiIdentifier"
            
            var poiAnnotationView: MAInfowindowView! = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAInfowindowView!
            
            if poiAnnotationView == nil {
                poiAnnotationView = MAInfowindowView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                poiAnnotationView!.canShowCallout = false
            }
            
            poiAnnotationView.giveTitleText(text: (annotation as! POIAnnotation).poi.name)
            
            return poiAnnotationView!
        }
        
        return nil
    }
    
    // MARK: - xib btn click
    
    @IBAction func start(_ sender: Any) {
        self.searchPoiKeyword("肯德基")
    }
    


}

