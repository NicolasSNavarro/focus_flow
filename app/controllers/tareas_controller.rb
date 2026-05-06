class TareasController < ApplicationController
  before_action :set_tarea, only: %i[edit update destroy toggle]

  def new
    @tarea = Tarea.new
    render layout: !turbo_frame_request?
  end

  def edit
    render layout: !turbo_frame_request?
  end

  def create
    @tarea = Tarea.new(tarea_params)
    if @tarea.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path, notice: "Tarea agregada." }
      end
    else
      render :new, layout: !turbo_frame_request?, status: :unprocessable_entity
    end
  end

  def update
    if @tarea.update(tarea_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path, notice: "Tarea actualizada." }
      end
    else
      render :edit, layout: !turbo_frame_request?, status: :unprocessable_entity
    end
  end

  def destroy
    @tarea.destroy!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path, notice: "Tarea eliminada.", status: :see_other }
    end
  end

  def toggle
    @tarea.update!(completada: !@tarea.completada)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path, status: :see_other }
    end
  end

  private

  def set_tarea
    @tarea = Tarea.find(params[:id])
  end

  def tarea_params
    params.require(:tarea).permit(:titulo, :completada)
  end
end
