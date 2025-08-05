# HomeLight AI Rails App Starter Template

This is a template repo that should be cloned to start any new AI app project.

It is set up so that you can use an AI tool like CODEX or CURSOR AGENT to write your code, create a PR, and have that PR automatically deployed to a staging environment for testing.

## Setup Instructions

1. Get Mike Abner to help you create a new GitHub repository and set up AWS Credentials as Repository Secrets.
2. Clone the new repo to your local machine `git clone ...`
3. Run `bundle install` to install your dependencies.
4. Update application.rb line 9 to reflect your applications name
5. Update the /app/views/pwa/manifest.json.erb file to reflect your applications name
6. Update the database.yml file and replace the `app_` part of the database names with your apps name. e.g. `app_development` should become `hapi_development` if we were building hapi.
7. Update the ./scripts/build_and_deploy.sh file and set the `IMAGE_NAME` variable to the name of the new app
8. Make sure you have a local PostgreSql instance running (i recommend Postgres.app)
9. Run `rails db:setup`. You should see a few messages like `Created database 'app_development'`.
10. Run `rspec`. This should run quickly and output `0 examples, 0 failures`
11. Run `rails s` and when it starts use a browser and open `http://localhost:3000`. You should see a rails intro page.
12. Set up your new repo in Codex/Cursor Agent so that it can see your code.
13. Get Mike Abner to set up an ECR Repository for the new app
14. Make your first PR (and make it easy!) so that GitHub will kick off a build and deploy of the app.
15. Get Mike Abner to help you set up an app in Porter and database at CrunchyBridge
16. Prompt away!
