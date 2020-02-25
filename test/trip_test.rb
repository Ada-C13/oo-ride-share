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

    it "throws ArgumentError if start_time is after end_time" do
      this_end_time = Time.now - 60 * 60 # 60 minutes
      this_start_time = this_end_time + 25 * 60 # 25 minutes
      @this_trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: this_start_time,
        end_time: this_end_time,
        cost: 23.45,
        rating: 3
      }

      expect { RideShare::Trip.new(@this_trip_data) }.must_raise ArgumentError
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

  describe "duration method" do
    it "returns duration of trip in seconds" do 
  
      this_start_time = Time.parse('2019-12-31 02:00:00 -0800')
      this_end_time = Time.parse('2019-12-31 02:30:00 -0800')

      @this_trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(
          id: 1,
          name: "Ada",
          phone_number: "412-432-7640"
        ),
        start_time: this_start_time,
        end_time: this_end_time,
        cost: 23.45,
        rating: 3
      }

      trip_example = RideShare::Trip.new(@this_trip_data)
      expect(trip_example.duration).must_equal 1800.0
    end 
  end 
end
