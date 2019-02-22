import UIKit

class NextViewController: UIViewController {

    
    @IBOutlet weak var myTextView: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        myTextView.text = "Content is: \n\(MyData.shared.myArr)"
     
        
        
    }

}
