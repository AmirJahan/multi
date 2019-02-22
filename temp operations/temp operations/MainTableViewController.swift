
import UIKit

class MainTableViewController: UITableViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()


    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return 1000
    }

    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        
        
        // heavy calc
        let totalAttempt : Int = 1000000;
        var sum : Int = 0;
        
        for _ in 0...totalAttempt
        {
            let dice : Int = (Int)(arc4random() % 6) + 1;
            
            sum += dice;
        }
        let average : Float =  Float(sum) / Float(totalAttempt);
        
        
        
        cell.textLabel!.text = "\(average)"

        return cell
    }
    

}
