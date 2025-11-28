# Tech Barn - Final Project 336

A Java web application built with Apache Tomcat, Java Servlets, JSP, and MySQL. This is a technology marketplace platform that supports user authentication with buyer and seller functionality.

## 🚀 Project Overview

Tech Barn is a web application that provides a platform for users to buy and sell consumer electronics. The application features user authentication, session management, and database integration with MySQL.

## 📋 Technologies Used

- **Backend**: Java Servlets (Java 8)
- **Frontend**: JSP (JavaServer Pages), HTML, CSS, JavaScript
- **Database**: MySQL
- **Server**: Apache Tomcat 9.0
- **Build Tool**: Maven
- **JDBC Driver**: MySQL Connector/J 5.1.49

## 📁 Project Structure

```
final_proj_336/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── techbarn/
│       │           └── webapp/
│       │               ├── ApplicationDB.java      # Database connection handler
│       │               ├── HelloServlet.java       # Hello servlet example
│       │               ├── LoginServlet.java       # User authentication
│       │               ├── LogoutServlet.java      # Session termination
│       │               └── WelcomeServlet.java     # Welcome page handler
│       ├── resources/
│       │   └── application.properties              # Application configuration
│       └── webapp/
│           ├── index.html                          # Landing page
│           ├── login.jsp                           # Login page
│           ├── logout.jsp                          # Logout page
│           ├── welcome.jsp                         # Welcome page (after login)
│           ├── static/
│           │   ├── css/
│           │   │   └── styles.css                  # Stylesheet
│           │   └── js/
│           │       └── app.js                      # Client-side JavaScript
│           └── WEB-INF/
│               ├── web.xml                         # Web application configuration
│               └── lib/
│                   └── mysql-connector-java-5.1.49-bin.jar
├── sql/
│   ├── schema.sql                                  # Database schema
│   └── seed.sql                                    # Sample data
├── pom.xml                                         # Maven configuration
└── README.md                                       # This file
```

## 🛠️ Prerequisites

Before you begin, ensure you have the following installed:

- **Java Development Kit (JDK)** 8 or higher
- **Apache Tomcat** 9.0 or compatible version
- **MySQL** 5.7+ or MySQL 8.0+
- **Maven** 3.6+
- **Git** (optional, for version control)

## 📦 Installation & Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd final_proj_336
```

### 2. Database Setup

1. **Create the MySQL database:**
   ```sql
   CREATE DATABASE tech_barn;
   USE tech_barn;
   ```

2. **Run the schema file:**
   ```bash
   mysql -u root -p tech_barn < sql/schema.sql
   ```

3. **Seed the database (optional):**
   ```bash
   mysql -u root -p tech_barn < sql/seed.sql
   ```

4. **Update database credentials:**
   Edit `src/main/java/com/techbarn/webapp/ApplicationDB.java` and update the connection details:
   ```java
   String connectionUrl = "jdbc:mysql://localhost:3306/tech_barn"
       + "?useUnicode=true"
       + "&useSSL=false";
   connection = DriverManager.getConnection(connectionUrl, "root", "your_password");
   ```

### 3. Build the Project

From the project root directory, run:

```bash
mvn clean install
```

This will compile the Java classes and create a WAR file in the `target/` directory.

### 4. Deploy to Tomcat

#### Option A: Deploy WAR file

1. Copy the WAR file to Tomcat's `webapps` directory:
   ```bash
   cp target/final_proj_336-1.0-SNAPSHOT.war $CATALINA_HOME/webapps/
   ```

2. Start Tomcat:
   ```bash
   $CATALINA_HOME/bin/startup.sh  # Linux/Mac
   # or
   $CATALINA_HOME/bin/startup.bat  # Windows
   ```

#### Option B: Deploy from IDE (Eclipse/IntelliJ)

1. Configure Tomcat server in your IDE
2. Add the project to the server
3. Run the server from your IDE

## 🌐 Accessing the Application

Once Tomcat is running, access the application at:

- **Home Page**: http://localhost:8080/final_proj_336-1.0-SNAPSHOT/
- **Login Page**: http://localhost:8080/final_proj_336-1.0-SNAPSHOT/login

*Note: The context path may vary depending on your deployment configuration.*

## 🔐 Default Database Configuration

The application is configured to connect to:
- **Database**: `tech_barn`
- **Host**: `localhost:3306`
- **Username**: `root`
- **Password**: `password123`

**⚠️ Important**: Change the database credentials in `ApplicationDB.java` before deploying to production!

## 📝 Key Features

- **User Authentication**: Login/logout functionality with session management
- **Database Integration**: MySQL database for user management
- **Session Management**: HTTP session handling for user state
- **Servlet Architecture**: RESTful servlet endpoints
- **JSP Pages**: Dynamic web pages with server-side rendering

## 🔧 Configuration

### Database Connection

Edit `src/main/java/com/techbarn/webapp/ApplicationDB.java` to modify:
- Database name
- Connection URL
- Username and password

### Application Properties

The `src/main/resources/application.properties` file contains configuration settings (currently used as reference; actual database connection is handled in `ApplicationDB.java`).

### Web.xml

The `src/main/webapp/WEB-INF/web.xml` file configures:
- Welcome files
- Servlet mappings
- Application metadata

## 📊 Database Schema

The main `user` table includes:
- `user_id` (Primary Key)
- `username`
- `pwd` (password)
- `firstName`
- `lastName`
- `isBuyer` (boolean)
- `isSeller` (boolean)
- `dob` (date of birth)
- `address`
- `email`
- `phone_no`
- `payment_info`
- `bank_account`
- `rating`

## 🧪 Testing

1. **Test Database Connection:**
   ```bash
   java -cp "target/classes:src/main/webapp/WEB-INF/lib/mysql-connector-java-5.1.49-bin.jar" com.techbarn.webapp.ApplicationDB
   ```

2. **Test Login:**
   - Navigate to the login page
   - Use credentials from `sql/seed.sql` or create a new user

## 🐛 Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Verify MySQL is running
   - Check database credentials in `ApplicationDB.java`
   - Ensure the database `tech_barn` exists

2. **ClassNotFoundException for MySQL Driver**
   - Verify `mysql-connector-java-5.1.49-bin.jar` is in `WEB-INF/lib/`
   - Check that the JAR is included in the WAR file

3. **404 Error on Pages**
   - Verify the context path matches your deployment
   - Check `web.xml` configuration
   - Ensure JSP files are in the correct directory

4. **Session Issues**
   - Clear browser cookies
   - Check Tomcat session timeout settings

## 📚 Additional Resources

- [Apache Tomcat Documentation](https://tomcat.apache.org/tomcat-9.0-doc/)
- [Java Servlet Specification](https://javaee.github.io/servlet-spec/)
- [JSP Tutorial](https://www.oracle.com/java/technologies/jspt.html)
- [MySQL Documentation](https://dev.mysql.com/doc/)

## 📄 License

This project is licensed under the MIT License.

## 👥 Authors

Final Project 336 - Database Systems Course

---

**Note**: This is a development/educational project. For production use, consider implementing:
- Password hashing (bcrypt, Argon2)
- SQL injection prevention (already using PreparedStatements - good!)
- HTTPS/SSL encryption
- Input validation and sanitization
- Error logging and monitoring
- Security headers and CSRF protection
