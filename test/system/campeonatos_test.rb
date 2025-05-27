require "application_system_test_case"

class CampeonatosTest < ApplicationSystemTestCase
  setup do
    @campeonato = campeonatos(:one)
  end

  test "visiting the index" do
    visit campeonatos_url
    assert_selector "h1", text: "Campeonatos"
  end

  test "should create campeonato" do
    visit campeonatos_url
    click_on "New campeonato"

    fill_in "Categoria", with: @campeonato.categoria_id
    fill_in "Club", with: @campeonato.club_id
    fill_in "Cupos maximos", with: @campeonato.cupos_maximos
    fill_in "Descripcion", with: @campeonato.descripcion
    fill_in "Estado", with: @campeonato.estado
    fill_in "Fecha inicio", with: @campeonato.fecha_inicio
    fill_in "Fecha termino", with: @campeonato.fecha_termino
    fill_in "Foto", with: @campeonato.foto
    fill_in "Nombre", with: @campeonato.nombre
    fill_in "Normativo", with: @campeonato.normativo
    fill_in "Reglas", with: @campeonato.reglas
    fill_in "Tipo", with: @campeonato.tipo
    fill_in "Tipoinscripcion", with: @campeonato.tipoinscripcion_id
    click_on "Create Campeonato"

    assert_text "Campeonato was successfully created"
    click_on "Back"
  end

  test "should update Campeonato" do
    visit campeonato_url(@campeonato)
    click_on "Edit this campeonato", match: :first

    fill_in "Categoria", with: @campeonato.categoria_id
    fill_in "Club", with: @campeonato.club_id
    fill_in "Cupos maximos", with: @campeonato.cupos_maximos
    fill_in "Descripcion", with: @campeonato.descripcion
    fill_in "Estado", with: @campeonato.estado
    fill_in "Fecha inicio", with: @campeonato.fecha_inicio
    fill_in "Fecha termino", with: @campeonato.fecha_termino
    fill_in "Foto", with: @campeonato.foto
    fill_in "Nombre", with: @campeonato.nombre
    fill_in "Normativo", with: @campeonato.normativo
    fill_in "Reglas", with: @campeonato.reglas
    fill_in "Tipo", with: @campeonato.tipo
    fill_in "Tipoinscripcion", with: @campeonato.tipoinscripcion_id
    click_on "Update Campeonato"

    assert_text "Campeonato was successfully updated"
    click_on "Back"
  end

  test "should destroy Campeonato" do
    visit campeonato_url(@campeonato)
    click_on "Destroy this campeonato", match: :first

    assert_text "Campeonato was successfully destroyed"
  end
end
