require 'test_helper'

class DomainDataControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get domain_data_index_url
    assert_response :success
  end

end
