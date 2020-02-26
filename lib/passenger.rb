require_relative 'csv_record'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips

    def initialize(id:, name:, phone_number:, trips: nil)
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
      #or self.trips<< trip
    end

    # 1.2 #1 net_expenditures method
    def net_expenditures
      cost_array = (@trips).map do |trip|
        trip.cost
      end 
      return (cost_array).inject(:+)
    end

    # 1.2 #2 total_time_spent method
    def total_time_spent
      time_duration = (@trips).map do |trip|
        Time.parse(trip.end_time) - Time.parse(trip.start_time)
      end
      return (time_duration).inject(:+)
    end

    private

    def self.from_csv(record)
      return new(
      # or can use Passenger.new(
      # or can use new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end
  end
end

