require "time"
require "minitest"
require "minitest/autorun"
require "minitest/reporters"
require "minitest/skip_dsl"
# Add simplecov

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# Require_relative your lib files here!
require_relative "../lib/csv_record"
require_relative "../lib/passenger"
require_relative "../lib/trip"
require_relative "../lib/trip_dispatcher"
require_relative "../lib/driver"
