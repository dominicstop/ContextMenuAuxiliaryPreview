//
//  Routes.swift
//  VisualEffectBlurViewExample
//
//  Created by Dominic Go on 10/7/23.
//

import UIKit

enum Route: CaseIterable {

  case auxPreviewTest01;
  case auxPreviewTest02;
  case experiment01;
  case experiment02;
  
  case auxPreviewBasicUsage01;

  var viewController: UIViewController {
    switch self {
      case .auxPreviewTest01:
        return AuxPreviewTest01ViewController();
        
      case .auxPreviewTest02:
        return AuxPreviewTest02ViewController();
        
      case .experiment01:
        return Experiment01ViewController();
        
      case .experiment02:
        return Experiment02ViewController();
        
      case .auxPreviewBasicUsage01:
        return AuxiliaryPreviewBasicUsage01Controller();
    };
  };
};

let RouteManagerShared = RouteManager.sharedInstance;

class RouteManager {
  static let sharedInstance = RouteManager();
  
  weak var window: UIWindow?;
  
  var routes: [Route] = Route.allCases;
  var routeCounter = 1;
  
  var currentRouteIndex: Int {
    self.routeCounter % self.routes.count;
  };
  
  var currentRoute: Route {
    self.routes[self.currentRouteIndex];
  };
  
  func applyCurrentRoute(){
    guard let window = self.window else { return };
  
    let nextVC = self.currentRoute.viewController;
    window.rootViewController = nextVC;
  };
  
  func nextRoute(){
    self.routeCounter += 1;
    self.applyCurrentRoute();
  };
};
