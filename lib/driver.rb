require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord

  attr_reader :name, :vin, :trips, :status
  

  def initialize (id:, name:, vin:, status: :AVAILABLE, trips: nil)
    super(id)

    @name = name
    @vin = vin
    @status = status.to_sym
    @trips = trips || []
  
    vin_pattern = /^[A-Z0-9]{17}$/i
    if (vin_pattern =~ @vin) == nil
      raise ArgumentError, "Invalid VIN"
    end

  end

  def add_trip(trip)
    @trips << trip
  end

  private

  def self.from_csv(record)
    return new(
    # or can use Passenger.new(
    # or can use new(
      id: record[:id],
      name: record[:name],
      vin: record[:vin],
      status: record[:status]
    )
  end

  end
end
