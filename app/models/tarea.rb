class Tarea < ApplicationRecord
  validates :titulo, presence: true, length: { maximum: 80 }
  validate :maximo_cinco_tareas, on: :create

  scope :pendientes, -> { where(completada: false).order(created_at: :asc) }
  scope :completadas, -> { where(completada: true).order(updated_at: :desc) }

  private

  def maximo_cinco_tareas
    if Tarea.count >= 5
      errors.add(:base, "Ya tenés 5 tareas. Completá alguna antes de agregar más.")
    end
  end
end
