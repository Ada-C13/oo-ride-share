require_relative "test_helper"
require "time"

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
          phone_number: "412-432-7640",
        ),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3,
        driver: RideShare::Driver.new(id: 20, name: "Renoir", vin: "SAR73WZ23J2SEJGJS", status: :UNAVAILABLE),
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

    # Test for ArgumentError if the end time is before the start time
    it "raises an error if end time is before start time" do
      start_time = Time.now
      end_time = start_time - 25 * 60 # earlier than start_time
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640",
        ),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3,
        driver: RideShare::Driver.new(
          id: 1,
          name: "Da Vinci",
          vin: "RFWNJWGU3Y8SD2VP0",
          status: :AVAILABLE,
        ),
      }
      expect { RideShare::Trip.new(@trip_data) }.must_raise ArgumentError
    end
  end
  # Wave 1: Test for Trip class instance method to calculate the duration of the trip in seconds
  describe "calculate duration" do
    it "finds trip duration in seconds" do
      start_time = Time.parse("2018-12-27 02:00:00 -0800")
      end_time = Time.parse("2018-12-27 02:01:00 -0800")
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640",
        ),
        start_time: start_time,
        end_time: end_time,
        cost: 23.45,
        rating: 3,
        driver: RideShare::Driver.new(
          id: 1,
          name: "Da Vinci",
          vin: "RFWNJWGU3Y8SD2VP0",
          status: :AVAILABLE,
        ),
      }
      @trip = RideShare::Trip.new(@trip_data)
      expect(@trip.calculate_duration).must_equal 60
    end
  end
end
