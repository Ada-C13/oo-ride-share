require 'csv'
require_relative 'csv_record'

# From already inside lib, load into pry by doing: pry -r ./becca_driver.rb 
# From root directory:  pry -r ./lib/driver.rb"

module RideShare
  class Driver < CsvRecord

    attr_reader :name, :vin, :trips
    attr_accessor :status, :trips
    
    def initialize(
          id:,
          name:,
          vin:,
          status: :AVAILABLE,
          trips: nil
        )
      super(id)

      @name = name
      @vin = vin
      unless vin.length == 17
        raise ArgumentError
      end
      @status = status
      unless (status == :AVAILABLE || status == :UNAVAILABLE)
        raise ArgumentError
      end
      @trips = trips || []
      unless super(id)> 0 
        raise ArgumentError
      end
    end

    # def inspect
    #   # Prevent infinite loop when puts-ing a Trip
    #   # trip contains a passenger contains a trip contains a passenger...
    #   "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
    #     "ID=#{id.inspect} " +
    #     "PassengerID=#{passenger&.id.inspect}>"
    # end

    # def connect(passenger)
    #   @passenger = passenger
    #   passenger.add_trip(self)
    # end
    def add_trip(trip)
      @trips << trip
    end
    
    def average_rating
      sum_rating = 0.0
      if @trips.length == 0
        return 0
      else
        @trips.each do |trip|
          sum_rating += trip.rating 
        end
      end
      return sum_rating/@trips.length
    end

    def total_revenue
      revenue = 0.0
      if @trips.length == 0
        return 0
      else
        @trips.each do |trip|
          revenue += trip.cost
        end
      end
      if revenue > (1.65*@trips.length)
      total_revenue = (revenue - (1.65 * @trips.length))* 0.8
      return total_revenue
      else 
        return 0
      end
    end


    # RideShare::Driver.load_all was not working before because it expected a keyword argument first, then the full path value
    # Status was expecting a symbol but is read from the CSV.read method as a string. So, we had to change the from_csv method for status to be a symbol

    def add_requested_trip(trip)
      @trips << trip
    end




    private

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status].to_sym,
               trips: record[:trips]
             )
    end
    
  end
end
