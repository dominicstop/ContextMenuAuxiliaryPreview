//
//  Experiment01ViewController.swift
//  
//
//  Created by Dominic Go on 11/4/23.
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


class Experiment01ViewController: UIViewController {

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
    
    let button: UIView = {
      let button = UIButton(frame: .zero);
      button.setTitle("Press Me", for: .normal);
      
      if #available(iOS 15.0, *) {
        button.configuration = .filled()
      };
      
      if #available(iOS 14.0, *) {
        button.showsMenuAsPrimaryAction = true;
        button.menu = {
          let shareAction = UIAction(
            title: "Share",
            image: UIImage(systemName: "square.and.arrow.up")
          ) { _ in
            // no-op
          };
            
          return UIMenu(title: "", children: [shareAction]);
        }();
      };
      
      return button;
    }();
      
    //button.translatesAutoresizingMaskIntoConstraints = false;
    stackView.addArrangedSubview(button);
    
    //NSLayoutConstraint.activate([
    //  box.widthAnchor.constraint(equalToConstant: 150),
    //  box.heightAnchor.constraint(equalToConstant: 150),
    //]);
    
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
};
