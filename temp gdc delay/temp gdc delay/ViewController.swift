import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delayFunc()
    }

    
    func delayFunc ()
    {
        
        let pauseTime = 5.0
        

        DispatchQueue.main.asyncAfter(deadline: .now() + pauseTime) { [weak self] in
            guard let self = self else {
                return
            }
            
            // do what you wish to do, after the 5 seconds delay
            DispatchQueue.main.async { [weak self] in
                
                self!.myLabel.text = "This now happening after 5 seconds"
            }
            
            

        }
    }

}

