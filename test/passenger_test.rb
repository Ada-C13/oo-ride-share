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
        id: 3,
        name: "Test Driver",
        vin: "12345678912345678"
      )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        driver: @driver,
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

  # TODO 1.2 #1 Refactor our Arrange?
  # TODO TODO TODO TODO More test cases?
  describe "net_expenditures" do
    # Arrange
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )
      @driver = RideShare::Driver.new(
        id: 3,
        name: "Test Driver",
        vin: "12345678912345678"
      )
    end

    it "returns the correct total amount of money that a passenger has spent" do
      2.times do
        trip = RideShare::Trip.new(
          id: 8,
          passenger: @passenger,
          driver: @driver,
          start_time: "#{Time.now - 60 * 60}",
          end_time: "#{Time.now + 60 * 60}",
          rating: 5,
          cost: 10
          )
        @passenger.add_trip(trip)
      end
      
      expect ((@passenger).net_expenditures).must_equal 20
    end

    it "returns a cost of 0 if a passenger has no trips" do
      expect ((@passenger).net_expenditures).must_equal 0
    end

  end

  # # 1.2 #2 total_time_spent
  # TODO TODO Refactor make it DRY!
  # TODO What if there is no trips?
  describe "total_time_spent" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )
      @driver = RideShare::Driver.new(
        id: 3,
        name: "Test Driver",
        vin: "12345678912345678"
      )
    end

    it "returns the total time that passenger has spent on their trips" do
      2.times do
        trip = RideShare::Trip.new(
          id: 8,
          passenger: @passenger,
          driver: @driver,
          start_time: "#{Time.now - 60 * 60}",
          end_time: "#{Time.now + 60 * 60}",
          rating: 5,
          cost: 10
          )
        @passenger.add_trip(trip)
      end

      expect ((@passenger).total_time_spent).must_equal 14400
    end

    it "returns a time of 0 if a passenger has no trips" do
      expect ((@passenger).total_time_spent).must_equal 0
    end
  end

end
