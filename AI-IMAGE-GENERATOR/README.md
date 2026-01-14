
# Dali - Character Management and AI Image Generation

This project is a web application built with the Django framework, designed to allow users to create and manage fictional characters. Users can create, edit, view, and delete characters while also generating images based on their character descriptions. The application integrates OpenAI's image generation API (specifically the DALL·E 3 model) to create AI-generated images based on the user's selected attributes.

In addition to the core application features, the project also leverages Docker Compose for containerization, PostgreSQL as the database solution, a CLI powered by Typer for ease of management, and logging and testing utilities to ensure smooth operation and maintainability.

## Key Features
- User Authentication: Secure signup, login, and logout
- Character Management: Create, edit, view, and delete characters
- AI Image Generation: Automatic portrait generation from character descriptions
- Containerized Architecture: Docker Compose for easy deployment
- Reliable Database: PostgreSQL for data storage
- Comprehensive Testing: Pytest for unit and integration tests
- CLI Integration: Typer-powered command line interface
- Detailed Logging: Event tracking and error handling

## Technology Stack
- Backend: Django
- Database: PostgreSQL
- AI Integration: OpenAI DALL·E 3 API
- Containerization: Docker + Docker Compose
- CLI: Typer
- Testing: Pytest
- Dependency Management: Poetry

## Project Structure
```bash
├── characters/                                 # Django app for character management
│   ├── migrations/                             # Database migrations
│   ├── templates/                              # HTML templates for rendering views
│   │   ├── characters/                         # Templates related to character management
│   │   │   ├── character_confirm_delete.html   # Confirmation page for deleting a character
│   │   │   ├── character_list.html             # Page listing all characters
│   │   │   ├── character_update.html           # Form for updating a character
│   │   │   ├── create_character.html           # Form for creating a character
│   │   │   ├── index.html                      # Homepage for characters
│   │   ├── registration/                       # Authentication-related templates
│   │   │   ├── login.html                      # User login page
│   │   │   ├── signup.html                     # User signup page
│   │   ├── base.html                           # Base template for consistent styling across pages
│   ├── tests/                                  # Unit tests for the application
│   ├── admin.py                                # Django Admin configuration
│   ├── apps.py                                 # Application configuration
│   ├── character.json                          # Sample data for testing/populating database
│   ├── forms.py                                # Form handling logic
│   ├── image_service.py                        # OpenAI image generation service
│   ├── models.py                               # Database models defining characters
│   ├── tests.py                                # Unit tests for character-related features
│   ├── urls.py                                 # URL routing for character-related views
│   ├── views.py                                # Application views handling requests
│ 
├── dali/                                       # Django project settings and configurations
│   ├── settings.py                             # Django settings (database, middleware, authentication, etc.)
│   ├── urls.py                                 # Project-wide URL configuration
│   ├── wsgi.py                                 # WSGI application entry point (for production servers)
│   ├── asgi.py                                 # ASGI application entry point (for async support)
│ 
├── images/                                     # Directory to store generated character images
├── static/                                     # Static files (CSS, JS, images)
├── cli_typer.py                                # CLI commands using Typer for managing the project
├── docker-compose.yml                          # Docker Compose configuration for services (web, db, adminer)
├── Dockerfile                                  # Docker setup for containerized deployment
├── Makefile                                    # Helper commands for managing the project easily
├── LICENSE                                     # Licensing information for the project
├── poetry.lock                                 # Poetry dependencies lockfile (ensures consistency)
├── pyproject.toml                              # Poetry dependency manager configuration
├── pytest.ini                                  # Pytest configuration for test discovery and execution
├── manage.py                                   # Django management commands entry point
└── README.md                                   # Project documentation with setup, usage, and deployment instructions
```

## Features

### User Authentication
- Users can sign up, log in, and log out securely.

### Character Management
- Users can create characters by filling out a form with specific attributes such as age, gender, ethnicity, hair style, clothing, expression, and more.
- Characters can be updated or deleted as needed.

### AI-Powered Image Generation
- When a character is created or updated, the application dynamically constructs a text-based prompt describing the character’s attributes.
- This prompt is sent to OpenAI's DALL·E 3 model to generate an AI-rendered portrait of the character.
- The generated image is then linked to the character profile.

### Logging and Error Handling
- The application logs key events such as character creation, updates, and deletions.
- If the image generation fails, users receive an error message, and the failure is logged for debugging purposes.

### Docker Compose:
- The project is containerized using Docker Compose, allowing for easy setup and management of all services, including the web application, PostgreSQL database, and admin interface.
- The web service runs the Django app, while the db service handles the PostgreSQL database. The adminer service provides a web-based database management interface.

### PostgreSQL Database:
- PostgreSQL is used to store all the user and character data. It’s configured to handle user data and image generation attributes securely and efficiently.

### Logging:
- The application features comprehensive logging to capture important events and errors throughout its lifecycle, ensuring maintainability and easy debugging.

### Testing with Pytest:
- The project uses Pytest for testing. Unit and integration tests ensure that the application behaves as expected, from the user authentication system to the image generation process.

This project offers an interactive way to visualize characters through AI-generated art, making it especially useful for writers, game developers, and creative artists who want to bring their ideas to life. The combination of Docker, PostgreSQL, Typer, logging, and testing ensures that the project is robust, scalable, and easy to manage.




## Installation & Setup

### Requirements

Before you begin, ensure you have the following installed:
- [Docker](https://www.docker.com/get-started) 
- [Poetry](https://python-poetry.org/docs/#installation)
- [Python 3.12](https://www.python.org/downloads/)


### Clone the Repository
```bash
git clone https://github.com/luis-barbara/backend-i/tree/main/AI-IMAGE-GENERATOR.git
```

### Set Up Environment Variables
Create a `.env` file in the root directory and configure it with the necessary settings:
```bash
POSTGRES_DB=your_database
POSTGRES_USERNAME=your_username
POSTGRES_PASSWORD=your_password
POSTGRES_HOST=db
POSTGRES_PORT=5432
OPENAI_API_KEY=your_openai_key
DJANGO_DEBUG=True
```

Make sure to replace `yourpassword` and `your_openai_api_key` with your actual PostgreSQL password and OpenAI API key.

### Install Dependencies

You can either run the app using Docker or install the dependencies directly on your machine.

#### Docker Setup

If you prefer using Docker, you can skip the dependency installation and directly run the app using Docker Compose (recommended for a consistent environment).

```bash
make compose.bootstrap
```

This command will:
- Build the Docker images.
- Start the Docker containers.
- Apply database migrations.
- Create a superuser for accessing the Django Admin.

#### Local Setup

If you want to run the application locally without Docker, first install the dependencies using Poetry:

```bash
poetry install
```

Then run the Django development server:

```bash
poetry run python manage.py runserver
```

## Usage

Once the application is running, you can:

### 1. Access the Application

Open your browser and navigate to:

```
http://localhost:8000
```

You will be prompted to sign up or log in. After authentication, you can create and manage your characters.

### 2. Manage Characters

You can create, edit, and delete characters through the web interface. Each character has the following attributes:

- Name
- Age
- Gender
- Ethnicity
- Hair Style
- Clothing
- Expression
- ...

### 3. AI Image Generation

When creating or updating a character, the app will send a description of the character’s attributes to OpenAI's DALL·E 3 model to generate an AI-generated image. The image will be associated with the character.

### 4. CLI Commands

You can also use the Typer-based CLI to manage your characters and view statistics. Some example commands:

- **List all characters**:  
  ```bash
  make cli.list-characters
  ```

- **Delete a character** (by `character_id`):  
  ```bash
  make cli.delete-character character_id=1
  ```

- **Show character statistics**:  
  ```bash
  make cli.character-stats
  ```

- **Start the development server**:
  ```bash
  make cli.runserver
  ```

### 5. Run Tests

To run the tests locally with Poetry:

```bash
make tests
```

Or, to run the tests using Docker Compose:

```bash
make compose.tests
```

## Docker Compose Commands

- **Start the application** (builds and runs the containers):

  ```bash
  make compose.start
  ```

- **Run migrations** with Docker Compose:

  ```bash
  make compose.migrate
  ```

- **Create a superuser** with Docker Compose:

  ```bash
  make compose.superuser
  ```

- **Bootstrap the application** (start, migrate, and create superuser):

  ```bash
  make compose.bootstrap
  ```


### Django Settings

The settings for the project are defined in `dali/settings.py`. You can configure the database, static files, and other settings based on your environment.


### Logs and Error Handling

The application logs important actions such as character creation and updates. Errors related to image generation (e.g., API failures) are also logged for debugging purposes.

## Contributing

If you'd like to contribute to this project, feel free to fork the repository, create a branch, and submit a pull request. Please ensure that you write tests for new features and follow the coding standards.


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.



