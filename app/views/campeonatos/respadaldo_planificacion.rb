

    # <div class="tab-pane fade" id="jugadores" role="tabpanel" aria-labelledby="jugadores-tab">
    #   <h5>Listado de jugadores (informativo)</h5>
    # </div>

  #   <!-- Planificación -->
  #   <div class="tab-pane fade" id="planificacion" role="tabpanel" aria-labelledby="planificacion-tab">
  #     <div class="row">
  #       <div class="col-md-4 mb-3">
  #         <%= form.label :fecha_inicio, "Fecha inicio" %>
  #         <%= form.date_field :fecha_inicio, class: "form-control", name: "planificacion[fecha_inicio]" %>
  #       </div>

  #       <div class="col-md-4 mb-3">
  #         <%= form.label :canchas, "Número de canchas" %>
  #         <%= form.number_field :canchas, class: "form-control", name: "planificacion[canchas]", min: 1 %>
  #       </div>

  #       <div class="col-md-4 mb-3">
  #         <%= form.label :duracion_partido, "Duración de partido (minutos)" %>
  #         <%= form.number_field :duracion_partido, class: "form-control", name: "planificacion[duracion_partido]", min: 10 %>
  #       </div>
  #     </div>
  #     <div class="mb-3">
  #       <label>Bloquear Horarios (haz click para seleccionar/desseleccionar)</label>
  #       <div id="calendar"></div>
  #       <!-- Input oculto para enviar los horarios bloqueados -->
  #       <input type="hidden" name="planificacion[horarios_bloqueados_json]" id="horarios_bloqueados_json" />
  #     </div>


  #   </div>

  #   <!-- Partidos -->
  #   <div class="tab-pane fade" id="partidos" role="tabpanel" aria-labelledby="partidos-tab">
  #     <h5>Partidos programados</h5>
  #     <% if @partidos.present? %>
  #       <ul class="list-group">
  #         <% @partidos.each do |partido| %>
  #           <li class="list-group-item">
  #             Partido <%= partido.id %>: <%= partido.fecha.strftime("%d/%m/%Y %H:%M") %> - Cancha <%= partido.cancha %>
  #           </li>
  #         <% end %>
  #       </ul>
  #     <% else %>
  #       <p>No hay partidos programados.</p>
  #     <% end %>
  #   </div>
  # </div>