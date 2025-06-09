require "test_helper"

class HorariosBloqueadosControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get horarios_bloqueados_create_url
    assert_response :success
  end
end
