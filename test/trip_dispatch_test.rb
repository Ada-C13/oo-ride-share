require_relative 'test_helper'

TEST_DATA_DIRECTORY = 'test/test_data'

describe "TripDispatcher class" do
  def build_test_dispatcher
    return RideShare::TripDispatcher.new(
      directory: TEST_DATA_DIRECTORY
    )
  end

  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      dispatcher = build_test_dispatcher
      expect(dispatcher).must_be_kind_of RideShare::TripDispatcher
    end

    it "establishes the base data structures when instantiated" do
      dispatcher = build_test_dispatcher
      [:trips, :passengers].each do |prop|
        expect(dispatcher).must_respond_to prop
      end

      expect(dispatcher.trips).must_be_kind_of Array
      expect(dispatcher.passengers).must_be_kind_of Array
      expect(dispatcher.drivers).must_be_kind_of Array
    end

    it "loads the development data by default" do
      # Count lines in the file, subtract 1 for headers
      trip_count = %x{wc -l 'support/trips.csv'}.split(' ').first.to_i - 1

      dispatcher = RideShare::TripDispatcher.new

      expect(dispatcher.trips.length).must_equal trip_count
    end
  end

  describe "passengers" do
    describe "find_passenger method" do
      before do
        @dispatcher = build_test_dispatcher
      end

      it "throws an argument error for a bad ID" do
        expect{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
      end

      it "finds a passenger instance" do
        passenger = @dispatcher.find_passenger(2)
        expect(passenger).must_be_kind_of RideShare::Passenger
      end
    end

    describe "Passenger & Trip loader methods" do
      before do
        @dispatcher = build_test_dispatcher
      end

      it "accurately loads passenger information into passengers array" do
        first_passenger = @dispatcher.passengers.first
        last_passenger = @dispatcher.passengers.last

        expect(first_passenger.name).must_equal "Passenger 1"
        expect(first_passenger.id).must_equal 1
        expect(last_passenger.name).must_equal "Passenger 8"
        expect(last_passenger.id).must_equal 8
      end

      it "connects trips and passengers" do
        dispatcher = build_test_dispatcher
        dispatcher.trips.each do |trip|
          expect(trip.passenger).wont_be_nil
          expect(trip.passenger.id).must_equal trip.passenger_id
          expect(trip.passenger.trips).must_include trip
        end
      end
    end
  end

  # TODO: un-skip for Wave 2
  describe "drivers" do
    describe "find_driver method" do
      before do
        @dispatcher = build_test_dispatcher
      end

      it "throws an argument error for a bad ID" do
        expect { @dispatcher.find_driver(0) }.must_raise ArgumentError
      end

      it "finds a driver instance" do
        driver = @dispatcher.find_driver(2)
        expect(driver).must_be_kind_of RideShare::Driver
      end
    end

    describe "Driver & Trip loader methods" do
      before do
        @dispatcher = build_test_dispatcher
      end

      it "accurately loads driver information into drivers array" do
        first_driver = @dispatcher.drivers.first
        last_driver = @dispatcher.drivers.last

        expect(first_driver.name).must_equal "Driver 1 (unavailable)"
        expect(first_driver.id).must_equal 1
        expect(first_driver.status).must_equal :UNAVAILABLE
        expect(last_driver.name).must_equal "Driver 3 (no trips)"
        expect(last_driver.id).must_equal 3
        expect(last_driver.status).must_equal :AVAILABLE
      end

      it "connects trips and drivers" do
        dispatcher = build_test_dispatcher
        dispatcher.trips.each do |trip|
          expect(trip.driver).wont_be_nil
          expect(trip.driver.id).must_equal trip.driver_id
          expect(trip.driver.trips).must_include trip
        end
      end
    end
  end

  describe "trips" do
    before do
      @dispatcher = build_test_dispatcher
    end

    #Was the trip created properly?
    it "creates the trip properly" do
      # Act
      test_trip = @dispatcher.request_trip(1)

      # Asserts
      expect(test_trip.id).must_be_kind_of Integer
      expect(test_trip.passenger_id).must_equal 1
      expect(test_trip.driver).must_be_kind_of RideShare::Driver
      expect(test_trip.driver_id).must_equal 2
      expect((test_trip.driver).name).must_equal "Driver 2"
      expect(test_trip.cost).must_equal nil
      expect(test_trip.start_time).must_be_kind_of Time
      expect(test_trip.end_time).must_equal nil
      expect(test_trip.rating).must_equal nil
    
    end
  
    # Were the trip lists for the driver and passenger updated?
    it "updates the lists  for the driver and passengers" do

      test_driver= @dispatcher.find_driver(2)
      test_passenger= @dispatcher.find_passenger(1)

      driver_old_trips_count = (test_driver.trips).length
      passenger_old_trips_count = (test_passenger.trips).length

      test_trip = @dispatcher.request_trip(1)

      driver_new_trips_count = (test_driver.trips).length
      passenger_new_trips_count = (test_passenger.trips).length

      expect(driver_new_trips_count).must_equal (driver_old_trips_count + 1)
      expect(passenger_new_trips_count).must_equal (passenger_old_trips_count + 1)
    
    end

    #Was the driver who was selected AVAILABLE?
    it "selects an available driver" do
      test_trip = @dispatcher.request_trip(1)
      expect((test_trip.driver).name).must_equal "Driver 2"
    end

    #What happens if you try to request a trip when there are no AVAILABLE drivers?
    it "raises an ArgumentError when there are no available drivers" do
      (@dispatcher.drivers).each do |driver|
        driver.status = :UNAVAILABLE
      end
      expect{ (test_trip = @dispatcher.request_trip(1)) }.must_raise ArgumentError
    end

  end
end
