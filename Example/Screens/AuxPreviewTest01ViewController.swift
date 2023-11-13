//
//  AuxPreviewTest01ViewController.swift
//  ContextMenuAuxiliaryPreviewExample
//
//  Created by Dominic Go on 10/7/23.
//

import UIKit
import ContextMenuAuxiliaryPreview

class AuxPreviewTest01ViewController: UIViewController, ContextMenuManagerDelegate {

  var interaction: UIContextMenuInteraction?;
  
  var contextMenuManager: ContextMenuManager?;

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white;
    
    let box: UIView = {
      let view = UIView();
      view.backgroundColor = .red;
      view.layer.cornerRadius = 10;
      
      let interaction = UIContextMenuInteraction(delegate: self);
      self.interaction = interaction;
      
      view.addInteraction(interaction);
      
      let contextMenuManager = ContextMenuManager(
        contextMenuInteraction: interaction,
        menuTargetView: self.view
      );
      
      self.contextMenuManager = contextMenuManager;
      contextMenuManager.delegate = self;
      
      contextMenuManager.auxiliaryPreviewConfig = AuxiliaryPreviewConfig(
        verticalAnchorPosition: .automatic,
        alignmentHorizontal: .targetCenter,
        preferredWidth: .constant(100),
        preferredHeight: .constant(100),
        marginInner: 10,
        marginOuter: 10,
        transitionConfigEntrance: .syncedToMenuEntranceTransition,
        transitionConfigExit: .init(transitionType: .fade)
      );

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
  
  func contextMenuInteraction(
    _ interaction: UIContextMenuInteraction,
    willDisplayMenuFor configuration: UIContextMenuConfiguration,
    animator: UIContextMenuInteractionAnimating?
  ) {
    
    self.contextMenuManager!.notifyOnContextMenuInteraction(
      interaction,
      willDisplayMenuFor: configuration,
      animator: animator
    );
  };
  
  func contextMenuInteraction(
    _ interaction: UIContextMenuInteraction,
    willEndFor configuration: UIContextMenuConfiguration,
    animator: UIContextMenuInteractionAnimating?
  ) {
    
    self.contextMenuManager!.notifyOnContextMenuInteraction(
      interaction,
      willEndFor: configuration,
      animator: animator
    );
  };
  
  func onRequestMenuAuxiliaryPreview(sender: ContextMenuAuxiliaryPreview.ContextMenuManager) -> UIView {
    let view = UIView(frame: .zero);
    view.backgroundColor = .red;
    
    return view;
  };
};
