class AiController < ApplicationController
  def sugerencia
    tareas = Tarea.pendientes.pluck(:titulo)

    if tareas.empty?
      render turbo_stream: turbo_stream.replace("sugerencia_ia",
        partial: "ai/sugerencia",
        locals: { mensaje: "¡No tenés tareas pendientes! Agregá alguna primero." }
      )
      return
    end

    lista = tareas.map.with_index(1) { |t, i| "#{i}. #{t}" }.join("\n")
    prompt = <<~PROMPT
      Sos un asistente amable para personas con ADHD.
      El usuario tiene estas tareas pendientes:
      #{lista}

      En 2-3 oraciones cortas y alentadoras, sugerí por cuál tarea empezar y por qué.
      Sé específico, cálido y directo. Respondé en español.
    PROMPT

    chat = RubyLLM.chat(model: "llama-3.3-70b-versatile")
    respuesta = chat.ask(prompt)

    render turbo_stream: turbo_stream.replace("sugerencia_ia",
      partial: "ai/sugerencia",
      locals: { mensaje: respuesta.content }
    )
  rescue => e
    Rails.logger.error("Error AI: #{e.message}")
    render turbo_stream: turbo_stream.replace("sugerencia_ia",
      partial: "ai/sugerencia",
      locals: { mensaje: "No se pudo conectar con la IA. Verificá tu GROQ_API_KEY." }
    )
  end
end
