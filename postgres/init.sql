-- ==========================================
-- PROYECTO A: TABLAS PARA SISTEMA RAG
-- ==========================================

-- Tabla 1: Documentos procesados (Proyecto A)
-- Aquí guardo los PDFs o textos que subo por el webhook, para saber cuántos chunks se hicieron
CREATE TABLE IF NOT EXISTS documentos (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  ruta_archivo TEXT,
  num_chunks INTEGER,  -- Esto me sirve para ver en cuántos pedacitos se partió el texto
  fecha_procesado TIMESTAMP DEFAULT NOW()
);

-- Índice para búsquedas rápidas por el nombre del archivo
CREATE INDEX IF NOT EXISTS idx_documentos_nombre 
ON documentos(nombre);

-- Tabla 2: Historial de consultas RAG (Proyecto A)
-- En esta tabla registro cada vez que le pregunto algo al bot y me responde con contexto
CREATE TABLE IF NOT EXISTS consultas_rag (
  id SERIAL PRIMARY KEY,
  pregunta TEXT NOT NULL,
  respuesta TEXT NOT NULL,
  documentos_usados TEXT[], -- Array de los documentos que ha usado Ollama como contexto
  timestamp TIMESTAMP DEFAULT NOW()
);

-- Pongo este índice para poder ordenar rápido por fecha
CREATE INDEX IF NOT EXISTS idx_consultas_timestamp 
ON consultas_rag(timestamp DESC);

-- ==========================================
-- PROYECTO B: TABLA PARA CHATBOT
-- ==========================================

-- Tabla 3: Historial del Chatbot Multiherramienta (Proyecto B)
-- Esta es la que me pedían para guardar las conversaciones del chatbot y ver a qué API saltó
CREATE TABLE IF NOT EXISTS historial_chatbot (
  id SERIAL PRIMARY KEY,
  pregunta TEXT NOT NULL,
  intencion_detectada VARCHAR(100), -- Ej: CLIMA, WIKI, PAIS...
  herramienta_usada VARCHAR(100),   -- Api seleccionada (OpenMeteo, Wikipedia...)
  datos_herramienta JSONB,          -- Dejo esto como JSONB por si en el futuro guardo la info cruda de la API
  respuesta_generada TEXT NOT NULL, 
  timestamp TIMESTAMP DEFAULT NOW()
);

-- Índice para el historial del chatbot
CREATE INDEX IF NOT EXISTS idx_historial_chatbot_timestamp 
ON historial_chatbot(timestamp DESC);
