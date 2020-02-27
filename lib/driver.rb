require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips:)
      super(id)

      unless vin.length == 17
        raise ArgumentError 'vin length has to be 17'
      end

      @name = name
      @vin = vin
      @status = status
      @trips = trips || []
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