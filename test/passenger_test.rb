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
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [] # CHANGE LATER
        )
      @driver = RideShare::Driver.new(
        id: 5,
        name: "test",
        vin: "34085893483273456"
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
    it "sums up one trip's cost"
    before do 
      @trip = RideShare::Trip.new(id: 8, passenger_id: 1, start_time: start_time, end_time: end_time, cost: 23.45, rating: 3)

      @trip = RideShare::Trip.new(id: 8, passenger_id: 1, start_time: start_time, end_time: end_time, cost: 7.65, rating: 6)

      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334", trips: [trip], cost: 23.45)
    end 

    it "provides the total money spent by a given passenger for all their trips" do
       expect(@passenger.net_expenditures()).must_equal 31.00
    end 

    it "sums multiple trips cost with incomplete" do
    @costs = [44.55, nil]
    @passenger = RideShare::Passenger.new(
      id: 9,
      name: "Merl Glover III",
      phone_number: "1-602-620-2330 x3723",
      trips: []
      )
    @trips = [
      RideShare::Trip.new(
        id: 8,
        driver_id: 99,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),                             
        rating: 5,
        cost: @costs[0]
        ),
      RideShare::Trip.new(
        id: 9,
        driver_id: 99,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        rating: 5,
        cost: @costs[1]
        )
      ]
      @trips.each do |t|
        @passenger.add_trip(t)
      end

      expect(@passenger.net_expenditures).must_equal @costs[0]
    end
  end

  describe "duration" do
    it "sums one trip duration" do
      @cost = 44.55
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      trip = RideShare::Trip.new(
        id: 8,
        driver_id: 99,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        rating: 5,
        cost: @cost
      )
      @passenger.add_trip(trip)
      expect(@passenger.total_time_spent).must_equal 86400
    end

    it "sums multiple trips duration" do
      @costs = [44.55, 25.21]
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      @trips = [
        RideShare::Trip.new(
          id: 8,
          driver_id: 99,
          passenger: @passenger,
          start_time: Time.new(2016, 8, 8),
          end_time: Time.new(2016, 8, 9),
          rating: 5,
          cost: @costs[0]
        ),
        RideShare::Trip.new(
          id: 9,
          driver_id: 99,
          passenger: @passenger,
          start_time: Time.new(2016, 8, 8),
          end_time: Time.new(2016, 8, 9),
          rating: 5,
          cost: @costs[1]
        )
      ]
      @trips.each do |t|
        @passenger.add_trip(t)
      end
    end
  end
  
  describe "total_time_spent" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )
      @trip1 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        cost: 10,
        rating: 5,
      )
      @passenger.add_trip(@trip1)
    end
  end

      it "sums duration with incomplete trips" do
      @costs = [44.55, 25.21]
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      @trips = [
        RideShare::Trip.new(
          id: 8,
          driver_id: 99,
          passenger: @passenger,
          start_time: Time.new(2016, 8, 8),
          end_time: Time.new(2016, 8, 9),
          rating: 5,
          cost: @costs[0]
        ),
        RideShare::Trip.new(
          id: 9,
          driver_id: 99,
          passenger: @passenger,
          start_time: Time.new(2016, 8, 8),
          end_time: nil,
          rating: 5,
          cost: @costs[1]
        )
      ]
      @trips.each do |t|
        @passenger.add_trip(t)
      end

      expect(@passenger.total_time_spent).must_equal 86400
    end

end