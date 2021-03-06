require File.dirname(__FILE__) + '/../test_helper'
require 'schedule_controller'

# Re-raise errors caught by the controller.
class ScheduleController; def rescue_action(e) raise e end; end

class ScheduleControllerTest < Test::Unit::TestCase
  def setup
    @controller = ScheduleController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    authenticate_user( Account.select_single(:login_name=>'committee') )
  end

  def test_index
    get :index, {:conference=>'Octi'}
    assert_response :success
  end

end
