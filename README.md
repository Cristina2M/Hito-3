# HITO 3 - Automatización Inteligente con n8n + Ollama + PostgreSQL + Qdrant

[![N8N](https://img.shields.io/badge/n8n-FF6C37?style=for-the-badge&logo=n8n&logoColor=white)](https://n8n.io/)
[![PostgreSQL](https://img.shields.io/badge/postgresql-4169e1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Ollama](https://img.shields.io/badge/ollama-000000?style=for-the-badge&logo=ollama&logoColor=white)](https://ollama.ai/)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)

Proyecto final de Automatización Inteligente para 2º DAW, implementando herramientas orquestadas en flujos visuales para un Sistema RAG y un Chatbot Inteligente Multiherramienta.

## 👥 Autores
- [Tu Nombre / Usuario Github]

## 🎥 Vídeo Demostración
[🎬 Enlace al vídeo en YouTube / Drive aquí]

---

## 🚀 Requisitos y Tecnologías
Este proyecto requiere tener instalado:
- **Docker y Docker Compose V2**
- **Git**

El stack tecnológico levantado por Docker Compose incluye:
- **n8n:** Orquestador visual de workflows
- **Ollama:** Modelos de lenguaje locales (LLM y Embeddings, modelo Mistral)
- **Qdrant:** Base de datos vectorial para búsqueda semántica
- **PostgreSQL:** Base de datos relacional para guardar metadatos e historial

## 🛠 Instalación y Despliegue

1. **Clonar el repositorio**
   ```bash
   git clone [URL_DEL_REPOSITORIO]
   cd Hito-3
   ```

2. **Configurar el entorno**
   Copia el archivo de ejemplo para crear tus variables de entorno locales reales (que están ignoradas en git):
   ```bash
   cp docker/.env.example docker/.env
   ```
   *Opcional: Edita las credenciales dentro de `docker/.env`.*

3. **Levantar los servicios con Docker Compose**
   ```bash
   cd docker
   docker compose up -d
   ```
   Esto levantará `n8n` en el puerto 5678, `PostgreSQL` en el 5432, `Ollama` en el 11434 y `Qdrant` en el 6333.

4. **Descargar el modelo en Ollama**
   Mientras los contenedores arrancan, es fundamental descargar el modelo de lenguaje configurado (`mistral`):
   ```bash
   docker exec -it ollama ollama pull mistral
   ```

5. **Importar workflows en n8n**
   - Entra a [http://localhost:5678/](http://localhost:5678/)
   - Configura tus credenciales a la base de datos PostgreSQL (host: `postgres`, user/pass correspondientes al `.env`)
   - Configura las credenciales a Qdrant (host: `http://qdrant:6333`)
   - Importa los archivos JSON de la carpeta `n8n/workflows/`
   - Configura los workflows para utilizar las credenciales recién creadas.

---

## 📚 Proyecto A: Sistema RAG Educativo

El sistema procesa texto plano configurado desde Webhook, lo divide en fragmentos (chunks) de 500 palabras con 50 palabras de solapamiento (overlap), genera embeddings localmente con LLM Mistral en Ollama y los persiste de manera vectorial en la base de datos (Qdrant), al mismo tiempo que guarda una traza en una base PostgreSQL (Tabla: `documentos`).
Cuando se envía la pregunta de recuperación, la procesa transformándola en embedding y busca el vector y el texto del contexto más cercano para entregárselo a Mistral y obtener una respuesta limpia y contextualizada. Guardando el histórico de las preguntas en la base PostgreSQL (Tabla: `consultas_rag`).

### Ejemplos Gráficos
(Por favor, inserta capturas de pantalla de la importación y configuración aquí)
- `![Flujo Ingesta RAG](docs/capturas/rag-ingesta.png)`
- `![Flujo Consultas RAG](docs/capturas/rag-consultas.png)`

---

## 💬 Proyecto B: Chatbot Multiherramienta

Un orquestador RAG en vivo. Un nodo `webhook` recibe una pregunta aleatoria. Otro nodo con Ollama hace uso del LLM para extraer **únicamente la categoría (intención)** (Clima, País, Wiki, Chiste, General). 
La intención calculada se enruta con el nodo **Switch**, el cuál decide qué API pública y gratuita atacar (OpenMeteo, RESTCountries, Wikipedia, JokeAPI o un Ollama directo fallback). Las APIs retornan un formato en JSON puro que pasa por el último LLM, configurado para actuar de formateador, que lee todo el JSON final y lo presenta al usuario de una forma natural, amigable y legible para humanos. 
Al final, independientemente del origen, se registra la herramienta contactada, el contexto detectado y la respuesta procesada en log sobre PostgreSQL (Tabla `historial_chatbot`).

### Ejemplos Gráficos
(Por favor, inserta capturas de pantalla de la importación y configuración aquí)
- `![Flujo Chatbot](docs/capturas/chatbot.png)`

---

## ✅ Funcionalidades Completadas
Estas son las funciones desarrolladas con éxito según la rúbrica:

- [x] Configuración funcional de n8n, Ollama, Qdrant y PostgreSQL mediante Docker Compose.
- [x] Implementación completa del workflow de ingesta de documentos RAG.
- [x] Implementación completa del workflow de consultas RAG utilizando embeddings y LLM local.
- [x] Base de datos estructurada con PostgreSQL utilizando script INIT (`init.sql`).
- [x] Implementación de chatbot con identificador de intención.
- [x] Switch de enrutamiento a 4 APIs diferentes gratuitas (sin auth key requerida) y un fallback para generales usando de interprete final local Ollama.
- [x] Almacenamiento conversacional en base de datos.
- [x] Extensión en VSCode (HTTP/REST) preparada para demostración (fichero `tests/pruebas.http`).

---

## 🛠 Pruebas
Si utilizas **Visual Studio Code**, es recomendable usar la extensión [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client). Abriendo el fichero `tests/pruebas.http`, encontrarás todos los enrutadores listos para su uso haciendo un simple click en `Send Request` sobre cada bloque, para probar cada intención y caso del sistema sin necesidad de una aplicación tercera (como Postman).
