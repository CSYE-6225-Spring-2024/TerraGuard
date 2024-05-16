## TerraGuard

### Introduction

TerraGuard stands as a premier project demonstrating my adaptability to diverse tech stacks and expertise in system design. It features a GCP-deployed application managed through Terraform, incorporating load balancing, firewalls, databases, machine images, and resource encryption. GitHub Actions facilitate continuous integration and deployment to GCP.

### Infrastructure

![Alt text](https://github.com/tf-gcp-2024/TerraGuard/blob/main/terraguard-infra.jpg?raw=true)

### user-auth-app

#### 1\. Overview

The `user-auth-app` folder serves as a submodule within _TerraGuard_ repository. It contains the application that facilitates user authentication and management. Key functionalities include:

- **Account Creation**: Users can register and create their own accounts.
- **User Management**: Users can retrieve and update their personal details.
- **Authorization**: Ensures that access to information is secure and restricted to authorized users.
- **Event Driven Architecture**: When a user registers, their details are published as JSON to a specific **Google Pub/Sub topic**, ensuring scalable and responsive interactions.
- **Logging**: The **Winston** library is used for logging, mainly for monitoring purposes, and is integrated with the **Google Ops Agent** for effective log management.
#### 2\. Testing

The repository includes test cases for the web application, ensuring that each component functions correctly and efficiently. These tests are crucial for maintaining the reliability of the application, particularly when updates or changes are introduced.

#### 3\. Packer Configuration

The project utilizes Packer to create machine images, which are essential for deploying consistent and predictable environments. The repository contains:

- **Packer Setup**: Configuration files necessary for Packer to create the machine images.
- **Build Files**: Scripts and commands that define the steps Packer follows to build the images.

#### 4\. CI/CD Workflows

Continuous integration and continuous deployment (CI/CD) are implemented to automate the testing and deployment processes. The workflows triggered on pull requests include:

- **Testing**: Automated tests are run to validate the functionality and stability of the web application.
- **Packer Image Validation and Deployment**: Validates the Packer build files and, upon successful validation, uploads the resulting machine images to **Custom Images in GCP**.
- **Instance Management**: Creates a new template and attaches it to the **GCP-Managed Instance Group (MIGs)**. This integration allows for a rolling update action, ensuring minimal downtime and smooth transitions when updating instances.

This setup not only streamlines the development and deployment processes but also ensures that your application remains robust and scalable. The use of GCP and tools like Packer highlights a focus on efficiency, security, and reliability. If anyone needs more detailed information on any specific part of the setup or have other questions, feel free to ask! **_(anirbandutta1098@gmail.com)_**

### terraform-gcp-infra

#### 1\. Overview

The `terraform-gcp-infra` folder is a submodule within the TerraGuard repository, dedicated to managing **Infrastructure as Code (IaC)** using Terraform for deployments on Google Cloud Platform (GCP). This submodule is instrumental in provisioning and managing a wide array of resources such as **CloudSQL databases, encryption keys, compute instances, templates, firewalls, service accounts, autoscalers, managed instance groups, and serverless cloud functions**. Terraform automates the creation and teardown of these resources, ensuring efficient and reproducible deployments.

### serverless-cf

#### 1\. Overview

The `serverless-cf` folder is another submodule within the TerraGuard repository, containing the code for a serverless cloud function **(Function as a Service, or FaaS)**. This function utilizes an event-driven architecture and is activated by **Google Cloud Pub/Sub** through a push mechanism. When triggered, it orchestrates the sending of a verification link via email to the user, which includes an expiration time for added security. This setup ensures efficient, scalable handling of user verification processes without the need for dedicated server infrastructure.
