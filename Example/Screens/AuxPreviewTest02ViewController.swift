//
//  AuxPreviewTest02ViewController.swift
//
//
//  Created by Dominic Go on 10/25/23.
//

import UIKit
import ContextMenuAuxiliaryPreview;

class AuxPreviewTest02ViewController: UIViewController, ContextMenuManagerDelegate {

  var interaction: UIContextMenuInteraction?;
  
  var contextMenuManager: ContextMenuManager?;

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white;
    
    let stackView: UIStackView = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .fillProportionally;
      stack.alignment = .center;
      stack.spacing = 20;
                
      return stack;
    }();
    
    for index in 0...10 {
      let label = UILabel();
      
      label.text = "\(index)";
      label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5);
      label.font = .boldSystemFont(ofSize: 22);

      stackView.addArrangedSubview(label);
    };
    
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
      
      contextMenuManager.menuAuxPreviewConfig = AuxiliaryPreviewConfig(
        anchorPosition: .automatic,
        alignmentHorizontal: .previewCenter,
        auxiliaryPreviewPreferredWidth: .constant(100),
        auxiliaryPreviewPreferredHeight: .constant(100),
        auxiliaryPreviewMarginInner: 10,
        auxiliaryPreviewMarginOuter: 10,
        transitionConfigEntrance: .syncedToMenuEntranceTransition
      );
      
      return view;
    }();
    
    box.translatesAutoresizingMaskIntoConstraints = false;
    stackView.addArrangedSubview(box);
    
    NSLayoutConstraint.activate([
      box.widthAnchor.constraint(equalToConstant: 150),
      box.heightAnchor.constraint(equalToConstant: 150),
    ]);
    
    for index in 11...20 {
      let label = UILabel();
      
      label.text = "\(index)";
      label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5);
      label.font = .boldSystemFont(ofSize: 22);

      stackView.addArrangedSubview(label);
    };
    
    let scrollView: UIScrollView = {
      let scrollView = UIScrollView();
      
      scrollView.showsHorizontalScrollIndicator = false;
      scrollView.showsVerticalScrollIndicator = true;
      return scrollView
    }();
    
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    scrollView.addSubview(stackView);
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(
        equalTo: scrollView.topAnchor,
        constant: 40
      ),
      
      stackView.bottomAnchor.constraint(
        equalTo: scrollView.bottomAnchor,
        constant: -100
      ),
      
      stackView.centerXAnchor.constraint(
        equalTo: scrollView.centerXAnchor
      ),
    ]);
    
    scrollView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(scrollView);
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor     .constraint(equalTo: self.view.topAnchor     ),
      scrollView.bottomAnchor  .constraint(equalTo: self.view.bottomAnchor  ),
      scrollView.leadingAnchor .constraint(equalTo: self.view.leadingAnchor ),
      scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
    ]);
  };
};

extension AuxPreviewTest02ViewController: UIContextMenuInteractionDelegate {

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
