//
//  ContextMenuManager.swift
//  
//
//  Created by Dominic Go on 10/7/23.
//

import UIKit



struct AuxiliaryPreviewTransitionKeyframe {
  var opacity: CGFloat;
};

struct AuxiliaryPreviewTransitionConfig {
  var keyframeStart: AuxiliaryPreviewTransitionKeyframe;
  var keyframeEnd: AuxiliaryPreviewTransitionKeyframe;
};


class AuxiliaryRootView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame);
    
    self.backgroundColor = .red;
  };
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  };
};


public class ContextMenuManager {

  static weak var auxPreview: AuxiliaryRootView?;
  
  // MARK: - Properties
  // ------------------
  
  public var menuAuxPreviewConfig: ContextMenuAuxiliaryPreviewConfig?;
  var contextMenuMetadata: ContextMenuMetadata?;
  
  public var isAuxiliaryPreviewEnabled = false;
  
  public var isContextMenuVisible = false;
  public var isAuxPreviewVisible = false;
  
  // temp
  lazy var menuAuxiliaryPreviewView: AuxiliaryRootView? = {
    let view = AuxiliaryRootView(frame: .init(
      origin: .zero,
      size: .init(
        width: 100,
        height: 100
      )
    ));
    
    return view;
  }();
  
  // MARK: - Properties - References
  // -------------------------------
  
  /// A reference to the view that contains the context menu interaction
  public weak var menuTargetView: UIView?;
  
  /// A reference to the `UIContextMenuInteraction` interaction config that
  /// the `targetView` is using
  public weak var contextMenuInteraction: UIContextMenuInteraction?;
  
  /// A reference to the view controller that contains the custom context menu
  /// preview that will be used when the menu is shown
  public weak var menuCustomPreviewController: UIViewController?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  /// Gets the `_UIContextMenuContainerView` that's holding the context menu
  /// controls.
  ///
  /// **Note**: This `UIView` instance  only exists whenever there's a
  /// context menu interaction.
  ///
  var contextMenuContainerViewWrapper: ContextMenuContainerViewWrapper? {
    guard let targetView = self.menuTargetView,
          let window = targetView.window
    else { return nil };
    
    return window.subviews.reduce(nil) { (prev, subview) in
      prev ?? ContextMenuContainerViewWrapper(objectToWrap: subview);
    };
  };
  
  var isUsingCustomMenuPreview: Bool {
    self.menuCustomPreviewController != nil
  };
  
  // MARK: - Init
  // ------------
  
  public init(
    contextMenuInteraction: UIContextMenuInteraction,
    menuTargetView: UIView
  ) {
    self.contextMenuInteraction = contextMenuInteraction;
    self.menuTargetView = menuTargetView;
  };
  
  // MARK: - Internal Functions
  // --------------------------
  
  // MARK: Experimental - "Auxiliary Context Menu Preview"-Related
  func attachContextMenuAuxiliaryPreviewIfAny(
    _ animator: UIContextMenuInteractionAnimating!
  ){
  
    // animator.previewViewController
  
    guard let menuAuxPreviewConfig = self.menuAuxPreviewConfig,
          let contextMenuMetadata = ContextMenuMetadata(manager: self),
          let auxPreviewTargetView = contextMenuMetadata.auxPreviewTargetView,
          
          // get the wrapper for the root view that hold the context menu
          let menuAuxiliaryPreviewView = self.menuAuxiliaryPreviewView,
          
          let morphingPlatterView =
            contextMenuMetadata.morphingPlatterViewWrapper.wrappedObject,
            
          let contextMenuContainerView =
            contextMenuMetadata.contextMenuContainerViewWrapper.wrappedObject
    else { return };

    // MARK: Set Layout
    // ----------------
    
    // Bugfix: Stop bubbling touch events from propagating to parent
    menuAuxiliaryPreviewView.addGestureRecognizer(
      UITapGestureRecognizer(target: nil, action: nil)
    );
    
    /// manually set size of aux. preview
    menuAuxiliaryPreviewView.bounds = .init(
      origin: .zero,
      size: contextMenuMetadata.auxiliaryPreviewViewSize
    );
    
    let attachAuxPreviewBlock = {
      let test = UIView(frame: .init(origin: .zero, size: .init(width: 200, height: 200)));
      test.backgroundColor = .blue;
      test.translatesAutoresizingMaskIntoConstraints = false;
      auxPreviewTargetView.addSubview(test);
      
      NSLayoutConstraint.activate([
        test.bottomAnchor.constraint(equalTo: auxPreviewTargetView.bottomAnchor),
        test.widthAnchor.constraint(equalToConstant: 100),
        test.heightAnchor.constraint(equalToConstant: 100),
      ]);
    
      /// enable auto layout
      menuAuxiliaryPreviewView.translatesAutoresizingMaskIntoConstraints = false;
      
      /// attach `auxiliaryView` to context menu preview
      auxPreviewTargetView.addSubview(menuAuxiliaryPreviewView);
      
      // set layout constraints based on config
      NSLayoutConstraint.activate({
        
        // set initial constraints
        var constraints: Array<NSLayoutConstraint> = [
          // set aux preview height
          menuAuxiliaryPreviewView.heightAnchor.constraint(
            equalToConstant: contextMenuMetadata.auxiliaryViewHeight
          ),
        ];
        
        // set vertical alignment constraint - i.e. either...
        constraints.append({
          if contextMenuMetadata.shouldAttachAuxPreviewToTop {
            // A - pin to top or...
            return menuAuxiliaryPreviewView.bottomAnchor.constraint(
             equalTo: morphingPlatterView.topAnchor,
             constant: -contextMenuMetadata.marginInner
            );
          };
          
          // B - pin to bottom.
          return menuAuxiliaryPreviewView.topAnchor.constraint(
            equalTo: morphingPlatterView.bottomAnchor,
            constant: contextMenuMetadata.marginInner
          );
        }());
        
        // set horizontal alignment constraints based on config...
        constraints += {
          switch menuAuxPreviewConfig.alignmentHorizontal {
            // A - pin to left
            case .previewLeading: return [
              menuAuxiliaryPreviewView.leadingAnchor.constraint(
                equalTo: morphingPlatterView.leadingAnchor
              ),
              
              menuAuxiliaryPreviewView.widthAnchor.constraint(
                equalToConstant: contextMenuMetadata.auxiliaryViewWidth
              ),
            ];
              
            // B - pin to right
            case .previewTrailing: return [
              menuAuxiliaryPreviewView.rightAnchor.constraint(
                equalTo: morphingPlatterView.rightAnchor
              ),
              
              menuAuxiliaryPreviewView.widthAnchor.constraint(
                equalToConstant: contextMenuMetadata.auxiliaryViewWidth
              ),
            ];
              
            // C - pin to center
            case .previewCenter: return [
              menuAuxiliaryPreviewView.centerXAnchor.constraint(
                equalTo: morphingPlatterView.centerXAnchor
              ),
              
              menuAuxiliaryPreviewView.widthAnchor.constraint(
                equalToConstant: contextMenuMetadata.auxiliaryViewWidth
              ),
            ];
              
            // D - match preview size
            case .stretchPreview: return [
              menuAuxiliaryPreviewView.leadingAnchor
                .constraint(equalTo: morphingPlatterView.leadingAnchor),
              
              menuAuxiliaryPreviewView.trailingAnchor
                .constraint(equalTo: morphingPlatterView.trailingAnchor),
            ];
            
            // E - stretch to edges of screen
            case .stretchScreen: return [
              menuAuxiliaryPreviewView.leadingAnchor.constraint(
                equalTo: contextMenuContainerView.leadingAnchor
              ),
              
              menuAuxiliaryPreviewView.trailingAnchor.constraint(
                equalTo: contextMenuContainerView.trailingAnchor
              ),
            ];
          };
        }();
        
        return constraints;
      }());
    };
    
    self.contextMenuMetadata = contextMenuMetadata;
    
    //  MARK: Show Aux. View - Prep
    // ----------------------------
    
    let transitionConfigEntrance = menuAuxPreviewConfig.transitionConfigEntrance;

    // closures to set the start/end values for the entrance transition
    let (setTransitionStateStart, setTransitionStateEnd): (() -> (), () -> ()) = {
      var transform = menuAuxiliaryPreviewView.transform;
      
      let setTransformForTransitionSlideStart = { (yOffset: CGFloat) in
        switch contextMenuMetadata.morphingPlatterViewPlacement {
          case .top:
            transform = transform.translatedBy(x: 0, y: -yOffset);
            
          case .bottom:
            transform = transform.translatedBy(x: 0, y: yOffset);
        };
      };
      
      let setTransformForTransitionZoomStart = { (scaleOffset: CGFloat) in
        let scale = 1 - scaleOffset;
        transform = transform.scaledBy(x: scale, y: scale);
      };
      
      switch menuAuxPreviewConfig.transitionConfigEntrance.transition {
        case .fade: return ({
          // A - fade - entrance transition
          menuAuxiliaryPreviewView.alpha = 0;
          
        }, {
          // B - fade - exit transition
          menuAuxiliaryPreviewView.alpha = 1;
        });
          
        case let .slide(slideOffset): return ({
          // A - slide - entrance transition
          // fade - start
          menuAuxiliaryPreviewView.alpha = 0;
          
          // slide - start
          setTransformForTransitionSlideStart(slideOffset);
          
          // apply transform
          menuAuxiliaryPreviewView.transform = transform;
          
        }, {
          // B - slide - exit transition
          // fade - end
          menuAuxiliaryPreviewView.alpha = 1;
 
          // slide - end - reset transform
          menuAuxiliaryPreviewView.transform = .identity;
        });
          
        case let .zoom(zoomOffset): return ({
            // A - zoom - entrance transition
            // fade - start
            menuAuxiliaryPreviewView.alpha = 0;
            
            // zoom - start
            setTransformForTransitionZoomStart(zoomOffset);
            
            // start - apply transform
            menuAuxiliaryPreviewView.transform = transform;
            
          }, {
            // B - zoom - exit transition
            // fade - end
            menuAuxiliaryPreviewView.alpha = 1;
            
            // zoom - end - reset transform
            menuAuxiliaryPreviewView.transform = .identity;
          });
          
        case let .zoomAndSlide(slideOffset, zoomOffset): return ({
          // A - zoomAndSlide - entrance transition
          // fade - start
          menuAuxiliaryPreviewView.alpha = 0;
        
          // slide - start
          setTransformForTransitionSlideStart(slideOffset);
          
          // zoom - start
          setTransformForTransitionZoomStart(zoomOffset);
          
          // start - apply transform
          menuAuxiliaryPreviewView.transform = transform;
                    
        }, {
          // B - zoomAndSlide - exit transition
          // fade - end
          menuAuxiliaryPreviewView.alpha = 1;
          
          // slide/zoom - end - reset transform
          menuAuxiliaryPreviewView.transform = .identity;
        });
          
        case .none:
          // don't use any entrance transitions...
          fallthrough;
          
        default:
          // noop entrance + exit transition
          return ({},{});
      };
    }();
    
    // MARK: Show Aux. View
    // --------------------
    
    self.isAuxPreviewVisible = true;
    

    
    // MARK: Bugfix - Aux-Preview Touch Event on Screen Edge
    let shouldSwizzle = contextMenuMetadata.contextMenuOffsetY != 0;
    
    if shouldSwizzle {
      Self.auxPreview = menuAuxiliaryPreviewView;
      UIView.swizzlePoint();
    };
    
    attachAuxPreviewBlock();
    setTransitionStateStart();
    
    
    
    
    
    
    UIView.addKeyframe(withRelativeStartTime: 1, relativeDuration: 1) {
      // transition in - set end values
      setTransitionStateEnd();
      
      let yOffset = contextMenuMetadata.contextMenuOffsetY;
    
      // offset from anchor
      contextMenuContainerView.frame =
        contextMenuContainerView.frame.offsetBy(dx: 0, dy: yOffset)
    };
  };
  
  // MARK: Experimental - "Auxiliary Context Menu Preview"-Related
  func detachContextMenuAuxiliaryPreviewIfAny(
    _ animator: UIContextMenuInteractionAnimating?
  ){
    
    guard self.isAuxiliaryPreviewEnabled,
          self.isAuxPreviewVisible,
          
          let animator = animator,
          let menuAuxiliaryPreviewView = self.menuAuxiliaryPreviewView,
          let contextMenuMetadata = self.contextMenuMetadata
    else { return };
    
    /// Bug:
    /// * "Could not locate shadow view with tag #, this is probably caused by a temporary inconsistency
    ///   between native views and shadow views."
    /// * Triggered when the menu is about to be hidden, iOS removes the context menu along with the
    ///   `previewAuxiliaryViewContainer`
    ///
    
    // reset flag
    self.isAuxPreviewVisible = false;
    
    // Add exit transition
    animator.addAnimations { [unowned self] in
      var transform = menuAuxiliaryPreviewView.transform;
      
      // transition - fade out
      menuAuxiliaryPreviewView.alpha = 0;
      
      // transition - zoom out
      transform = transform.scaledBy(x: 0.7, y: 0.7);
      
      // transition - slide out
      switch contextMenuMetadata.morphingPlatterViewPlacement {
        case .top:
          transform = transform.translatedBy(x: 0, y: 50);
          
        case .bottom:
          transform = transform.translatedBy(x: 0, y: -50);
          
        default: break;
      };
      
      // transition - apply transform
      menuAuxiliaryPreviewView.transform = transform;
    };
    
    animator.addCompletion { [unowned self] in
      menuAuxiliaryPreviewView.removeFromSuperview();
      
      // clear value
      self.contextMenuMetadata = nil;
      
      // MARK: Bugfix - Aux-Preview Touch Event on Screen Edge
      if UIView.isSwizzlingApplied {
        // undo swizzling
        UIView.swizzlePoint();
        Self.auxPreview = nil;
      };
    };
  };
  
  // MARK: - Public Functions
  // ------------------------
  
  // context menu display begins
  public func notifyOnContextMenuInteraction(
    _ interaction: UIContextMenuInteraction,
    willDisplayMenuFor configuration: UIContextMenuConfiguration,
    animator: UIContextMenuInteractionAnimating?
  ) {
  
    if let animator = animator {
      animator.addAnimations {
        self.attachContextMenuAuxiliaryPreviewIfAny(animator);
      };
    
      animator.addCompletion {
        self.isContextMenuVisible = true;
      };
      
    } else {
      self.isContextMenuVisible = true;
    };
  };
  
  public func notifyOnContextMenuInteraction(
    _ interaction: UIContextMenuInteraction,
    willEndFor configuration: UIContextMenuConfiguration,
    animator: UIContextMenuInteractionAnimating?
  ) {
  
    if let animator = animator {
      animator.addCompletion {
        self.isContextMenuVisible = false;
      };
      
    } else {
      self.isContextMenuVisible = false;
    };
  };
};

// MARK: - UIView - "Auxiliary Preview"-Related (Experimental)
// -----------------------------------------------------------

// Bugfix: Fix for aux-preview not receiving touch event when appearing
// on screen edge
fileprivate extension UIView {
  static weak var auxPreview: UIView? = nil;
  
  static var isSwizzlingApplied = false
  
  @objc dynamic func _point(
    inside point: CGPoint,
    with event: UIEvent?
  ) -> Bool {
    guard let auxPreview = Self.auxPreview,
          self.subviews.contains(where: { $0 === auxPreview })
    else {
      // call original impl.
      return self._point(inside: point, with: event);
    };
    
    return true;
  };
  
  static func swizzlePoint(){
    let selectorOriginal = #selector( point(inside: with:));
    let selectorSwizzled = #selector(_point(inside: with:));
    
    guard let methodOriginal = class_getInstanceMethod(UIView.self, selectorOriginal),
          let methodSwizzled = class_getInstanceMethod(UIView.self, selectorSwizzled)
    else { return };
    
    Self.isSwizzlingApplied.toggle();
    method_exchangeImplementations(methodOriginal, methodSwizzled);
  };
};
