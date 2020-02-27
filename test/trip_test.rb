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
        rating: 3,
        driver: RideShare::Driver.new(
          id: 54,
          name: "Rogers Bartell IV",
          vin: "1C9EVBRM0YBC564DZ"
        )
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
      # Unskip after wave 2
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

    it "each start and stop time in array is a Time instance" do
      expect(@trip.start_time).must_be_kind_of Time
      expect(@trip.end_time).must_be_kind_of Time
    end    
  end

  describe "validating time inputs" do
    it "throws an argument error with a bad start/end time (different dates)" do
      expect do
        RideShare::Trip.new(id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: Time.new(2016, 8, 11),
        end_time: Time.new(2016, 8, 9),
        cost: 23.45,
        rating: 3,
        driver_id: 1
      )
      end.must_raise ArgumentError
    end

    it "throws an argument error with a bad start/end time (same date)" do
      expect do
        RideShare::Trip.new(id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: Time.new(2016, 8, 11) + 6*60*60,
        end_time: Time.new(2016, 8, 11) + 4*60*60,
        cost: 23.45,
        rating: 3,
        driver_id: 1
      )
      end.must_raise ArgumentError
    end
  end

  describe "calculate_trip_duration" do
    it "returns the time elapsed in seconds" do
      expect do
        RideShare::Trip.new(id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: Time.new(2016, 8, 11) + 4*60*60,
        end_time: Time.new(2016, 8, 11) + 6*60*60,
        cost: 23.45,
        rating: 3,
        driver_id: 1
      ).must_equal 7200
      end
    end 

    it "returns 0 if start and end time are the same" do
      expect do
        RideShare::Trip.new(id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: Time.new(2016, 8, 11),
        end_time: Time.new(2016, 8, 11),
        cost: 23.45,
        rating: 3,
        driver_id: 1
      ).must_equal 0
      end
    end
  end
end
