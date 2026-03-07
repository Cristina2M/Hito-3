# HITO 3 - Automatización Inteligente con n8n + Ollama + PostgreSQL + Qdrant

[![N8N](https://img.shields.io/badge/n8n-FF6C37?style=for-the-badge&logo=n8n&logoColor=white)](https://n8n.io/)
[![PostgreSQL](https://img.shields.io/badge/postgresql-4169e1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Ollama](https://img.shields.io/badge/ollama-000000?style=for-the-badge&logo=ollama&logoColor=white)](https://ollama.ai/)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)

Proyecto final de Automatización Inteligente del curso de 2º DAW. En este repositorio muestro cómo he construido dos programas usando Inteligencia Artificial: un asistente que puede leer y contestar preguntas sobre documentos o apuntes (lo que en programación se llama un Sistema RAG), y un chatbot o asistente virtual que es capaz de elegir por sí mismo qué herramientas y páginas de internet necesita consultar para poder responder a las preguntas que le hagamos. Todo esto se hace de una forma muy visual usando una herramienta de automatización llamada n8n.

## 👥 Autores
- [Cristina Moreno Martínez / Cristina2M]

## 🎥 Vídeo Demostración
[🎬 Enlace al vídeo en YouTube aquí]

---

## 🚀 Lo que necesitas para probar el proyecto

Para que todo esto funcione en tu ordenador, vas a necesitar tener instalados un par de programas básicos:
- **Docker y Docker Compose:** Estos programas nos ayudan a empaquetar y ejecutar todos los servicios juntos en su propia "burbuja", de forma que no tengas que instalar las bases de datos ni el resto de cosas una a una en tu ordenador.
- **Git:** Para poder descargarte este código fuente.

El proyecto está compuesto por 4 grandes bloques (los contendores de Docker):
- **n8n:** Es el programa principal. Es como un panel de control donde podemos dibujar con nodos qué queremos que pase en cada momento.
- **Ollama:** Es el cerebro del proyecto. Nos permite descargarnos un modelo de Inteligencia Artificial (en este caso Mistral) para que se ejecute en nuestro propio ordenador, en lugar de depender de internet como hace ChatGPT.
- **Qdrant:** Es una base de datos especial (vectorial). En vez de guardar textos o números normales, guarda "conceptos" o ideas que Ollama puede entender rápidamente.
- **PostgreSQL:** Es una base de datos donde guardaremos un registro o "historial" escrito de todas las conversaciones y documentos que han ido pasando por nuestro asistente, para que nada se pierda.

---

## 🛠 Cómo ponerlo a funcionar paso a paso

1. **Descargar el código:**
   Abre una terminal en tu ordenador y descarga el proyecto usando este comando:
   ```bash
   git clone [URL_DEL_REPOSITORIO]
   cd Hito-3
   ```

2. **Copiar las claves de configuración:**
   Por motivos de seguridad, los archivos que tienen contraseñas reales no se suben a internet. He dejado un archivo "de ejemplo" falso. Tienes que copiar ese archivo falso y renombrarlo como el de verdad para que tu ordenador sepa con qué usuarios y contraseñas tiene que trabajar internamente:
   ```bash
   cp docker/.env.example docker/.env
   ```
   *(Si quieres curiosear, puedes abrir ese nuevo archivo `docker/.env` y cambiar las contraseñas, pero las que vienen por defecto funcionan perfectamente).*

3. **Encender la maquinaria (Docker Compose):**
   Ahora vamos a decirle a Docker que encienda los 4 bloques principales que hemos mencionado antes. Escribe esto:
   ```bash
   cd docker
   docker compose up -d
   ```
   Sabrás que ha funcionado porque, si abres tu navegador web en `http://localhost:5678`, verás cómo arranca nuestro panel principal de n8n.

4. **Instruir al cerebro de Inteligencia Artificial:**
   Los contenedores de Docker ya están encendidos, pero nuestro Ollama todavía está "vacío" y necesita aprender un idioma. Mientras los programas terminan de arrancar, copia y pega este comando para que se descargue el modelo llamado "Mistral":
   ```bash
   docker exec -it ollama ollama pull mistral
   ```
   Va a tardar un poco porque es un modelo pesado que descarga todo el conocimiento en tu máquina local.

5. **Cargar nuestros esquemas visuales en n8n:**
   - Entra a [http://localhost:5678/](http://localhost:5678/) desde tu navegador.
   - En nuestro repositorio hay una carpeta llamada `n8n/workflows/`. Ahí dentro hay 3 archivos ".json".
   - Lo único que tienes que hacer es importarlos (arrastrarlos) dentro de la interfaz gráfica de n8n.
   - Cuando los cargues, n8n te pedirá que las asocies a las bases de datos de Qdrant y PostgreSQL para que puedan comunicarse. 

---

## 📚 Proyecto A: El Sistema RAG (El Estudiante Asistente)

¿Qué pasaría si tuvieras unos apuntes larguísimos y quisieras hacerles una pregunta directa en vez de leerlos enteros? Para eso sirve este proyecto.
Funciona en dos partes o caminos separados:
1. **La subida del documento:** Cuando le mandamos un texto (o apuntes), el flujo que he programado se encarga de coger ese archivo enorme y trocearlo en pedacitos más pequeños de unas 500 palabras cada uno. Esos pedacitos se los pasamos a Ollama (nuestra IA), que los transforma en un código especial (vectores) y los guarda en nuestra base de datos Qdrant para toda la vida. A la vez, anota en nuestra tabla de PostgreSQL "oye, he guardado este documento en 3 pedazos".
2. **Las preguntas y respuestas:** Cuando nosotros le hacemos la pregunta ("¿Qué es la IA?"), el segundo flujo convierte nuestra pregunta al mismo lenguaje especial y busca en Qdrant los pedacitos de texto de nuestros apuntes que más se parezcan a lo que hemos preguntado. Cuando encuentra el párrafo correcto, se lo da a nuestra IA Mistral y le dice: "Léete este párrafo y contéstame a la pregunta en español y con buena educación". Finalmente, el historial entero se queda guardado para el futuro en la base de datos PostgreSQL.

### Capturas del resultado
(Aquí van las fotos de cómo se ve el esquema final en pantalla)
- `![Flujo Ingesta RAG](docs/capturas/rag-ingesta.png)`
- `![Flujo Consultas RAG](docs/capturas/rag-consultas.png)`

---

## 💬 Proyecto B: El Chatbot Multiherramienta Sabelotodo

Este segundo asistente es diferente. Es capaz de mantener una conversación, pero además tiene el poder de saber qué herramienta externa tiene que buscar de internet para responder cosas precisas.

Todo entra por un único buzón. Cuando escribimos nuestra pregunta, el flujo en n8n se lo pasa a Ollama diciéndole: "Oye, léete esto sólo un momento y dime si me están preguntando por el tiempo, por un país, por algo de la Wikipedia o si me están pidiendo un chiste". 
Cuando Ollama nos devuelve la "intención" detectada de entre esas opciones, he programado una puerta desviadora que funciona como las vías del tren (un nodo *Switch*):
- Si preguntó por el tiempo, se va a conectar gratis a la API de OpenMeteo para ver cuánto sol hace.
- Si preguntó por ciudades, llamará a la API de RESTCountries.
- Si quiere saber cosas generales o un resumen, se va a Wikipedia.
- Y si el usuario quería reírse, visita JokeAPI.
- Pero... si la IA no detectó ninguna de esas cuatro cosas concretas, entonces se responde a sí misma con charla general.

Tras coger esos puros datos brutos de las páginas web externas, que los humanos no podríamos leer bien, pasamos a la última fase. Le damos todo el batiburrillo informático a la IA nuevamente y le ordenamos: "Redacta estos datos brutos como si fueras una persona maja respondiendo dudas". 
Y como siempre, termina con un registro muy detallado escrito en nuestra base de datos para no olvidar nunca lo que le preguntamos y de qué API sacó la respuesta.

### Capturas del resultado
(Aquí van las fotos de cómo se ve el esquema final en pantalla)
- `![Flujo Chatbot](docs/capturas/chatbot.png)`

---

## 🛠 ¿Y cómo hacemos las pruebas demostrativas?

Para que hacer la demostración sea súper fácil, rápido y que no se rompa nada en el vídeo final, he dejado preparado un fichero que se llama `tests/pruebas.http`.

Si abres este archivo usando el editor **Visual Studio Code**, y le instalas una extensión recomendada que se llama [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client), te aparecerán unos botones directos de un solo clic que dicen `Send Request` justo encima de cada caso de prueba. Pulsándolos uno a uno dispararemos los procesos que hay detrás de las cortinas y comprobaremos, paso a paso, cómo ambos proyectos analizan, dividen o enrutan nuestra información devolviéndonos algo bonito y terminado.

---

## ✅ Lista de tareas logradas
Aquí está la lista obligatoria con todo lo que se ha conseguido integrar correctamente en el proyecto:

- [x] Configuración funcional de n8n, la Inteligencia Artificial de Ollama, y las bases de Postgres y Qdrant escondidos dentro de un único contenedor Docker.
- [x] Un flujo o mapa visual completo que procese la información y apuntes de forma RAG.
- [x] Un flujo o mapa visual completo para recibir respuestas inteligentes desde lo que había en Qdrant.
- [x] Un mapa visual para el Chatbot con capacidad para saber cuáles eran mis intenciones.
- [x] Tablas de historial con el registro de qué paso por ahí funcionando en Postgres (`init.sql`).
- [x] Separación de respuestas en tiempo real mediante Switch hacia las 4 APIs externas obligatorias y su propio método por si algo falla.
- [x] Entorno simulado con casos reales listo para darle al clic sin Postman (`pruebas.http`).
