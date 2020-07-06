//
//  SortFieldsViewController.swift
//  BookRoom
//
//  The controller class that is attached to Sort fields view controller Scene in Storyboard
//  It is to display the sort fields (Capacity, Location and Availability) when press the Sort button in the Room Listing 
//

import UIKit


// MARK: - Protocol for Delegate to implement to get the sort value
protocol SortDelegate : class {
    func didApplySort(value:Sort)
}

class SortFieldsViewController: UIViewController {
   
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnAvailability: RadioButton!
    @IBOutlet weak var btnCapacity: RadioButton!
    @IBOutlet weak var btnLocation: RadioButton!
    public weak var delegate: SortDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.btnApply.layer.cornerRadius = 15
        self.btnReset.layer.cornerRadius = 15
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.cornerRadius = 12
    }
     
    // MARK: - Buttons Event functions
    @IBAction func onBtnApply(_ sender: Any) {
        if btnLocation.isSelected {
            delegate?.didApplySort(value: .Location)
            return
        }
        if btnCapacity.isSelected {
            delegate?.didApplySort(value: .Capacity)
            return
        }
        else if btnAvailability.isSelected {
            delegate?.didApplySort(value: .Availability)
            return
        }
        
        delegate?.didApplySort(value: .Default)
    }
    
    @IBAction func onBtnReset(_ sender: Any) {
        self.btnLocation.isSelected = false
        self.btnCapacity.isSelected = false
        self.btnAvailability.isSelected = false
    }
    
    @IBAction func onBtnSortSelection(_ sender: RadioButton) {
        
        if (sender == btnLocation) {
            self.btnLocation.isSelected = true
            self.btnCapacity.isSelected = false
            self.btnAvailability.isSelected = false
        }
        else if (sender == btnCapacity) {
            self.btnLocation.isSelected = false
            self.btnCapacity.isSelected = true
            self.btnAvailability.isSelected = false
        }
        else if (sender == btnAvailability) {
            self.btnLocation.isSelected = false
            self.btnCapacity.isSelected = false
            self.btnAvailability.isSelected = true
        }
    }
    
    // MARK: - Public functions
    public func setSort(sort:Sort) {
        
        if sort == .Location {
            btnLocation.isSelected = true
        }
        else if sort == .Capacity {
            btnCapacity.isSelected = true
        }
        else if sort == .Availability {
            btnAvailability.isSelected = true
        }
        
        else if sort == .Default {
            btnLocation.isSelected = false
            btnCapacity.isSelected = false
            btnAvailability.isSelected = false
        }
               
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
