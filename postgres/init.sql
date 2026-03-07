-- Tabla 1: Documentos procesados (Proyecto A)
CREATE TABLE IF NOT EXISTS documentos (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  ruta_archivo TEXT,
  num_chunks INTEGER,
  fecha_procesado TIMESTAMP DEFAULT NOW()
);

-- Índice para búsquedas rápidas
CREATE INDEX IF NOT EXISTS idx_documentos_nombre 
ON documentos(nombre);

-- Tabla 2: Historial de consultas RAG (Proyecto A)
CREATE TABLE IF NOT EXISTS consultas_rag (
  id SERIAL PRIMARY KEY,
  pregunta TEXT NOT NULL,
  respuesta TEXT NOT NULL,
  documentos_usados TEXT[], -- Array de nombres de docs
  timestamp TIMESTAMP DEFAULT NOW()
);

-- Índice para consultas recientes
CREATE INDEX IF NOT EXISTS idx_consultas_timestamp 
ON consultas_rag(timestamp DESC);

-- Tabla 3: Historial del Chatbot Multiherramienta (Proyecto B)
CREATE TABLE IF NOT EXISTS historial_chatbot (
  id SERIAL PRIMARY KEY,
  pregunta TEXT NOT NULL,
  intencion_detectada VARCHAR(100),
  herramienta_usada VARCHAR(100),
  datos_herramienta JSONB,
  respuesta_generada TEXT NOT NULL,
  timestamp TIMESTAMP DEFAULT NOW()
);

-- Índice para consultas recientes del chatbot
CREATE INDEX IF NOT EXISTS idx_historial_chatbot_timestamp 
ON historial_chatbot(timestamp DESC);
