# FORBIDDEN

Never take any action with git. 
Dont run any git commands

# ALLOWED

You MUST google search each documentation source for any given resource / modules / package you are using, using the official docs as guidance.

## Project Goal

The goal of this project is to create a local development environment using Terraform, Minikube, Helm, and Istio. The application is a simple web server that returns the Pod's IP address.

### Key Requirements:

- **Application:** A simple web server that responds to `GET /info` requests.
- **Application Logic:** The web server should return the Pod's IP address in both the response body (as JSON) and a custom response header `x-pod-ip`.
- **Infrastructure:**
    - The infrastructure should be defined in Terraform or cdktf.
    - Moto should be used in proxy mode to simulate AWS services (CloudFront, WAF, ALB).
    - A local Kubernetes cluster should be set up using Minikube.
    - Istio and the application should be packaged as Helm charts and installed using Terraform.
- **Routing:**
    - Requests to the application should be routed exclusively through Istio.
    - The application should not be exposed outside of the cluster.
    - The Istio Ingress should be published on TCP port 30080.
    - Requests should be routed to the application only if they include the HTTP Host header `api.app.com`.
- **Deployment:**
    - An idempotent bash script named `deploy.sh` should be created to provision the entire solution locally.
- **Documentation:**
    - A `README.md` file should be created to explain how to initialize the project.

## Project Structure

- **`Challenge.md`**: A markdown file, probably describing the project's challenge.
- **`image.png`**: An image file.
- **`Pasted image 20251030163250.png`**: Another image file.
- **`project/`**: The main project directory.
    - **`app/`**: Contains the Rust web server application.
        - **`src/main.rs`**: The main source code for the web server.
        - **`Cargo.toml`**: The Rust project's manifest file, containing dependencies and metadata.
        - **`target/`**: The directory where the compiled code and dependencies are stored.
    - **`infrastructure/`**: Contains infrastructure-related files.
        - **`dev/`**: A directory for development-related infrastructure files.
    - **`setup/`**: Contains setup scripts.
        - **`minikube/setupMinikube.sh`**: A script for setting up Minikube.
        - **`moto/`**: A directory, probably for AWS Moto related setup.