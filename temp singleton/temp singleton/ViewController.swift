import UIKit

class MyData
{
    private init() {}
    static let shared = MyData()
    
    var myArr: [String] = ["Ding", "Ding"]
}




class ViewController: UIViewController
{

    @IBOutlet weak var myTextView: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        myTextView.text = "Content is: \n\(MyData.shared.myArr)"

        MyData.shared.myArr.append("New element")
        MyData.shared.myArr.append("Some Other element")
        
        
    }


}

