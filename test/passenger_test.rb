require_relative 'test_helper'

describe "Passenger class" do

  let (:passenger) {
    RideShare::Passenger.new(
      id: 1,
      name: "Ada",
      phone_number: "412-432-7640",
    )
  }

  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")
    end

    it "is an instance of Passenger" do
      expect(@passenger).must_be_kind_of RideShare::Passenger
    end

    it "throws an argument error with a bad ID value" do
      expect do
        RideShare::Passenger.new(id: 0, name: "Smithy")
      end.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      expect(@passenger.trips).must_be_kind_of Array
      expect(@passenger.trips.length).must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        expect(@passenger).must_respond_to prop
      end

      expect(@passenger.id).must_be_kind_of Integer
      expect(@passenger.name).must_be_kind_of String
      expect(@passenger.phone_number).must_be_kind_of String
      expect(@passenger.trips).must_be_kind_of Array
    end
  end


  describe "trips property" do
    before do
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        rating: 5,
        driver_id: 1
        )

      @passenger.add_trip(trip)
    end

    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        expect(trip).must_be_kind_of RideShare::Trip
      end
    end

    it "all Trips must have the same passenger's passenger id" do
      @passenger.trips.each do |trip|
        expect(trip.passenger.id).must_equal 9
      end
    end
  end

  describe "net_expenditures" do
    # You add tests for the net_expenditures method
    it "returns the total amount a passenger has spent on their rides [from csv]" do
      trip_dispatch = RideShare::TripDispatcher.new

      expect(trip_dispatch.passengers[0].net_expenditures).must_equal 15
    end

    it "returns the total amount a passenger has spent on their rides [given new information]" do
      trip_1 = RideShare::Trip.new(id: 8,
        passenger: passenger,
        start_time: Time.new(2016, 8, 11),
        end_time: Time.new(2016, 8, 11) + 6*60*60,
        cost: 23,
        rating: 3,
        driver_id: 1
      )

      trip_2 = RideShare::Trip.new(id: 9,
        passenger: passenger,
        start_time: Time.new(2016, 8, 11),
        end_time: Time.new(2016, 8, 11) + 6*60*60,
        cost: 60,
        rating: 4,
        driver_id: 1
      )

      passenger.add_trip(trip_1)
      passenger.add_trip(trip_2)

      expect(passenger.net_expenditures).must_equal 83

    end

    it "returns 0 if a passenger has not yet taken a trip" do
      expect(passenger.net_expenditures).must_equal 0

    end
  end

  describe "total_time_spent" do
    # You add tests for the net_expenditures method
    it "returns the total time (in seconds) that a passenger rode [from csv]" do
      trip_dispatch = RideShare::TripDispatcher.new

      expect(trip_dispatch.passengers[0].total_time_spent).must_equal 5410
    end

    it "returns the total time (in seconds) that a passenger rode [given new information]" do
      trip_1 = RideShare::Trip.new(id: 8,
        passenger: passenger,
        start_time: Time.new(2016, 8, 11),
        end_time: Time.new(2016, 8, 11) + 2*60*60,
        cost: 123,
        rating: 3,
        driver_id: 1
      )

      trip_2 = RideShare::Trip.new(id: 9,
        passenger: passenger,
        start_time: Time.new(2016, 8, 11),
        end_time: Time.new(2016, 8, 11) + 60*60,
        cost: 60,
        rating: 4,
        driver_id: 1
      )

      passenger.add_trip(trip_1)
      passenger.add_trip(trip_2)

      expect(passenger.total_time_spent).must_equal 10800
    end

    it "returns 0 if a passenger has not yet taken a trip" do
      expect(passenger.total_time_spent).must_equal 0
    end
  end

  describe "add_trip_in_progress" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 1,
        name: "Ada",
        phone_number: "412-432-7640",
      )
      
      @finished_trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 11),
        end_time: Time.new(2016, 8, 11) + 2*60*60,
        cost: 123,
        rating: 3,
        driver_id: 1
      )

      @in_progress = RideShare::Trip.new(
        id: 9,
        passenger: @passenger,
        start_time: Time.now,
        driver_id: 1
      )

      @passenger.add_trip(@finished_trip)
    end

    it "adds the in progress trip" do
      expect(@passenger.trips).wont_include @in_progress
      previous = @passenger.trips.length

      @passenger.add_trip_in_progress(@in_progress)

      expect(@passenger.trips).must_include @in_progress
      expect(@passenger.trips.length).must_equal previous + 1
    end
  end
end
