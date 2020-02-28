require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord

    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id: nil, name: nil, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      @vin = vin
      @status = status
      @trips = trips || []

      unless @status == :AVAILABLE || @status == :UNAVAILABLE
        raise ArgumentError.new("#{@status} is not a valid status.")
      end

      unless @vin.split(//).length == 17
        raise ArgumentError.new("#{@vin} is not a valid VIN number.")
      end

    end

  def add_trip(trip)
    unless trip.end_time == nil
      @trips << trip
    end
  end

  def average_rating
    ratings = []
    if @trips.length == 0
      return 0
    end

    @trips.each do |trip|
      unless trip.end_time == nil
        ratings << trip.rating
      end
    end

    return (ratings.sum.to_f / ratings.length.to_f)
  end

  def total_revenue
    total_revenue = 0
    total_revenue = @trips.sum { 
      |trip| unless trip.cost == nil
      trip.cost 
    end
    }
    return total_revenue
  end

  def change_driver_status
    if @status == :AVAILABLE
      @status = :UNAVAILABLE
    else
      @status = :AVAILABLE
    end
  end

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