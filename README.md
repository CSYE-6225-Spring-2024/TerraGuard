## TerraGuard

### Introduction

TerraGuard stands as a premier project demonstrating my adaptability to diverse tech stacks and expertise in system design. It features a GCP-deployed application managed through Terraform, incorporating load balancing, firewalls, databases, machine images, and resource encryption. GitHub Actions facilitate continuous integration and deployment to GCP.

### Infrastructure

### user-auth-app

The `user-auth-app` folder serves as a submodule within *TerraGuard* repository. It contains the application that facilitates user authentication and management. Key functionalities include:

- **Account Creation**: Users can register and create their own accounts.
- **User Management**: Users can retrieve and update their personal details.
- **Authorization**: Ensures that access to information is secure and restricted to authorized users.

### 2\. Testing

The repository includes test cases for the web application, ensuring that each component functions correctly and efficiently. These tests are crucial for maintaining the reliability of the application, particularly when updates or changes are introduced.

### 3\. Packer Configuration

The project utilizes Packer to create machine images, which are essential for deploying consistent and predictable environments. The repository contains:

- **Packer Setup**: Configuration files necessary for Packer to create the machine images.
- **Build Files**: Scripts and commands that define the steps Packer follows to build the images.

### 4\. CI/CD Workflows

Continuous integration and continuous deployment (CI/CD) are implemented to automate the testing and deployment processes. The workflows triggered on pull requests include:

- **Testing**: Automated tests are run to validate the functionality and stability of the web application.
- **Packer Image Validation and Deployment**: Validates the Packer build files and, upon successful validation, uploads the resulting machine images to **Custom Images in GCP**.
- **Instance Management**: Creates a new template and attaches it to the **GCP-Managed Instance Group (MIGs)**. This integration allows for a rolling update action, ensuring minimal downtime and smooth transitions when updating instances.

This setup not only streamlines the development and deployment processes but also ensures that your application remains robust and scalable. The use of GCP and tools like Packer highlights a focus on efficiency, security, and reliability. If anyone needs more detailed information on any specific part of the setup or have other questions, feel free to ask! ***(anirbandutta1098@gmail.com)***

### terraform-gcp-infra

### serverless-cf
