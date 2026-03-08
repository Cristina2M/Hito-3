# Guion Demostración Video Hito 3

Este archivo contiene un borrador/guion sugerido para la grabación del vídeo final de 4 a 6 minutos, cumpliendo con los requisitos obligatorios de la rúbrica.

## 1. Introducción (30 seg)
Qué decir: "Hola, soy [Tu Nombre] y voy a presentar mi proyecto del Hito 3. He desarrollado un sistema RAG para consultar documentos y un Chatbot que usa APIs externas, todo orquestado con n8n y ejecutándose localmente con Docker y Ollama."

## 2. Arquitectura y Stack (45 seg)
Qué mostrar: El archivo docker-compose.yml en VS Code.

Qué decir: "El sistema corre sobre Docker. Uso n8n como cerebro, Ollama con el modelo Mistral para procesar texto, Qdrant para guardar los vectores de los documentos y PostgreSQL para el historial. Todo es 100% local."

## 3. Proyecto A: Sistema RAG (1.5 min) - ¡LA PARTE CLAVE!
Qué mostrar: El archivo pruebas.http.

Acción 1: Lanza la Ingesta. "Primero subo una guía sobre IA. El flujo la divide en trozos y la guarda en Qdrant."

Acción 2: Lanza la Consulta. "Ahora pregunto qué es RAG. Como veis, la IA me responde usando la información que acabo de subir, no de su memoria general."

Acción 3: Abre la base de datos (Postgres). "Aquí en PostgreSQL vemos que se ha guardado tanto el documento procesado como la pregunta que acabo de hacer."

## 4. Proyecto B: Chatbot Multiherramienta (1 min)
Qué mostrar: El flujo del Chatbot en n8n.

Acción: Lanza un par de pruebas desde pruebas.http (ej: el clima o Wikipedia).

Qué decir: "El Chatbot es capaz de decidir qué herramienta usar. Si pregunto por el tiempo, llama a OpenMeteo. Si pregunto por un país, usa REST Countries. La IA recibe los datos técnicos de la API y los convierte en una frase amable para el usuario."

## 5. Explicación del Workflow (1 min) - DIFERENCIADOR
Qué mostrar: El nodo Question and Answer Chain que configuramos.

Qué decir: "En n8n, he sustituido el Agente básico por una Question and Answer Chain. Esto hace que el sistema sea más fiable, obligando a Mistral a leer siempre el contexto de Qdrant antes de hablar. También he configurado nodos de PostgreSQL con parámetros limpios para asegurar que no haya errores de formato al guardar el historial."

## 6. Conclusión (30 seg)
Qué mostrar: El panel de ejecuciones de n8n (todo en verde).

Qué decir: "El mayor reto fue la gestión de errores en las inserciones de base de datos, pero se solucionó ajustando las expresiones en n8n. El sistema es totalmente funcional y escalable. Gracias por su atención."

---

