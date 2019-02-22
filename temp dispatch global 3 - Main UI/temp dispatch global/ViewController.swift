import UIKit

class ViewController: UIViewController
{
    
    
    @IBOutlet weak var resLabel: UILabel!
    
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        

        
        
        actInd.startAnimating()
        actInd.hidesWhenStopped = true
        
        // begin a hevay task in a userinititated Qos
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {
                return
            }
            // doing heavy in Global
            let totalAttempt : Int = 100000000;
            var sum : Int = 0;
            
            for _ in 0...totalAttempt
            {
                let dice : Int = (Int)(arc4random() % 6) + 1;
                sum += dice;
            }
            let average : Float =  Float(sum) / Float(totalAttempt);
            
            
            // fetch back the results in main
            DispatchQueue.main.async
                { [weak self] in
                    
                    self!.actInd.stopAnimating()
                    self!.resLabel.text = "average is: \(average)"
            }
        }
    }
}
