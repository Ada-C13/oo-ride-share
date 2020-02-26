require 'csv'
require_relative 'csv_record'

# To load into pry, do : pry -r ./becca_driver.rb 

module RideShare
  class Driver < CsvRecord

    attr_reader :name, :vin, :status, :trips
    
    def initialize(
          id:,
          name:,
          vin:,
          status: :UNAVAILABLE,
          trips: nil
        )
      super(id)

      @name = name
      @vin = vin
      @status = status
      unless (status == :AVAILABLE || status == :UNAVAILABLE)
        raise ArgumentError
      end
      @trips = trips || []
      @drivers = []
      # return self
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
    def add_driver(driver)
      @drivers << driver
    end


    private

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status],
               trips: record[:trips]
             )
    end
    
  end
end
