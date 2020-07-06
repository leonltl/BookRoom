//
//  RoomListingViewController.swift
//  BookRoom
//
//  The controller class that is attached to Book A Room Scene in Storyboard
//  It is to display the room listing based on the date and time selected and the sort field selected
//

import UIKit
 
// MARK: - Protocol for delegate to implement to get the default sort value
protocol DefaultSelectionDelegate : class {
    func setDefaultSelection(value:Sort)
}

extension RoomListingViewController {
    
    // MARK: - Show Sort Drawer functions
    private func showSortDrawer() {
        self.coveredView.isHidden = false
        self.handlerView.isHidden = false
        self.coveredView.alpha = 0
      
        self.view.layoutIfNeeded()
      
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        if let safeAreaHeight = window?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = window?.safeAreaInsets.bottom {
            handlerConstraint.constant = (safeAreaHeight + bottomPadding) / 3.0
        }
      
        let showDrawer = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })
      
        showDrawer.addAnimations({
            self.coveredView.alpha = 0.7
        })
      
        showDrawer.startAnimation()
    }
    
    private func hideSortDrawer() {
        
        self.view.layoutIfNeeded()
          
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        if let safeAreaHeight = window?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = window?.safeAreaInsets.bottom {
            handlerConstraint.constant = safeAreaHeight + bottomPadding
        }
          
        let hideDrawer = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })
          
        hideDrawer.addAnimations {
            self.coveredView.alpha = 0.0
        }
          
        hideDrawer.addCompletion({ position in
            if position == .end {
                if(self.presentingViewController != nil) {
                    self.dismiss(animated: false, completion: nil)
                }
                
                self.coveredView.isHidden = true
                self.handlerView.isHidden = true
            }
        })
          
        hideDrawer.startAnimation()
    }
}

extension RoomListingViewController : SortDelegate {
    
    // MARK: - Sort Deleggate function
    func didApplySort(value: Sort) {
        self.hideSortDrawer()
       
        self.defaultSort = value
        if value == .Default {
            self.roomsList = self.roomsList.sorted(by: { (r0: Room, r1: Room) -> Bool in
               let r0SortField = Int(r0.level) ?? 0
               let r1SortField = Int(r1.level) ?? 0
               return r0SortField < r1SortField
           })
        }
        if value == .Capacity {
           self.roomsList = self.roomsList.sorted(by: { (r0: Room, r1: Room) -> Bool in
               let r0SortField = Int(r0.capacity) ?? 0
               let r1SortField = Int(r1.capacity) ?? 0
               return r0SortField > r1SortField
           })
        }
        else if value == .Location {
           self.roomsList = self.roomsList.sorted(by: { (r0: Room, r1: Room) -> Bool in
               let r0SortField = Int(r0.level) ?? 0
               let r1SortField = Int(r1.level) ?? 0
               return r0SortField > r1SortField
           })
        }
        else if value == .Availability {
            // Revert to default sorting first
            self.roomsList = self.roomsList.sorted(by: { (r0: Room, r1: Room) -> Bool in
                let r0SortField = Int(r0.level) ?? 0
                let r1SortField = Int(r1.level) ?? 0
                return r0SortField < r1SortField
            })
            
            self.roomsList = self.roomsList.sorted(by: { (r0: Room, r1: Room) -> Bool in
                let r0SortField = Int(r0.level) ?? 0
                let r1SortField = Int(r1.level) ?? 0
            
                let r0isFound = self.isRoomAvailableForBooking(room: r0, aDate: self.selectedDate)
                let r1isFound = self.isRoomAvailableForBooking(room: r1, aDate: self.selectedDate)
                if r0isFound != r1isFound {
                    return r0isFound == true ? r0isFound : r1isFound
                }
                else if r0isFound == r1isFound {
                    return r0SortField < r1SortField
                }
                
                return false
           })
        }
        
        tblRoomAvailability.reloadData()
    }
}

extension RoomListingViewController: UITableViewDelegate, UITableViewDataSource  {
    
    // MARK - Table Action functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if !self.txtRoomDate.text!.isEmpty && !self.txtRoomTime.text!.isEmpty {
           return roomsList.count
       }
       return 0
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RoomCell
        let room = roomsList[indexPath.row]
       
        cell.name.text = room.name
        cell.name.accessibilityIdentifier = "Name"
        
        cell.level.text = "Level " + String(room.level)
        cell.level.accessibilityIdentifier = "Level"
        
        cell.capacity.text = room.capacity + " Pax"
        cell.capacity.accessibilityIdentifier = "Pax"
        
        cell.availability.accessibilityIdentifier = "Availability"
        let isRoomAvailable = self.isRoomAvailableForBooking(room: room, aDate: self.selectedDate)
        if isRoomAvailable {
            cell.availability.text = "Available"
            cell.availability.textColor = UIColor.systemGreen
        }
        else {
            cell.availability.text = "Not Available"
            cell.availability.textColor = UIColor.darkGray
        }

        return cell
    }
      
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 80.0
   }
}

class RoomListingViewController: UIViewController {

    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var handlerConstraint: NSLayoutConstraint!
    @IBOutlet weak var coveredView: UIView!
    @IBOutlet weak var handlerView: UIView!
    @IBOutlet weak var sortContainerView: UIView!
    @IBOutlet weak var tblRoomAvailability: UITableView!
    @IBOutlet weak var txtRoomDate: UITextField!
    @IBOutlet weak var txtRoomTime: UITextField!
    private let datePicker = UIDatePicker()
    private let timePicker = UIDatePicker()
    private var roomsList = [Room]()
    private var selectedDate:Date = Date()
    private var selectedTime:Date = Date()
    private var selectedDateTime:Date = Date()
    private var defaultSort:Sort = .Location
    private var sortController:SortFieldsViewController?
    
    private let API = "https://gist.githubusercontent.com/yuhong90/7ff8d4ebad6f759fcc10cc6abdda85cf/raw/463627e7d2c7ac31070ef409d29ed3439f7406f6/room-availability.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.tblRoomAvailability.isHidden = true
        self.coveredView.isHidden = true
        self.handlerView.isHidden = true
        self.handlerView.layer.cornerRadius = 10
        self.coveredView.alpha = 0
        
        // Set the default drawer constraint to the bottom
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        if let safeAreaHeight = window?.safeAreaLayoutGuide.layoutFrame.size.height,
           let bottomPadding = window?.safeAreaInsets.bottom {
           handlerConstraint.constant = safeAreaHeight + bottomPadding
        }
        
        self.btnSort.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ?
            .forceLeftToRight : .forceRightToLeft
        self.btnSort.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);
        
        self.setAccessibilityIdentifiers()
        self.setDatePickerToField()
        self.setTimePickerToField()
        self.loadJsonFromUrl(refreshTable: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let networkConnection = NetworkMonitor.shared
        networkConnection.startMonitoring()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let networkConnection = NetworkMonitor.shared
        networkConnection.stopMonitoring()
    }

    // MARK: - Private functions
    private func setAccessibilityIdentifiers() {
        self.view.accessibilityIdentifier = "RoomList"
        self.tblRoomAvailability.accessibilityIdentifier = "tblRoomAvailability"
    }
    
    /**
     Set the date picker to the text field
     - Returns: void
    */
    private func setDatePickerToField() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let btnFlex = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(onBtnDatePickerDone))
        
        toolbar.setItems([btnFlex, btnDone], animated: true)
        datePicker.datePickerMode = .date
        txtRoomDate.inputAccessoryView = toolbar
        txtRoomDate.inputView = datePicker
    }
    
    /**
     Set the time picker to the text field
     - Returns: void
    */
    private func setTimePickerToField() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let btnFlex = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(onBtnTimePickerDone))
        
        toolbar.setItems([btnFlex, btnDone], animated: true)
        timePicker.datePickerMode = .time
        txtRoomTime.inputAccessoryView = toolbar
        txtRoomTime.inputView = timePicker
    }
    
    /**
     Load the Json file from the URL
     - Parameter refreshTable: The flag whether to refresh the table vieew
     - Returns: void
    */
    private func loadJsonFromUrl(refreshTable:Bool) {
        let networkConnection = NetworkMonitor.shared
        if networkConnection.connType == .unknown {
            let alert = UIAlertController(title: "Internet Connection Error", message: "Internet connection is not found, try again once you have internet access.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        // Load the json file from API
        if let url = URL(string: API) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let jsonData = try decoder.decode([Room].self, from: data)
                        self.roomsList = jsonData.sorted(by: { (r0: Room, r1: Room) -> Bool in
                            let r0SortField = Int(r0.level) ?? 0
                            let r1SortField = Int(r1.level) ?? 0
                            return r0SortField < r1SortField
                        })
                        
                        // Dictionary cannot be sorted, sort the key in an array for easier access to find slot availability
                        for room in self.roomsList {
                            let allTimeSlots = Array(room.availability.keys)
                            
                            let allTimeSortedSlots = allTimeSlots.sorted(by: { (r0, r1) -> Bool in
                                return r0 < r1
                            })
                            
                            room.availabilityKeysSorted = allTimeSortedSlots
                        }
                        
                        if refreshTable {
                            DispatchQueue.main.async {
                                self.tblRoomAvailability.reloadData()
                            }
                        }
                    }
                    catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    /**
         Find if the room is available by comparing the provided date
        - Parameter room: A room variable
        - Parameter aData: A date
        - Returns: true for room is avaible and false for room not available
     */
    private func isRoomAvailableForBooking(room: Room, aDate:Date) -> Bool {
       let availableSlots = room.availability
           
        guard let allTimeSlotsSorted = room.availabilityKeysSorted else {
            return false
        }
               
        let calendar = Calendar.current
        var foundSlot:String = ""
       
        var slotComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: aDate)
        var nextSlotComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: aDate)
           
        // Loop through the slots that are sorted
        // Format the slot at n index and n index + 1 to date type for comparision
        // Compare whether the selected dateTime value is within n index and n index + 1
        for (index, slot) in allTimeSlotsSorted.enumerated() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
           
            let date = dateFormatter.date(from: slot)
            let timeComponents = calendar.dateComponents([.hour, .minute], from: date!)
            slotComponents.hour = timeComponents.hour
            slotComponents.minute = timeComponents.minute
            let slotDateTime = Calendar.current.date(from: slotComponents)!
               
            var slotNextDateTime:Date?
            if (index + 1 < allTimeSlotsSorted.count) {
                let nextDate = dateFormatter.date(from: allTimeSlotsSorted[index + 1])
                let nextTimeComponents = calendar.dateComponents([.hour, .minute], from: nextDate!)
                nextSlotComponents.hour = nextTimeComponents.hour
                nextSlotComponents.minute = nextTimeComponents.minute
                slotNextDateTime = Calendar.current.date(from: nextSlotComponents)!
            }
               
            if let nextDateTime = slotNextDateTime {
                if self.selectedDateTime > slotDateTime && self.selectedDateTime < nextDateTime {
                   foundSlot = slot
                   break
                }
            }
            else {
                if self.selectedDateTime < slotDateTime {
                   foundSlot = slot
                   break
                }
            }
       }
           
       if !foundSlot.isEmpty {
           if availableSlots[foundSlot] == "1" {
               return true
           }
       }
           
       return false
   }
    
    
    // MARK: - Action functions
    @IBAction func onBtnSort(_ sender: Any) {
        if self.txtRoomDate.text!.isEmpty && self.txtRoomTime.text!.isEmpty {
            return
        }
        
        if self.roomsList.isEmpty {
            return
        }
        
        self.showSortDrawer()
        
        if let sortVC = sortController {
            sortVC.setSort(sort: defaultSort)
        }
    }
    
    @IBAction func onBtnCamera(_ sender: Any) {
        self.performSegue(withIdentifier: "segueQrCamera", sender: nil)
    }
    
    @objc func onBtnDatePickerDone(sender: UIButton) {
        self.txtRoomDate.text = Utility.ordinalDate(date: datePicker.date)
        self.selectedDate = datePicker.date
        self.view.endEditing(true)
        
        if !self.txtRoomDate.text!.isEmpty && !self.txtRoomTime.text!.isEmpty {
            let calendar = Calendar.current
            var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self.selectedDate)
            
            let timeComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self.selectedTime)
            dateComponents.hour = timeComponents.hour
            dateComponents.minute = timeComponents.minute
            
            self.selectedDateTime = Calendar.current.date(from: dateComponents)!
            self.tblRoomAvailability.isHidden = false
            
            if self.roomsList.isEmpty {
                self.loadJsonFromUrl(refreshTable: true)
            }
            else {
                self.tblRoomAvailability.reloadData()
            }
        }
    }
    
    @objc func onBtnTimePickerDone(sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        self.txtRoomTime.text = dateFormatter.string(from: timePicker.date)
        self.selectedTime = timePicker.date
        
        self.view.endEditing(true)
        if !self.txtRoomDate.text!.isEmpty && !self.txtRoomTime.text!.isEmpty {
            let calendar = Calendar.current
            var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self.selectedDate)
            
            let timeComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self.selectedTime)
            dateComponents.hour = timeComponents.hour
            dateComponents.minute = timeComponents.minute
            
            self.selectedDateTime = Calendar.current.date(from: dateComponents)!
            self.tblRoomAvailability.isHidden = false
            
            if self.roomsList.isEmpty {
                self.loadJsonFromUrl(refreshTable: true)
            }
            else {
                self.tblRoomAvailability.reloadData()
            }
        }
    }
    
    // MARK: - Segue navigation function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SortRoom") {
            let embedVC = segue.destination as! SortFieldsViewController
            sortController = embedVC
            sortController?.delegate = self
        }
    }
}

