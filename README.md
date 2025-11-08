# Tomcat Web Project

This project is a web application built using Apache Tomcat, Java, and MySQL. It serves as a template for developing web applications with a focus on modularity and ease of deployment.

## Project Structure

```
final_proj_336
├── src
│   └── main
│       ├── java
│       │   └── com
│       │       └── buyme
│       │           └── webapp
│       │               └── MainServlet.java
│       │               └── LoginServlet.java
│       ├── resources
│       │   └── application.properties
│       └── webapp
│           ├── WEB-INF
│           │   └── web.xml
│           ├── index.html
│           ├── trial.html
│           └── static
│               ├── js
│               │   └── app.js
│               └── css
│                   └── styles.css
├── sql
│   ├── schema.sql
│   └── seed.sql
├── scripts
│   ├── start-tomcat.sh
│   └── init_db.py
├── pom.xml
├── docker-compose.yml
├── Dockerfile
├── .vscode
│   ├── launch.json
│   └── settings.json
└── README.md
```

## Getting Started

### Prerequisites

- Java Development Kit (JDK)
- Apache Tomcat
- MySQL Database
- Maven
- Docker (optional)

### Setup Instructions

1. **Clone the Repository**
   Clone this repository to your local machine using:
   ```
   git clone <repository-url>
   ```

2. **Database Setup**
   - Create a MySQL database using the schema defined in `sql/schema.sql`.
   - Seed the database with initial data using `sql/seed.sql`.

3. **Configure Application Properties**
   Update the `src/main/resources/application.properties` file with your database connection settings.

4. **Build the Project**
   Navigate to the project root and run:
   ```
   mvn clean install
   ```

5. **Run the Application**
   - You can start the Tomcat server using the provided script:
     ```
     ./scripts/start-tomcat.sh
     ```
   - Alternatively, you can use Docker to run the application and MySQL database together using:
     ```
     docker-compose up
     ```

### Accessing the Application

Once the server is running, you can access the application by navigating to `http://localhost:8080` in your web browser.

### Additional Information

- The main servlet is located in `src/main/java/com/buyme/webapp/MainServlet.java`.
- Frontend files can be found in `src/main/webapp/static/`.
- For debugging, configuration files are located in the `.vscode` directory.

## License

This project is licensed under the MIT License. See the LICENSE file for details.