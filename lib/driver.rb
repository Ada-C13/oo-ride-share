require_relative "csv_record"

# Since Driver inherits from CsvRecord, you'll need to implement the from_csv template method. Once you do, Driver.load_all should work (test this in pry).
# Use the provided tests to ensure that a Driver instance can be created successfully and that an ArgumentError is raised for an invalid status.
module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin: nil, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name

      if vin.length != 17
        raise ArgumentError, "vin must be 17 characters long"
      end
      @vin = vin

      @status = status
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      rating_total = 0
      if @trips.empty?
        return 0
      else
        @trips.each do |trip|
          rating_total += trip.rating
        end
        return rating_total / @trips.length.to_f.round(2)
      end
    end

    def total_revenue
      total_revenue = 0
      if @trips.empty?
        return 0
      else
        @trips.each do |trip|
          if trip.cost >= 1.65
            total_revenue += trip.cost * 0.8 - 1.65
          else
            total_revenue
          end
        end
      end
      return total_revenue
    end

    private

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status].to_sym,
               #   trips: record[:trips],
               #   total_revenue: record[:total_revenue]
             )
    end
  end
end

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
