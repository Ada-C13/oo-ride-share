require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips
    
    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      
      @name = name
      @vin = vin
      if @vin.length != 17
        raise ArgumentError, "vin length must be 17 characters"
      end
      @status = status.to_sym
      valid_status = [:AVAILABLE, :UNAVAILABLE]
      
      if !(valid_status.include? status.to_sym)
        raise ArgumentError, "invalid status"
      end
      
      @trips = trips || []
      
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def avg_rating 
      all_trips = @trips.map { |trip| trip.rating }.sum
      trip_count = @trips.length
      
      average_rating = all_trips / trip_count
      
      return average_rating
    end

    def total_revenue

    end
    
    private
    
    def self.from_csv(record)
      return Driver.new( 
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status]
      )
    end
    
  end # end Driver Class
  
end # end Rideshare

# drivers = RideShare::Driver.load_all(full_path: '../support/drivers.csv')
# ap drivers


# if status does not equal :AVALIABLE || :UNAVAILABLE
# raise ArgumentError, "status must be :available or un...
# end"
# if !([:AVAILABLE, :UNAVAILABLE].include? @status) 
#   raise ArgumentError, "status must be :AVAILABLE or :UNAVAILABLE"
# end


# if status != :AVAILABLE || status != :UNAVAILABLE
#   raise ArgumentError, "status must be :AVAILABLE or :UNAVAILABLE"
# end