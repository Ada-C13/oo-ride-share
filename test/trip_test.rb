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
        #Adding driver data to trip 
        driver: RideShare::Driver.new(
          id: 7,
          name: "Lak Kate",
          vin: "1C9YKKLR1BV5564A7",
          status: :AVAILABLE,
          trips: nil
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
      # skip # Unskip after wave 2
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

    it "raises an error because end time is before the start time" do
      # if start_time > end_time #https://ruby-doc.org/core-2.6.3/Time.html
      #   raise ArgumentError.new("Invalid, start time must be before end time")
      # end
      #what do we need: testing the initialize by creating a Trip object
      @trip_data[:start_time] = Time.parse("2018-12-27 02:00:00 -0800")
      @trip_data[:end_time] = Time.parse("2018-12-27 01:00:00 -0800")
      expect{RideShare::Trip.new(@trip_data)}.must_raise ArgumentError
      
    end
    
    describe "duration" do
      it "calculates a one minute duration" do
        @trip_data[:start_time] = Time.parse("2018-12-27 02:00:00 -0800")
        @trip_data[:end_time] = Time.parse("2018-12-27 02:01:00 -0800")
        test_time = RideShare::Trip.new(@trip_data)
        expect(test_time.duration()).must_equal 60
      
      end
    end
  end
end
