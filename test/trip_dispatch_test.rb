require_relative 'test_helper'

TEST_DATA_DIRECTORY = 'test/test_data'

describe "TripDispatcher class" do
  def build_test_dispatcher
    return RideShare::TripDispatcher.new(directory: TEST_DATA_DIRECTORY)
  end

  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      dispatcher = build_test_dispatcher
      expect(dispatcher).must_be_kind_of RideShare::TripDispatcher
    end

    it "establishes the base data structures when instantiated" do
      dispatcher = build_test_dispatcher
      [:trips, :passengers, :drivers].each do |prop|
        expect(dispatcher).must_respond_to prop
      end

      expect(dispatcher.trips).must_be_kind_of Array
      expect(dispatcher.passengers).must_be_kind_of Array
    end

    it "loads the development data by default" do
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

  describe "Does request_trip work" do
    before do
      @dispatcher = build_test_dispatcher 
    end

    it "returns a trip" do
      trip = @dispatcher.request_trip(2) 
      expect(trip).must_be_kind_of RideShare::Trip
    end

    it "updated the trip list for the dispatcher" do
      count_before = @dispatcher.trips.length 
      trip = @dispatcher.request_trip(2) 
      expect(@dispatcher.trips.length).must_equal count_before + 1
    end

    it "assigned a driver" do
      trip = @dispatcher.request_trip(2) 
      expect(trip.driver).must_be_kind_of RideShare::Driver 
    end

    it "assigned an available driver" do 
      drivers_before = {}
      @dispatcher.drivers.each { |driver| drivers_before[driver.id] = driver.status}
      trip = @dispatcher.request_trip(2) 
      before_status = drivers_before[trip.driver_id]
      after_status  = trip.driver.status

      expect(before_status).must_equal :AVAILABLE
      expect(after_status).must_equal :UNAVAILABLE
    end

    it "updated the trip list for the driver" do
      drivers_before = {}
      @dispatcher.drivers.each { |driver| drivers_before[driver.id] = driver.trips.length}
      trip = @dispatcher.request_trip(2) 
      before_trips = drivers_before[trip.driver_id]
      after_trips = trip.driver.trips.length 

      expect(after_trips).must_equal before_trips + 1
      expect(trip).must_equal trip.driver.trips.last
    end

    it "updated the trip list for the passengers" do
      before_trips = @dispatcher.find_passenger(2).trips.length
      trip = @dispatcher.request_trip(2) 
      
      after_trips = trip.passenger.trips.length 
      expect(after_trips).must_equal before_trips + 1
      expect(trip).must_equal trip.passenger.trips.last
    end

    it "fails if no driver is available" do
      trip1 = @dispatcher.request_trip(1) 
      trip2 = @dispatcher.request_trip(2) 
      expect { @dispatcher.request_trip(3) }.must_raise ArgumentError
    end
  end

  describe "Does request_trip_optimized work" do
    before do
      @dispatcher = build_test_dispatcher 
    end

    it "returns a trip" do
      trip = @dispatcher.request_trip_optimized(2) 
      expect(trip).must_be_kind_of RideShare::Trip
    end

    it "updated the trip list for the dispatcher" do
      count_before = @dispatcher.trips.length               
      
      trip = @dispatcher.request_trip_optimized(2)          
      expect(@dispatcher.trips.length).must_equal count_before + 1
    end

    it "assigned a driver" do
      trip = @dispatcher.request_trip_optimized(2)         
      expect(trip.driver).must_be_kind_of RideShare::Driver 
    end

    it "assigned an available driver" do 
      drivers_before = {}
      @dispatcher.drivers.each { |driver| drivers_before[driver.id] = driver.status}
      trip = @dispatcher.request_trip_optimized(2) 
      before_status = drivers_before[trip.driver_id]
      after_status  = trip.driver.status

      expect(before_status).must_equal :AVAILABLE
      expect(after_status).must_equal :UNAVAILABLE
    end

    it "updated the trip list for the driver" do
      drivers_before = {}
      @dispatcher.drivers.each { |driver| drivers_before[driver.id] = driver.trips.length}
      trip = @dispatcher.request_trip_optimized(2) 
      before_trips = drivers_before[trip.driver_id]
      after_trips = trip.driver.trips.length 

      expect(after_trips).must_equal before_trips + 1
      expect(trip).must_equal trip.driver.trips.last
    end

    it "updated the trip list for the passengers" do
      before_trips = @dispatcher.find_passenger(2).trips.length
      trip = @dispatcher.request_trip_optimized(2)  
      after_trips = trip.passenger.trips.length 

      expect(after_trips).must_equal before_trips + 1
      expect(trip).must_equal trip.passenger.trips.last
    end

    it "fails if no driver is available" do
      trip1 = @dispatcher.request_trip_optimized(1) 
      trip2 = @dispatcher.request_trip_optimized(2) 
      expect { @dispatcher.request_trip_optimized(3) }.must_raise ArgumentError
    end

    it "does not select a driver with an in progress trip" do
      trip1 = @dispatcher.request_trip_optimized(1) 
      trip1.driver.status = :AVAILABLE              
      trip2 = @dispatcher.request_trip_optimized(2) 
      expect(trip1.driver).wont_equal trip2.driver  
    end

    it "prefers drivers that have never driven" do
      trip = @dispatcher.request_trip_optimized(1) 
      expect(trip.driver.id).must_equal 3          
    end

    it "prefers a driver with the oldest most recent trip" do
      trip1 = @dispatcher.request_trip_optimized(1) 
      @dispatcher.drivers.first.status = :AVAILABLE 
      trip2 = @dispatcher.request_trip_optimized(2) 
      expect(trip2.driver.id).must_equal 1          
    end

  end
end
