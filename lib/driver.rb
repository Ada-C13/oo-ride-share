require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord

  attr_reader :name, :vin, :trips, :status
  
  def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
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

  def change_status
    @status = :UNAVAILABLE
  end

  # Wave 2 get average rating for a driver
  def average_rating
    nil_cases = 0

    if @trips.empty? == true
      return 0
    else
      @trips.each do |trip|
        if trip.rating == nil
          nil_cases += 1
        end
      end

      average_rating = (@trips).map do |trip|
        if trip.rating == nil
          0
        else
        (trip.rating).to_f
        end
      end

      
      cost = ((average_rating).inject(:+))/((average_rating.length) - nil_cases)
      return cost
    end
  end

  # Wave 2 total revenue method
  def total_revenue
    if @trips.empty? == true
      return 0
    else
      cost_array = (@trips).map do |trip|
        trip.cost
      end
    end 

    total = (cost_array.sum - 1.65) * 0.80

    total <= 0? 0 : total
  end

  private

  def self.from_csv(record)
    return new(
      id: record[:id],
      name: record[:name],
      vin: record[:vin],
      status: record[:status]
    )
  end
  end
end
