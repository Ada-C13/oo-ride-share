require_relative 'test_helper'
require 'time'

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.now - 60 * 60 # 60 minutes
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3
      }
      @trip = RideShare::Trip.new(@trip_data)
    end
    
    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of passenger" do
      expect(@trip.passenger).must_be_kind_of RideShare::Passenger
    end

    it "stores an instance of driver" do
      skip # Unskip after wave 2
      expect(@trip.driver).must_be_kind_of RideShare::Driver
    end

    it "raises an error for an invalid rating" do
      [-3, 0, 6].each do |rating|
        @trip_data[:rating] = rating
        expect do
          RideShare::Trip.new(@trip_data)
        end.must_raise ArgumentError
      end
    end

  # TODO 1.1 raise ArgumentError if end time is before start time
    it "raises an error if the end time is before start time" do
      # Arrange
      # TODO start times later than end times array
      # Array of end times that are earlier of start times
      # start_time array that are later times

      start_time = "2018-12-27 03:38:08 -0800"
      end_time = "2018-12-27 02:39:05 -0800"

      # Act and Assert
      @trip_data[:start_time] = start_time
      @trip_data[:end_time] = end_time
      expect {RideShare::Trip.new(@trip_data)}.must_raise ArgumentError
      # partially done through before block


    end    
  end
end
