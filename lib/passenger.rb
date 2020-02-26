require_relative "csv_record"

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips

    def initialize(id:, name:, phone_number:, trips: nil)
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips || []
    end

    def add_trip(trip) #where is add_trip being called?? 
      @trips << trip 
    end

    # ! TODO add no trips
    def net_expenditures
      # if @trips == nil
      #   raise ArgumentError.new("This passenger has no trips")
      # else
      total_cost = 0
      @trips.each do |trip|
        total_cost += trip.cost
      end
      return total_cost
      # end
    end

    # total_trips = @trips.map do |trip|
    #   trip.cost
    # end

    # return total_trips.sum
    # if @trips.length > 0 && @trips.length != nil
    #   total_trips = @trips.map do |trip|
    #     trip.cost
    #   end
    #   total_trips.sum
    # else
    #   raise ArgumentError.new("This passenger doesn't have any trips.")
    # end

    def total_time_spent
      total_time = 0
      @trips.each do |trip|
        total_time += trip.duration
      end
      return total_time
    end

    private

    def self.from_csv(record) #Passenger.new, new, @new, self.new 
      return new(
               id: record[:id],
               name: record[:name],
               phone_number: record[:phone_num],
             )
    end
  end
end
