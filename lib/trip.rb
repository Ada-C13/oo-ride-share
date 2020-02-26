require 'csv'

require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating

    def initialize(
          id:,
          passenger: nil,
          passenger_id: nil,
          start_time:,
          end_time:,
          cost: nil,
          rating:
        )
      super(id)

      if passenger
        @passenger = passenger
        @passenger_id = passenger.id

      elsif passenger_id
        @passenger_id = passenger_id

      else
        raise ArgumentError, 'Passenger or passenger_id is required'
      end

      if start_time.class == String
        start_time = Time.parse(start_time) # added Time.parse to turn string into time, if it was passed as a string.
      end
      @start_time = start_time 

      if end_time.class == String
        end_time = Time.parse(end_time) # added Time.parse to turn string into time
      end
      @end_time = end_time

      if @end_time < @start_time
        raise ArgumentError, "End time cannot be before start time."
      end
      
      @cost = cost
      @rating = rating

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end

    def duration
      return (@end_time - @start_time)
    end

    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
        "ID=#{id.inspect} " +
        "PassengerID=#{passenger&.id.inspect}>"
    end

    def connect(passenger)
      @passenger = passenger
      passenger.add_trip(self)
    end

    def duration
      return @end_time - @start_time
    end


    private # only the class can call these, not from an instance of the class

    # This is how we load the csv file. We create a new object here.
    def self.from_csv(record) # overiding empty method from csv
      return self.new(
               id: record[:id],
               passenger_id: record[:passenger_id],
               start_time: record[:start_time],
               end_time: record[:end_time], 
               cost: record[:cost],
               rating: record[:rating]
             )
    end
  end
end
