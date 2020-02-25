require 'csv'
require 'time'

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
        start_time = Time.parse(start_time)
      end
      @start_time = start_time

      if end_time.class == String 
        end_time = Time.parse(end_time)
      end
      @end_time = end_time


      @cost = cost
      @rating = rating

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if end_time < start_time
        raise ArgumentError.new("End time #{end_time} is before  start time #{start_time}")
      end

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

    private

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               passenger_id: record[:passenger_id],
               start_time: record[:start_time], # nn to turn into Time class
               end_time: record[:end_time], # nn to turn into Time class  before passing into initialize 
               cost: record[:cost],
               rating: record[:rating]
             )
    end
  end
end

# all_trips = RideShare::Trip.load_all(full_path: "./support/trips.csv"

# td = RideShare::TripDispatcher.new
# td.trips[1].start_time