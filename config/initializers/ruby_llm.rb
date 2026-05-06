RubyLLM.configure do |config|
  config.openai_api_key  = ENV.fetch("GROQ_API_KEY", "placeholder")
  config.openai_api_base = "https://api.groq.com/openai/v1"
end

# Registra el modelo de Groq en el registry de ruby_llm (usa la API compatible con OpenAI)
RubyLLM.models.all << RubyLLM::Model::Info.default("llama-3.3-70b-versatile", "openai")
