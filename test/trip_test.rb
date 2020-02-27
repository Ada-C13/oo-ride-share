require_relative 'test_helper'

describe "Trip class" do
  describe "initialize" do
    # TODO: Change to let
    before do
      start_time = Time.now - 60 * 60 # 60 minutes
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        driver_id: 5,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        driver: RideShare::Driver.new(
          id: 2,
          name: "Ada",
          vin: "12354657463524376"
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

    it "accurately calculates duration in seconds" do
      # if we call trip_duration on an instance of a trip
      # it will return the duration in seconds
      expect(@trip.trip_duration).must_equal 1500
    end
  end
   
    describe "initializing ArgumentErrors" do
      it "must raise argument error if end_time is before start_time" do
        start_time = Time.parse("Thu Nov 29 15:33:20 2020")
        end_time = Time.parse("Thu Nov 29 14:33:20 2020")
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

        expect{ RideShare::Trip.new(@trip_data) }.must_raise ArgumentError
      end
    end

end

