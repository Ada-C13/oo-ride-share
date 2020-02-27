require 'pry'
require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status

    def initalize(id:, name:, vin:, status:, trips:)
     super(id)

      @name = name
      @vin = "".length(17) # Test this
      @status = :AVAILABLE || :UNAVAILABLE
      @trips = trips || []
    end 

    def self.from_csv(record)
     return new(
       id:record[:id],
       name:record[:name],
       vin:record[:vin],
       status:record[:status]
      )
    end

    #This needs class-specific parameters added
    def self.load_all(full_path: nil, directory: nil, file_name: nil)
     full_path ||= build_path(lib, driver.rb)
    end
  end 
end