RubyLLM.configure do |config|
  # Groq expone una API compatible con OpenAI; redirigimos el endpoint.
  # Nunca hardcodear la clave — usá GROQ_API_KEY en tu entorno.
  config.openai_api_key  = ENV.fetch("GROQ_API_KEY", "placeholder")
  config.openai_api_base = "https://api.groq.com/openai/v1"
end
