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
      @driver = RideShare::Driver.new(
        id: 7,
        name: "Merl Glover Driver",
        vin: "16026202330372367",
        status: :AVAILABLE,
        trips: []
        )
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )
      trip = RideShare::Trip.new(
        id: 8,
        driver: @driver,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        rating: 5
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
      @driver = RideShare::Driver.new(
        id: 7,
        name: "Merl Glover Driver",
        vin: "16026202330372367",
        status: :AVAILABLE,
        trips: []
        )
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )
        
        @trip1 = RideShare::Trip.new(
        id: 8,
        driver: @driver,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        cost: 10,
        rating: 5
        )
        @passenger.add_trip(@trip1)
      
        @trip2 = RideShare::Trip.new(
        id: 9,
        driver: @driver,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 11),
        end_time: Time.new(2016, 8, 12),
        cost: 11,
        rating: 5
        )
        @passenger.add_trip(@trip2)
      
    end
    it "net_expenditures" do
      expect(@passenger.net_expenditures).must_be_kind_of Numeric
      expect(@passenger.net_expenditures).must_equal 21
    end
  end

  describe "total time spent" do ## this was all pasted from costs 
    before do
      # TODO: you'll need to add a driver at some point here.
      @driver = RideShare::Driver.new(
        id: 7,
        name: "Merl Glover Driver",
        vin: "16026202330372367",
        status: :AVAILABLE,
        trips: []
        )
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )
        
        @trip1 = RideShare::Trip.new(
        id: 8,
        driver: @driver,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8, 21, 00, 00),
        end_time: Time.new(2016, 8, 8, 21, 10, 00),
        cost: 10,
        rating: 5
        )
        @passenger.add_trip(@trip1)
      
        @trip2 = RideShare::Trip.new(
        id: 9,
        driver: @driver,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 11, 20, 00, 00),
        end_time: Time.new(2016, 8, 11, 20, 8, 00),
        cost: 11,
        rating: 5
        )
        @passenger.add_trip(@trip2)
      
    end
    it "calculates total time spent" do
      expect(@passenger.total_time_spent).must_be_kind_of Numeric
      expect(@passenger.total_time_spent).must_equal 1080
    end
  end
end
