require_relative 'csv_record'

# Since Driver inherits from CsvRecord, you'll need to implement the from_csv template method. Once you do, Driver.load_all should work (test this in pry).
# Use the provided tests to ensure that a Driver instance can be created successfully and that an ArgumentError is raised for an invalid status.
module RideShare
    class Driver < CsvRecord
        def initialize(id:, name: vin: status: trips:)
            super(id)
            @name = name
            @vin = vin
            @status = status
            @trips = trips || []
        end

        def self.from_csv(record)
            return self.new(
              id: record[:id],
              name: record[:name],
              vin: record[:vin],
              status: record[:status].to_sym
            )
          end

    end
end

# we will need to update the Trip class to include a reference to the trip's driver. 
# Add the following attributes to the Trip class:

# Attribute |	Description
# driver_id |	The ID of the driver for this trip
# driver    |	The Driver instance for the trip

# When a Trip is constructed, either driver_id or driver must be provided.

# Note: You have changed the method signature of the constructor for Trip. Some of your tests may now be failing. Go fix them!

# Update the TripDispatcher class as follows:

# In the constructor, call Driver.load_all and save the result in an instance variable
# Update the Trip#connect method to connect the driver as well as the passenger (you'll want to create add trip on driver first - see below)
# Add a find_driver method that looks up a driver by ID

# After each Trip has a reference to its Driver and TripDispatcher can load a list of Drivers, add the following functionality to the Driver class:

# Method         |	Description                              |	Test Cases
# add_trip       |	Add a trip to the driver's list of trips |	Try adding a trip
# average_rating |	What is this driver's average rating?    |	What if there are no trips? Does it handle floating point division correctly? For example the average of 2 and 3 should be 2.5, not 2.

# total_revenue	 |  This method calculates that driver's total revenue across all their trips. Each driver gets 80% of the trip cost after a fee of $1.65 per trip is subtracted.	
# | What if there are no trips? What if the cost of a trip was less that $1.65?

# All the new methods above should have tests