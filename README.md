## Intro

This repo contains a small Rails app that showcases using WorkOS for SSO and Directory Sync.

The app also lets you generate infinite high fives.

## Prerequisites

You will need the following to run this app locally:

- A [WorkOS organization](https://dashboard.workos.com/signup), with:
     - A redirect URI configured for `http://localhost:3000/auth/callback`
     - Directory Sync configured
     - _[Optional]_ [Enable the `department_name` custom attribute](https://workos.com/docs/directory-sync/attributes/custom-attributes) (the app is configured to display it if available)
- An Okta SAML app [connected to your WorkOS org](https://workos.com/docs/integrations/okta-saml)
- An Okta SCIM app [connected to your WorkOS org](https://workos.com/docs/integrations/okta-scim)
     - For best results, create and assign a few users to the app in Okta
- [Ruby 3.1.4](https://www.ruby-lang.org/en/documentation/installation/) installed locally

## Setup

1. Clone the repo.
     ```bash
     git clone https://github.com/SofyM/highfives.git
     ```

2. Run the setup script.
     ```bash
     sh setup.sh
     ```

     This creates an `.env` file for you, installs dependencies, and initializes the db locally.

     <details>
     <summary><b>Manual setup commands</b></summary>
     <blockquote>
     If you prefer to run the commands manually:
     
     ```bash
     # Copy the example .env file
     cp .env.example .env

     # Install dependencies
     bundle install

     # Initialize the database
     bin/rails db:migrate
     ```
     </blockquote>
     </details> 

3. Find the `.env` file created in step 2 and set the following values to those from your WorkOS organization:
     - `WORKOS_API_KEY`
     - `WORKOS_CLIENT_ID`
     - `WORKOS_ORGANIZATION_ID`

4. Start the app.

     ```bash
     ./bin/dev
     ```

     Visit `http://localhost:3000` and log in!

## Demo
https://github.com/user-attachments/assets/ad4a0a13-8230-4d5b-93cd-b7298f8b5902