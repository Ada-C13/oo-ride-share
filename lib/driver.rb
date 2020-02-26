require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name

      if (vin.is_a? String)  && vin.length == 17
        @vin= vin
      else
        raise ArgumentError.new("Vin must be 17 characters long")
      end

      if status == :AVAILABLE || status == :UNAVAILABLE
        @status = status
      else
        raise ArgumentError.new("Status must be AVAILABLE or UNAVAILABLE")
      end
    
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    # def net_expenditures
    #   cost_array = @trips.map {|trip|trip.cost}
    #   total_cost = cost_array.sum
    #   return total_cost
    # end

    # def total_time_spent
    #   time_array = @trips.map{|trip|trip.duration}
    #   total_time = (time_array.sum / 60).to_i
    #   puts "The total time spent on trips is #{total_time} minutes" 
    #   return total_time
    # end

    private

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym
      )
    end
  end
end
