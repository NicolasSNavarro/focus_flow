class CreateTareas < ActiveRecord::Migration[8.0]
  def change
    create_table :tareas do |t|
      t.string :titulo, null: false
      t.boolean :completada, default: false, null: false

      t.timestamps
    end
  end
end
