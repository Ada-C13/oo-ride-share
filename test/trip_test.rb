require_relative 'test_helper'
require "time.rb"

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
        rating: 3,
        driver_id: 2
      }
      @trip = RideShare::Trip.new(@trip_data)
        @driver = RideShare::Driver.new(
          id: 54,
          name: "Test Driver",
          vin: "12345678901234567",
          status: :AVAILABLE
        )
    end

    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of passenger" do
      expect(@trip.passenger).must_be_kind_of RideShare::Passenger
    end

    it "raises an ArgumentError if start time occurs after end time (start time > end time)" do 
      start_time = Time.now + 120 * 60 # add 2 hours to start
      end_time = Time.now - 60 * 60 # subtract 1 hour from end
      
      new_trip = { # make a fake bad trip with start time happening WAY after end time
        id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3,
        driver: @driver
      }

      expect{fake_trip = RideShare::Trip.new(new_trip)}.must_raise ArgumentError




    end

    # tests to make sure the "duration_in_seconds" method for Trip objects returns 
    # the duration of a trip ( end time minus start time ) in seconds
    it "calculates the duration of a trip in seconds" do
      duration_of_trip = @trip.duration_in_seconds
      expect(duration_of_trip).must_equal 1500.0
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
  end
end
