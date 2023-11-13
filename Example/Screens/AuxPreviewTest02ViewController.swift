//
//  AuxPreviewTest02ViewController.swift
//
//
//  Created by Dominic Go on 10/25/23.
//

import UIKit
import ContextMenuAuxiliaryPreview;


fileprivate class TestAuxiliaryPreviewView: UIView {

  var flag: Bool = false;
  
  override init(frame: CGRect) {
    super.init(frame: frame);
    
    let button = UIButton(frame: .zero);
    button.setTitle("Press Me", for: .normal);
    
    if #available(iOS 15.0, *) {
      button.configuration = .filled()
    };
    
    button.addTarget(self,
      action: #selector(Self.handleButtonPress(sender:)),
      for: .touchUpInside
    );
    
    button.translatesAutoresizingMaskIntoConstraints = false;
    self.addSubview(button);
    
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(
        equalTo: self.centerXAnchor
      ),
      button.centerYAnchor.constraint(
        equalTo: self.centerYAnchor
      ),
    ]);
    
    self.setBackgroundColor();
  };
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  };
  
  func setBackgroundColor(){
    self.backgroundColor = self.flag ? .blue : .red;
  };
  
  @objc func handleButtonPress(sender: UIButton){
    self.flag.toggle();
    self.setBackgroundColor();
  };
};


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
    
    let itemCount = 30;
    let itemCountMid = Int(itemCount / 2);
    
    for index in 0 ..< itemCountMid {
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
        menuTargetView: view
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
        transitionConfigEntrance: .customDelay(
          AuxiliaryPreviewTransitionAnimationConfig(
            delay: 0.25,
            animatorConfig: .presetCurve(duration: 0.3, curve: .easeInOut),
            transition: .init(transitionType: .zoomAndSlide())
          )
        ),
        transitionConfigExit: .init(transitionType: .fade)
      );
      
      return view;
    }();
    
    box.translatesAutoresizingMaskIntoConstraints = false;
    stackView.addArrangedSubview(box);
    
    NSLayoutConstraint.activate([
      box.widthAnchor.constraint(equalToConstant: 150),
      box.heightAnchor.constraint(equalToConstant: 150),
    ]);
    
    let showContextMenuButton: UIView = {
      let button = UIButton(frame: .zero);
      button.setTitle("Show Context Menu", for: .normal);
      
      if #available(iOS 15.0, *) {
        button.configuration = .filled()
      };
      
      button.addTarget(self,
        action: #selector(Self.onPressShowContextMenu(_:)),
        for: .touchUpInside
      );
      
      return button;
    }();
    
    stackView.addArrangedSubview(showContextMenuButton);
    
    let showAuxPreviewButton: UIView = {
      let button = UIButton(frame: .zero);
      button.setTitle("Show Aux. Preview", for: .normal);
      
      if #available(iOS 15.0, *) {
        button.configuration = .filled()
      };
      
      button.addTarget(self,
        action: #selector(Self.onPressShowAuxPreviewButton(_:)),
        for: .touchUpInside
      );
      
      return button;
    }();
    
    stackView.addArrangedSubview(showAuxPreviewButton);
    
    for index in itemCountMid...itemCount {
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
  
  @objc func onPressShowContextMenu(_ sender: UIButton){
    guard let interaction = self.interaction,
          let interactionWrapper = ContextMenuInteractionWrapper(objectToWrap: interaction)
    else { return };
    
    try? interactionWrapper.presentMenuAtLocation(point: .zero);
  };
  
  @objc func onPressShowAuxPreviewButton(_ sender: UIButton){
    guard let contextMenuManager = self.contextMenuManager else { return };
    
    contextMenuManager.showAuxiliaryPreviewAsPopover(
      presentingViewController: self
    );
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
  
  func onRequestMenuAuxiliaryPreview(
    sender: ContextMenuAuxiliaryPreview.ContextMenuManager
  ) -> UIView {
  
    let auxPreviewView = TestAuxiliaryPreviewView(frame: .zero);
    return auxPreviewView;
  };
};
