# Geolocation API

This is a Ruby on Rails application that provides an API for managing geolocations. The application allows you to create, show, and delete geolocation records based on IP addresses or URLs.

## Prerequisites

- Docker
- Docker Compose

## Setup

1. Clone the repository:

   ```sh
   git clone https://github.com/lkalwa/geolocation-api.git
   cd geolocation-api
   ```

2. Create a `.env` file and set the `IP_STACK_API_KEY` (get it from: https://ipstack.com/signup/free):

   ```sh
   echo "IP_STACK_API_KEY=your_api_key_here" > .env
   ```

3. Build and start the Docker containers:

   ```sh
   docker-compose up --build
   ```

4. Migrate test db and run tests to ensure everything is set up correctly:

   ```sh
   docker-compose --profile setup run test_db_migrate
   docker-compose --profile test run test
   ```

## Usage

### Starting the Server

To start the Rails server, run:

```sh
docker-compose up
```

The server will be available at `http://localhost:3000`.

### API Endpoints

#### Create Geolocation

- **URL:** `/geolocations`
- **Method:** `POST`
- **Headers:**
    - `Content-Type: application/json`
    - `Accept: application/json`
- **Body:**

  ```json
  {
    "geolocation": {
      "ip": "46.242.241.35",
      "url": "www.katowice.pl"
    }
  }
  ```

- **Response:**

    - **Success:** `201 Created`
    - **Error:** `422 Unprocessable Entity`

#### Show Geolocation

- **URL:** `/geolocation/show`
- **Method:** `GET`
- **Headers:**
    - `Content-Type: application/json`
    - `Accept: application/json`
- **Params:**
    - `ip` or `url`

- **Response:**

    - **Success:** `200 OK`
    - **Error:** `404 Not Found`

#### Delete Geolocation

- **URL:** `/geolocation/destroy`
- **Method:** `DELETE`
- **Headers:**
    - `Content-Type: application/json`
    - `Accept: application/json`
- **Params:**
    - `ip` or `url`

- **Response:**

    - **Success:** `204 No Content`
    - **Error:** `404 Not Found`

## Error Handling

The application handles the following custom errors:

- **NetworkError:** Returns a `503 Service Unavailable` status with a message indicating network issues.
- **IpStackError:** Returns a `422 Unprocessable Entity` status with the error message from the IpStack service.

## Contributing

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add new feature'`).
5. Push to the branch (`git push origin feature-branch`).
6. Create a new Pull Request.

## License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/lkalwa/geolocation-api/blob/main/LICENSE) file for details.
```
