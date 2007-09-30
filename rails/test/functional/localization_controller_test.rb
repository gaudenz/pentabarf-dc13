require File.dirname(__FILE__) + '/../test_helper'
require 'localization_controller'

# Re-raise errors caught by the controller.
class LocalizationController; def rescue_action(e) raise e end; end

class LocalizationControllerTest < Test::Unit::TestCase

  def setup
    @controller = LocalizationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @controller.send( :instance_eval ) { class << self; self; end }.send(:define_method, :auth ) do true end
    POPE.send( :instance_variable_set, :@user, Person.select_single( :person_id => 1 ) )
  end

  def test_ui_message
    get :ui_message
    assert_response :success
  end

end
