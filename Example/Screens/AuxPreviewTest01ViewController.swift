//
//  AuxPreviewTest01ViewController.swift
//  ContextMenuAuxiliaryPreviewExample
//
//  Created by Dominic Go on 10/7/23.
//

import UIKit

class AuxPreviewTest01ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white;
    
    let box: UIView = {
      let view = UIView();
      view.backgroundColor = .red;
      view.layer.cornerRadius = 10;
      
      let interaction = UIContextMenuInteraction(delegate: self);
      view.addInteraction(interaction);
      
      return view;
    }();
    
    box.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(box);
    
    NSLayoutConstraint.activate([
      box.centerXAnchor.constraint(
        equalTo: self.view.centerXAnchor
      ),
      box.centerYAnchor.constraint(
        equalTo: self.view.centerYAnchor
      ),
      box.widthAnchor.constraint(equalToConstant: 100),
      box.heightAnchor.constraint(equalToConstant: 100),
    ]);
  };
};

extension AuxPreviewTest01ViewController: UIContextMenuInteractionDelegate {
  func contextMenuInteraction(
    _ interaction: UIContextMenuInteraction,
    configurationForMenuAtLocation location: CGPoint
  ) -> UIContextMenuConfiguration? {
    
    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
      let shareAction = UIAction(
        title: "Share",
        image: UIImage(systemName: "square.and.arrow.up")
      ) { _ in
        // no-op
      };
      
      return UIMenu(title: "", children: [shareAction]);
    };
  };
};
