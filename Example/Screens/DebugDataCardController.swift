//
//  DebugDataCardController.swift
//  ContextMenuAuxiliaryPreviewExample
//
//  Created by Dominic Go on 11/14/23.
//

import UIKit

class DebugDataCardViewController: UIViewController {

  enum DataEntry {
    case title(String);
    case labelDesc(label: String, desc: String);
    case body(String);
    case spacing(size: CGFloat);
  };
  
  weak var rootStack: UIStackView?;
  
  var debugData: [DataEntry] = [
  ];
  
  func updateViews(){
    guard let rootStack = self.rootStack else { return };
    
    rootStack.subviews.forEach {
      $0.removeFromSuperview();
    };
  
    self.debugData.forEach {
      switch $0 {
        case let .labelDesc(labelString, descString):
          let stack: UIStackView = {
            let stack = UIStackView();
            stack.axis = .horizontal;
            stack.spacing = 5;
            
            return stack;
          }();
          
          let label: UILabel = {
            let label = UILabel();
            label.text  = "\(labelString):";
            label.font = UIFont.boldSystemFont(ofSize: 14);
            
            return label;
          }();
          
          stack.addArrangedSubview(label);
          
          let desc: UILabel = {
            let label = UILabel();
            label.text  = descString;
            label.font = UIFont.systemFont(ofSize: 14);
            label.alpha = 0.75;
            
            return label;
          }();
          
          stack.addArrangedSubview(desc);
          rootStack.addArrangedSubview(stack);
        
        case let .title(title):
          let label = UILabel();
          label.text = title;
          label.font = UIFont.boldSystemFont(ofSize: 16);
          
          rootStack.addArrangedSubview(label);
          
        case let .body(bodyString):
          let label = UILabel();
          label.text = bodyString;
          label.font = UIFont.systemFont(ofSize: 14);
          
          rootStack.addArrangedSubview(label);
          
        case let .spacing(size):
          guard let prevView = rootStack.subviews.last else { return };
          rootStack.setCustomSpacing(size, after: prevView);
      };
    };
  };
  
  override func viewDidLoad() {
    super.viewDidLoad();
    
    self.view.backgroundColor = UIColor(
      hue: 0,
      saturation: 0,
      brightness: 0.95,
      alpha: 1
    );
    
    self.view.layer.cornerRadius = 10;
    
    let rootStack: UIStackView = {
      let stack = UIStackView();
      stack.axis = .vertical;
      stack.alignment = .leading;
      
      return stack;
    }();
    
    self.rootStack = rootStack;
    self.updateViews();
    
    rootStack.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(rootStack);
    
    let margins: CGFloat = 12;
    
    NSLayoutConstraint.activate([
      rootStack.topAnchor.constraint(
        equalTo: self.view.layoutMarginsGuide.topAnchor,
        constant: margins
      ),
      rootStack.leadingAnchor.constraint(
        equalTo: self.view.layoutMarginsGuide.leadingAnchor,
        constant: margins
      ),
      rootStack.trailingAnchor.constraint(
        equalTo: self.view.layoutMarginsGuide.trailingAnchor,
        constant: -margins
      ),
      rootStack.bottomAnchor.constraint(
        equalTo: self.view.layoutMarginsGuide.bottomAnchor,
        constant: -margins
      ),
      
      self.view.heightAnchor.constraint(
        equalTo: rootStack.heightAnchor,
        constant: margins * 2
      ),
    ]);
  };
};
