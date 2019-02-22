import UIKit

struct contentNotification {
    
    static let added = Notification.Name("ca.cinard.tempGcD.added")
}




class MyData
{
    private init() {}
    static let shared = MyData()
    
    private var namesArr: [String] = []
    
    private let myQueue =
        DispatchQueue(
            label: "ca.cinard.tempGCD",
            attributes: DispatchQueue.Attributes.concurrent)
    
    var names: [String] {
        var namesNewCopy: [String]!
        
        myQueue.sync
            {
                namesNewCopy = self.namesArr
        }
        return namesNewCopy
    }
    
    func heavyCalculation()
    {
        for _ in 0...100000000
        {
            self.namesArr.append("HI")
        }
    }
    
    func addTheWrongWay( )
    {
        heavyCalculation()
        
        DispatchQueue.main.async { [weak self] in
            self?.sendAddedNotification()
        }
    }
    
    func doElse ()
    {
        myQueue.async(flags: DispatchWorkItemFlags.detached) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.namesArr.removeAll()
            self.namesArr.append("Vancouver")
            
            DispatchQueue.main.async { [weak self] in
                self?.sendAddedNotification()
            }
        }
    }

    func addTheRightWay( )
    {
        myQueue.async(flags: DispatchWorkItemFlags.barrier) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.heavyCalculation()
            
            DispatchQueue.main.async { [weak self] in
                self?.sendAddedNotification()
            }
        }
    }
    
    private func sendAddedNotification() {
        NotificationCenter.default.post(name: contentNotification.added, object: nil)
    }
    
    
    
    
    
}

class ViewController: UIViewController
{
    @IBOutlet weak var labelNameCount: UILabel!
    
    @IBOutlet weak var resLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addedNotificationReceived(_:)),
            name: contentNotification.added,
            object: nil)
    }
    
    @objc func addedNotificationReceived(_ notification: Notification!)
    {
        self.labelNameCount.text = "There are \n\(MyData.shared.names.count)\nnames now"
    }
    
    @IBAction func addSomething(_ sender: Any)
    {
//                MyData.shared.addTheWrongWay()
        MyData.shared.addTheRightWay()
    }
    
    
    
    @IBAction func doElse(_ sender: Any)
    {
        MyData.shared.doElse()

    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == resLabel
            {
                resLabel.text = "reset"
            }
        }
        
    }
    
}

