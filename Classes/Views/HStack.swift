import UIKit

@available(*, deprecated, renamed: "HStack")
public typealias HStackView = HStack

public typealias UHStack = HStack
open class HStack: _StackView {
    public init (@ViewBuilder block: ViewBuilder.SingleView) {
        super.init(frame: .zero)
        axis = .horizontal
        block().viewBuilderItems.forEach { addArrangedSubview($0) }
    }
        
    public override init () {
        super.init(frame: .zero)
        axis = .horizontal
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func subviews(@ViewBuilder block: ViewBuilder.SingleView) -> Self {
        block().viewBuilderItems.forEach { addArrangedSubview($0) }
        return self
    }
    
    public static func subviews(@ViewBuilder block: ViewBuilder.SingleView) -> HStack {
        .init(block: block)
    }
}
