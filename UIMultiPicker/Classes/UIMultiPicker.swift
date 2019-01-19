import UIKit

@IBDesignable @objc
open class UIMultiPicker: UIControl {
    
    @objc
    public var options: [String] = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"] {
        didSet {
            picker.reloadComponent(0)
            sendActions(for: .valueChanged)
        }
    }
    
    @objc
    public var selectedIndexes: [Int] = [] {
        didSet {
            sendActions(for: .valueChanged)
            picker.reloadComponent(0)
        }
    }
    
    private let picker = UIMultiPickerView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        picker.parent = self
        addSubview(picker)
        picker.frame = bounds // Make picker spans parent view
        picker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

class UIMultiPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource
{
    weak var parent: UIMultiPicker! = nil
    
    var topTable: UITableView!
    var bottomTable: UITableView!
    var centerTable: UITableView!
    
    var topTableProxy: TableViewProxy!
    var bottomTableProxy: TableViewProxy!
    var centerTableProxy: CenterTableViewProxy!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.delegate = self
        self.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderWidth = 0 // Main view rounded border
        
        // Component borders
        subviews.forEach {
            $0.layer.borderWidth = 0
            $0.isHidden = $0.frame.height <= 1.0
        }
        
        let topTable = (subviews[0].subviews[0].subviews[0].subviews[0] as! UITableView)
        if (topTable != self.topTable) {
            self.topTable = topTable
            self.topTableProxy = TableViewProxy(dataSource: topTable.dataSource!)
            self.topTableProxy.multiPicker = self.parent
            topTable.dataSource = self.topTableProxy
        }
        
        let bottomTable = (subviews[0].subviews[0].subviews[1].subviews[0] as! UITableView)
        if (bottomTable != self.bottomTable) {
            self.bottomTable = bottomTable
            self.bottomTableProxy = TableViewProxy(dataSource: bottomTable.dataSource!)
            self.bottomTableProxy.multiPicker = self.parent
            bottomTable.dataSource = self.bottomTableProxy
        }
        
        let centerTable = (subviews[0].subviews[0].subviews[2].subviews[0] as! UITableView)
        if centerTable != self.centerTable {
            self.centerTable = centerTable
            self.centerTableProxy = CenterTableViewProxy(dataSource: centerTable.dataSource!)
            self.centerTableProxy.multiPicker = self.parent
            centerTable.dataSource = self.centerTableProxy
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return parent.options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return parent.options[row]
    }
}

class TableViewProxy : NSObject, UITableViewDataSource
{
    weak var multiPicker: UIMultiPicker!
    let dataSource: UITableViewDataSource
    var defaultLabelColor: UIColor!
    
    init(dataSource: UITableViewDataSource) {
        self.dataSource = dataSource
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataSource.tableView(tableView, cellForRowAt: indexPath)
        let label = cell.subviews[1] as! UILabel
        label.alpha = 1
        
        if (defaultLabelColor == nil) {
            defaultLabelColor = label.textColor
        }
        
        let tap = cell.gestureRecognizers![0] as! UITapGestureRecognizer
        cell.tag = indexPath.row
        tap.removeTarget(self, action: #selector(self.handleCellTap(sender:)))
        tap.addTarget(self, action: #selector(self.handleCellTap))
        
        if multiPicker.selectedIndexes.contains(indexPath.row) {
            label.textColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        }
        return cell
    }
    
    @objc func handleCellTap(sender: UITapGestureRecognizer) {
        let cell = sender.view as! UITableViewCell
        let row = cell.tag
        
        if (multiPicker.selectedIndexes.contains(row)) {
            multiPicker.selectedIndexes = multiPicker.selectedIndexes.filter { $0 != row }
        } else {
            multiPicker.selectedIndexes += [row]
        }
    }
    
    // redirect
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.tableView(tableView, numberOfRowsInSection: section)
    }
}

class CenterTableViewProxy: TableViewProxy
{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let label = cell.subviews[1] as! UILabel
        
        label.font = label.font.withSize(21) // Fix center item font size
        return cell
    }
}
