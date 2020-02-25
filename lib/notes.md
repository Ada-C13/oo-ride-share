Classes and Relationships

- What inheritance relations exist between classes?
Parent:  CSV_Record
Child:  Passenger & Trip

Standalone: Trip_dispatcher


- What composition relations exist between classes?
A trip has one passenger 
A passenger can have zero, one, or many trips


- Do these relations match your prediction from earlier?
For Leah, no.
For Charlotte, one to many with passengers (trip to passengers)

Seems like trip to passenger is more like one to one
But passenger to trip is one to many


- Draw a class diagram that contains all of the above relations.
We did it!


Code Details

- Why doesn't Passenger or Trip need an attr_reader for id?
It inherits id from CSV_Record (its parent) by using super

- Why does the version of from_csv in CsvRecord raise a NotImplementedError? What does this mean? Why don't we hit that when we run the code?
We are not sure why this happens or even why the method needs to live in CSV_Record since Trip & Passenger classes don't inherit any of its specification; 

We changed our minds!  from_csv is invoked within the self.load_all method, so that's why it has to be included in the CSV_Record class; however you have to call it within the class or from its child classes to be used.  It would not return any functional information since that is not defined in the method and its intent is to parse CSV data from its child classes which want different data from the method 

- Why is from_csv a private method?
Private methods tell Ruby that all methods defined from here on out are supposed to be private - it is an encryption
YThey can be called from within the object (from other methods that the class defines) but not outside

- How does CsvRecord.load_all know what CSV file to open?
It takes in a full path, directory, and/or file name.  
If full_path is true, it uses that as the CSV file path to read
If full_path is false, it uses the build_path method to build a full file path with directory and filename parameters (and build_path has error handling for invalid directory and can set its own filename)

- When you call Passenger.load_all, what happens? What methods are called in what order?
It takes in a file name (full path or built by build_path) and returns the CSV info formatted by the from_csv method written in passenger (self.from_csv) ==> it will give us id, name, and phone number


Using the Library

Using the pry session we started above, how would you...

- Print the rating for the first trip
td.trips[0].rating

- Print the name of the passenger for trip 7


- Print the ID of every trip taken by passenger 9

- Print the ID of the trip that cost the most money
