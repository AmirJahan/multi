
import UIKit


enum CalculationState
{
    case new, found
}


// photo record
class AverageVal
{
    var val: String
    var state = CalculationState.new
    
    init()
    {
        val = ""
    }
}


class PendingCalculations
{
    var calcProgress: [IndexPath: Operation] = [:]
    
    var calcQueue: OperationQueue =
    {
        var queue = OperationQueue()
        queue.name = "calculation queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}


// image downloader
class ValueCalculator: Operation
{
    // the average value related to the operation
    let thisAverageVal: AverageVal
    
    
    init( withAverage: AverageVal)
    {
        self.thisAverageVal = withAverage
    }
    
    // Overrding the Operation's Main
    override func main()
    {
        
        if isCancelled
        {
            return
        }
        
        
        
        // some heavy calculations such as a download
        thisAverageVal.state = CalculationState.new
        
        let totalAttempt : Int = 1000000;
        var sum : Int = 0;
        
        for _ in 0...totalAttempt
        {
            let dice : Int = (Int)(arc4random() % 6) + 1;
            
            sum += dice;
        }
        
        let average : Float =  Float(sum) / Float(totalAttempt);
        
        thisAverageVal.val = "\(average)"
        thisAverageVal.state = CalculationState.found
        
        //6
        if isCancelled {
            return
        }
        
        
    }
}

class MainTableViewController: UITableViewController
{
    
    var values: [AverageVal] = []
    
    // pending
    let myOperations = PendingCalculations()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        calculateAverages()
        
        
//        DispatchQueue.global(qos: DispatchQoS.QoSClass.)
    }
    
    
    func calculateAverages()
    {
        
        for _ in 0...100
        {
            let newAverage = AverageVal()
            values.append(newAverage)
        }
        

        DispatchQueue.main.async
            {
                self.tableView.reloadData()
        }
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return values.count
    }
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let thisValue = values[indexPath.row]

        
        switch (thisValue.state)
        {
        case CalculationState.new:
            cell.textLabel?.text = "Calculating"
            if !tableView.isDragging && !tableView.isDecelerating {
                startOperations(for: thisValue, at: indexPath)
            }
        case CalculationState.found:
            cell.textLabel?.text = thisValue.val
        }
        
        
        return cell
    }
    
    func startOperations(for val: AverageVal, at indexPath: IndexPath)
    {
        switch (val.state)
        {
        case .new:
            startCalculating(for: val, at: indexPath)
        default:
            print("do non")
        }
    }
    
    func startCalculating(for val: AverageVal, at indexPath: IndexPath) {
        
        
        // if already an operation is present
        guard myOperations.calcProgress[indexPath] == nil else {
            return
        }
        
        // otehrwise create a calculator
        let thisCalculator = ValueCalculator(withAverage: val)
        
        // completion for the operation is finished
        thisCalculator.completionBlock =
            {
            if thisCalculator.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.myOperations.calcProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
        
        // adding the op
        myOperations.calcProgress[indexPath] = thisCalculator
        
        // get the operation started
        myOperations.calcQueue.addOperation(thisCalculator)
    }
    
    
}


extension MainTableViewController
{
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //1
        suspendAllOperations()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 2
        if !decelerate {
            loadOnlyOnScreenCell()
            resumeAllOperations()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 3
        loadOnlyOnScreenCell()
        resumeAllOperations()
    }
    
    func suspendAllOperations() {
        myOperations.calcQueue.isSuspended = true
    }
    
    func resumeAllOperations() {
        myOperations.calcQueue.isSuspended = false
    }
    
    func loadOnlyOnScreenCell() {
        //1
        if let pathsArray = tableView.indexPathsForVisibleRows {
            //2
            var allPendingOperations = Set(myOperations.calcProgress.keys)
            
            //3
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray)
            toBeCancelled.subtract(visiblePaths)
            
            //4
            var toBeStarted = visiblePaths
            toBeStarted.subtract(allPendingOperations)
            
            // 5
            for indexPath in toBeCancelled {
                if let pendingCalculation = myOperations.calcProgress[indexPath] {
                    pendingCalculation.cancel()
                }
                myOperations.calcProgress.removeValue(forKey: indexPath)
                
            }
            
            // 6
            for indexPath in toBeStarted {
                let currentCalc = values[indexPath.row]
                startOperations(for: currentCalc, at: indexPath)
            }
        }
    }
}
