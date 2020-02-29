require_relative 'test_helper'

describe "Passenger class" do

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
      @driver = RideShare::Driver.new(
        id:99, 
        name: "Sam", 
        vin:"WBS76FYD47DJF7206"
        )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        rating: 5,
        driver: @driver
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
    before do
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )
      @driver = RideShare::Driver.new(
        id:99, 
        name: "Sam", 
        vin:"WBS76FYD47DJF7206"
        )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        cost: 20,
        rating: 5,
        driver: @driver
        )

      @passenger.add_trip(trip)

      trip2 = RideShare::Trip.new(
        id: 9,
        passenger: @passenger,
        start_time: Time.new(2016, 7, 8),
        end_time: Time.new(2016, 7, 9),
        cost: 15,
        rating: 4,
        driver: @driver
        )

      @passenger.add_trip(trip2)

      trip3 = RideShare::Trip.new(
        id: 10,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        cost: 10,
        rating: 4,
        driver: @driver
        )

      @passenger.add_trip(trip3)
    end
    
    it "calculates the total money spent on trips" do
      expect(@passenger.net_expenditures).must_equal 45
    end

    it "Returns 0 if passenger has no trips" do
      passenger2 = RideShare::Passenger.new(
        id: 10,
        name: "Ada Lovelace",
        phone_number: "1-425-999-0899",
        trips: []
        )

      expect(passenger2.net_expenditures).must_equal 0
    end

    it "Ignores the trips that are still in progress" do
      trip4 = RideShare::Trip.new(
        id: 11,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: nil,
        cost: nil,
        rating: nil,
        driver: @driver
        )

      @passenger.add_trip(trip4)
      
      expect(@passenger.net_expenditures).must_equal 45
    end
  end

  describe "total_time_spent" do
    before do
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )
      @driver = RideShare::Driver.new(
        id:99, 
        name: "Sam", 
        vin:"WBS76FYD47DJF7206"
        )

      start_time = Time.now - 60 * 60 # 60 minutes
      end_time = start_time + 25 * 60 # 25 minutes

      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: start_time,
        end_time: end_time,
        cost: 20,
        rating: 5,
        driver: @driver
        )

      @passenger.add_trip(trip)

      start_time = Time.now - 120 * 60 # 60 minutes
      end_time = start_time + 25 * 60 # 25 minutes

      trip2 = RideShare::Trip.new(
        id: 9,
        passenger: @passenger,
        start_time: start_time,
        end_time: end_time,
        cost: 20,
        rating: 5,
        driver: @driver
        )

      @passenger.add_trip(trip2)

      start_time = Time.now - 200 * 60 # 60 minutes
      end_time = start_time + 25 * 60 # 25 minutes

      trip3 = RideShare::Trip.new(
        id: 10,
        passenger: @passenger,
        start_time: start_time,
        end_time: end_time,
        cost: 20,
        rating: 5,
        driver: @driver
        )

      @passenger.add_trip(trip3)
    end

    it "Calculates total time spent on trips" do
      expect(@passenger.total_time_spent).must_equal 4500
    end

    it "Returns 0 if passenger has no trips" do
      passenger2 = RideShare::Passenger.new(
        id: 10,
        name: "Ada Lovelace",
        phone_number: "1-425-999-0899",
        trips: []
        )

      expect(passenger2.total_time_spent).must_equal 0
    end

    it "Ignores the trips that are still in progress" do
      trip4 = RideShare::Trip.new(
        id: 11,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: nil,
        cost: nil,
        rating: nil,
        driver: @driver
        )

      @passenger.add_trip(trip4)
      
      expect(@passenger.total_time_spent).must_equal 4500
    end

  end
end
