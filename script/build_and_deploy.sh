#!/bin/bash
set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <environment>"
    echo "Environments: development, staging, production"
    exit 1
fi

ENV=$1

# Validate environment
if [[ ! "$ENV" =~ ^(development|staging|production)$ ]]; then
    echo "Invalid environment. Must be one of: development, staging, production"
    exit 1
fi

if [ "$ENV" == "production" ]; then
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    git fetch origin main >/dev/null 2>&1
    LOCAL_MAIN=$(git rev-parse main)
    REMOTE_MAIN=$(git rev-parse origin/main)
    if [ "$CURRENT_BRANCH" != "main" ] || ! git diff-index --quiet HEAD -- || [ "$LOCAL_MAIN" != "$REMOTE_MAIN" ]; then
        echo "Please commit any changes and sync main with gihub before deploying"
        exit 1
    fi
fi

echo "Building Docker image for $ENV environment"

# Check if env file exists
# ENV_FILE=".env.$ENV"
# if [ ! -f "$ENV_FILE" ]; then
#     echo "Warning: $ENV_FILE not found. Creating from .env.example"
#     if [ ! -f .env.example ]; then
#         echo "Error: .env.example not found"
#         exit 1
#     fi
#     cp .env.example "$ENV_FILE"
#     echo "Please update $ENV_FILE with your configuration before running the container"
# fi

# echo "Loading environment variables from $ENV_FILE (secrets masked)"

# # Securely load environment variables
# set -a
# source "$ENV_FILE"
# set +a

# # Print confirmation with masked values
# echo "Environment: $ENV"
# echo "Database: *********$(echo $POSTGRES_URL | sed 's/.*@/@/')"
# echo "API keys: ******** (masked for security)"

TODAY=$(date +%s)
COMMIT_HASH=$(git rev-parse --short HEAD)
IMAGE_NAME="app"-${ENV}
TAG="${COMMIT_HASH}${TODAY}"
ECR_REPOSITORY="020742127634.dkr.ecr.us-east-1.amazonaws.com"

echo "Building Docker image ${IMAGE_NAME}:${TAG} for Linux platform..."
docker build --no-cache \
    --platform linux/amd64 \
    -t ${IMAGE_NAME}:${TAG} .

echo "Docker image ${IMAGE_NAME}:${TAG} built successfully"

echo "Configuring AWS..."
aws configure set aws_access_key_id ${AWS_KEY}
aws configure set aws_secret_access_key ${AWS_SECRET}

echo "Tagging image for ECR..."
docker tag ${IMAGE_NAME}:${TAG} ${ECR_REPOSITORY}/${IMAGE_NAME}:${TAG}

echo "Logging in to ECR..."
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ECR_REPOSITORY}

echo "Pushing image to ECR..."
docker push ${ECR_REPOSITORY}/${IMAGE_NAME}:${TAG}

echo "Successfully built and pushed ${ECR_REPOSITORY}/${IMAGE_NAME}:${TAG}"

if [ "$ENV" == "staging" ]; then
    echo "Deploying to staging..."
    # echo "https://dashboard.porter.run/api/webhooks/deploy/PORTER_DEPLOY_ID?commit=${TAG}"
    # echo "https://dashboard.porter.run/api/webhooks/deploy/PORTER_DEPLOY_ID?commit=${TAG}"
    # curl -X POST "https://dashboard.porter.run/api/webhooks/deploy/PORTER_DEPLOY_ID?commit=${TAG}"
    # curl -X POST "https://dashboard.porter.run/api/webhooks/deploy/PORTER_DEPLOY_ID?commit=${TAG}"
fi

if [ "$ENV" == "production" ]; then
    echo "Deploying to production..."
    # echo "https://dashboard.porter.run/api/webhooks/deploy/PORTER_DEPLOY_ID?commit=${TAG}"
    # echo "https://dashboard.porter.run/api/webhooks/deploy/PORTER_DEPLOY_ID?commit=${TAG}"
    # curl -X POST "https://dashboard.porter.run/api/webhooks/deploy/PORTER_DEPLOY_ID?commit=${TAG}"
    # curl -X POST "https://dashboard.porter.run/api/webhooks/deploy/PORTER_DEPLOY_ID?commit=${TAG}"
fi
