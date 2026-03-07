# Guion Demostración Video Hito 3

Este archivo contiene un borrador/guion sugerido para la grabación del vídeo final de 4 a 6 minutos, cumpliendo con los requisitos obligatorios de la rúbrica.

## 1. Introducción (30 seg)
* **Acción:** Mostrar la pantalla con el README.md o el entorno de n8n.
* **Guion:** "Hola, mi nombre es [Tu Nombre] y este es mi proyecto final para el Hito 3 de Desarrollo de Agentes IA para la Web. He implementado tanto el Sistema RAG como el Chatbot Multiherramienta."

## 2. Arquitectura (1 min)
* **Acción:** Mostrar el `docker-compose.yml` y explicar muy rápidamente los 4 servicios.
* **Guion:** "La arquitectura se basa en Docker Compose. Tenemos n8n como orquestador visual, Ollama ejecutando el modelo Mistral localmente, Qdrant como base de datos vectorial para los embeddings del RAG, y PostgreSQL para guardar el historial y los metadatos."

## 3. Demo en Vivo: Opción A - RAG (1.5 min)
* **Acción:** 
  1. Abrir VSCode y el archivo `tests/pruebas.http`.
  2. Ejecutar la petición "1. Ingesta de Documentos".
  3. Ejecutar la petición "2. Consultas RAG".
  4. Abrir DBeaver/pgAdmin o la terminal de PostgreSQL (`docker exec -it postgres psql -U n8n -d n8n`) y hacer un `SELECT * FROM documentos;` y `SELECT * FROM consultas_rag;`.
* **Guion:** "Primero, el sistema RAG. Enviamos un texto de prueba al webhook de ingesta. El texto se divide en chunks y se vectoriza en Qdrant. Luego, simulamos una pregunta sobre el texto. Ollama recupera el contexto de Qdrant y formula la respuesta. Finalmente, podemos ver en PostgreSQL cómo se han guardado tanto el documento procesado como el historial de la consulta respondida."

## 4. Demo en Vivo: Opción B - Chatbot (1-2 min)
* **Acción:** 
  1. Ejecutar las 5 peticiones del apartado "PROYECTO B: CHATBOT MULTIHERRAMIENTA" en `tests/pruebas.http` (Clima, País, Wikipedia, Chiste, General).
  2. Mostrar las respuestas de cada una.
  3. Hacer un `SELECT * FROM historial_chatbot;` en PostgreSQL.
* **Guion:** "Para el chatbot, Ollama analiza primero la intención de la pregunta. Aquí vemos cómo identifica que pregunto por el clima y llama a OpenMeteo. Luego pregunto por España y llama a la API de REST Countries. Lo mismo para Wikipedia y chistes. Ollama formatea todas las respuestas en lenguaje natural. Si pregunto algo general, el switch lo manda al LLM directamente. Todo queda registrado en la tabla `historial_chatbot` de PostgreSQL con su intención detectada."

## 5. Workflow en n8n (1 min)
* **Acción:** Abrir n8n (`http://localhost:5678`), mostrar los nodos del Chatbot.
* **Guion:** "Aquí podemos ver el workflow del chatbot. Entra por Webhook, Ollama detecta la intención, el nodo Switch enruta según la palabra clave (CLIMA, PAIS, etc.) a las distintas peticiones HTTP, y finalmente usamos de nuevo Ollama para generar una respuesta natural a partir del JSON devuelto por las APIs."

## 6. Conclusiones (30 seg)
* **Acción:** Mostrar la terminal con `docker ps` o la pantalla de commits de Git.
* **Guion:** "La principal dificultad fue configurar correctamente los nodos de LangChain en n8n y asegurar la comunicación entre contenedores. Como mejora futura, se podrían añadir más APIs al chatbot o implementar un sistema de memoria conversacional más complejo usando WindowBufferMemory."
