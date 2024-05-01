# emina.dev
> personal website / blog 

### Overview

..

### Features

..

### Prerequisites

- Ensure that you have the following installed on your machine:
    - Ruby: Download and install Ruby 3.3.
    - Rails: Ensure you have Rails 7.1 installed. You can install it by running `gem install rails`.
    - Bundler: Install Bundler by running `gem install bundler`.
    - PostgreSQL: Download it from the [official website](https://www.postgresql.org/download), or use your operating system's package manager for installation.
- CLIENT_ID and CLIENT_SECRET from [Google Developer Console](https://console.developers.google.com/project)

### Setup
1. Clone this repository to your local machine:
    ```
    git clone https://github.com/em-jov/emina_dev.git
    ```
2. Navigate to the project directory:
    ```
    cd emina_dev
    ```
3. Install dependencies using Bundler:
    ```
    bundle install
    ```
3. Set up the database:
    ```
    rails db:create
    rails db:migrate
    ```
3. Configure:
    - Create a new file named `.env` and paste the content from the `.env.example` file into it
    - Update the `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` variables
    - Modify the `WHITELIST_EMAILS` variable to include email addresses permitted to access the application and then run: 
    ```
    rails db:seed
    ```

### Deployment

..

### Contributing
Your contributions are welcome and appreciated. If you find issues or have improvements, feel free to open an issue or submit a pull request.

### License
[MIT License](MIT-LICENCE.txt)