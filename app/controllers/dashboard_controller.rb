class DashboardController < ApplicationController
  def index
    @tareas = Tarea.order(created_at: :asc)
    @nueva_tarea = Tarea.new
  end
end
