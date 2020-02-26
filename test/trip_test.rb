require_relative 'test_helper'

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

    it "accurately finds time length of ride" do
      time_a = "2018-12-27 02:39:05 -0800"
      time_b = "2018-12-27 03:38:08 -0800"
  
      difference = Time.parse(time_b) - Time.parse(time_a)

      if difference > 0
        return difference
      else
       return  24 * 3600 + difference
      end

      expect(difference).must_equal(3543.0)
    end

    it "raises error when end_time or start_time is not Time object" do
      test_trip = {
        id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: "2018-12-27 03:38:08 -0800",
        end_time: "2018-12-27 02:39:05 -0800",
        cost: 23.45,
        rating: 3,
        trip_time: 3543.0
      }

      expect {RideShare::Trip.new(test_trip)}.must_raise ArgumentError
    end

    it "raises error when end_time is less than start_time" do
      test_trip = {
        id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: Time.parse("2018-12-27 03:38:08 -0800"),
        end_time: Time.parse("2018-12-27 02:39:05 -0800"),
        cost: 23.45,
        rating: 3,
        trip_time: 3543.0
      }

      expect {RideShare::Trip.new(test_trip)}.must_raise ArgumentError
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
        expect {RideShare::Trip.new(@trip_data)}.must_raise ArgumentError
      end
    end
  end
end