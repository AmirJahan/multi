import UIKit

class ViewController: UIViewController
{
    
    
    @IBOutlet weak var resLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .userInitiated).async
            { [weak self] in
            guard let self = self else
            {
                return
            }
            self.heavyCalc()
        }
    }
    
    func heavyCalc ()
    {
        let totalAttempt : Int = 100000000;
        var sum : Int = 0;
        
        for _ in 0...totalAttempt
        {
            let dice : Int = (Int)(arc4random() % 6) + 1;
            
            sum += dice;
        }
        
        let average : Float =  Float(sum) / Float(totalAttempt);
        
        resLabel.text = "average is: \(average)"
    }
    
    
    
}

