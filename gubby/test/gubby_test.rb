require 'test_helper'
require 'socket'

class GubbyTest < Minitest::Test
  def setup
    @uri = "http://www.google.com/"
  end

  def test_must_respond_to_exported_go_methods
    [:queue_size, :push_url, :start, :stop].each do |meth|
      assert_respond_to Gubby, meth, "Gubby should respond to #{meth}"
    end
  end

  def test_must_push
    Gubby.start
    500.times{ Gubby.push_url(@uri) }
    wait_drain
  ensure
    Gubby.stop
  end

 def test_stop_must_stop
   Gubby.start
   50.times{ Gubby.push_url(@uri) }
   wait_drain
   Gubby.stop
   50.times{ Gubby.push_url(@uri) }
   assert_equal 50, Gubby.queue_size
   Gubby.start
   wait_drain
  ensure
    Gubby.stop
 end

  private

  def wait_drain
    until Gubby.queue_size == 0
      sleep(0.1)
    end
  end
end
