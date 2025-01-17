import UIKit

public typealias UForEach = ForEach
public class ForEach<Item> where Item: Hashable {
    public typealias BuildViewHandler = (Int, Item) -> ViewBuilderItem
    public typealias BuildViewHandlerValue = (Item) -> ViewBuilderItem
    public typealias BuildViewHandlerSimple = () -> ViewBuilderItem
    
    let items: State<[Item]>
    let block: BuildViewHandler
    
    public init (_ items: [Item], @ViewBuilder block: @escaping BuildViewHandler) {
        self.items = State(wrappedValue: items)
        self.block = block
    }
    
    public init (_ items: [Item], @ViewBuilder block: @escaping BuildViewHandlerValue) {
        self.items = State(wrappedValue: items)
        self.block = { _, v in
            block(v)
        }
    }
    
    public init (_ items: [Item], @ViewBuilder block: @escaping BuildViewHandlerSimple) {
        self.items = State(wrappedValue: items)
        self.block = { _,_ in
            block()
        }
    }
    
    public init (_ items: State<[Item]>, @ViewBuilder block: @escaping BuildViewHandler) {
        self.items = items
        self.block = block
    }
    
    public init (_ items: State<[Item]>, @ViewBuilder block: @escaping BuildViewHandlerValue) {
        self.items = items
        self.block = { _, v in
            block(v)
        }
    }
    
    public init (_ items: State<[Item]>, @ViewBuilder block: @escaping BuildViewHandlerSimple) {
        self.items = items
        self.block = { _,_ in
            block()
        }
    }
}

extension ForEach: Listable {
    public var count: Int { items.wrappedValue.count }
    
    public func item(at index: Int) -> [UIView] {
        guard index < items.wrappedValue.count else { return [] }
        let rawViews = block(index, items.wrappedValue[index]).viewBuilderItems
        return rawViews.map { View(inline: $0) }
    }
}

extension ForEach: ListableForEach {
    func subscribeToChanges(_ begin: @escaping () -> Void, _ handler: @escaping ([Int], [Int], [Int]) -> Void, _ end: @escaping () -> Void) {
        items.beginTrigger(begin)
        items.listen { old, new in
            let diff = old.difference(new)
            let deletions = diff.removed.compactMap { $0.index }
            let insertions = diff.inserted.compactMap { $0.index }
            let modifications = diff.modified.compactMap { $0.index }
            guard deletions.count > 0 || insertions.count > 0 || modifications.count > 0 else { return }
            handler(deletions, insertions, modifications)
        }
        items.endTrigger(end)
    }
}

extension ForEach: StackForEach {
    func subscribeToChanges(_ handler: @escaping ([Any], [Any], [Int], [Int], [Int]) -> Void) {
        items.listen { old, new in
            let diff = old.difference(new)
            let deletions = diff.removed.compactMap { $0.index }
            let insertions = diff.inserted.compactMap { $0.index }
            let modifications = diff.modified.compactMap { $0.index }
            guard deletions.count > 0 || insertions.count > 0 || modifications.count > 0 else { return }
            handler(old, new, deletions, insertions, modifications)
        }
    }
}

extension ForEach: ListableBuilderItem {
    public var listableBuilderItems: [Listable] { [self] }
}

extension ForEach: ViewBuilderItem {
    public var viewBuilderItems: [UIView] {
        items.wrappedValue.enumerated().map { item(at: $0.offset) }.flatMap { $0 }
    }
}

extension ForEach where Item == Int {
    public convenience init (_ items: ClosedRange<Item>, @ViewBuilder block: @escaping BuildViewHandler) {
        self.init(items.map { $0 }, block: block)
    }
    
    public convenience init (_ items: ClosedRange<Item>, @ViewBuilder block: @escaping BuildViewHandlerValue) {
        self.init(items.map { $0 }, block: block)
    }
    
    public convenience init (_ items: ClosedRange<Item>, @ViewBuilder block: @escaping BuildViewHandlerSimple) {
        self.init(items.map { $0 }, block: block)
    }
}
