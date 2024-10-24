# AWS-CLOUDFRONT-TERRAFORM

This repository contains a Terraform configuration for setting up an Amazon CloudFront distribution that serves content from an S3 bucket. This setup enables efficient content delivery and provides enhanced security features for your web applications.

## Overview

The Terraform code provisions a CloudFront distribution configured to access an S3 bucket. It uses Origin Access Control (OAC) for secure access and ensures that content is delivered with low latency through AWS’s global content delivery network (CDN).

### Key Features

- **CloudFront Distribution**: Creates a CloudFront distribution to serve content from an S3 bucket.
- **Origin Access Control**: Utilizes OAC to securely access the S3 bucket.
- **Viewer Protocol Policy**: Redirects HTTP requests to HTTPS for enhanced security.
- **Caching and Performance**: Configures cache behaviors and TTL settings to optimize content delivery.
- **SSL Support**: Integrates with AWS Certificate Manager (ACM) for SSL certificate management.

## Configuration Files

### main.tf

This is the primary configuration file where the CloudFront distribution and its settings are defined.

#### Key Resources

- **Origin Access Control**: 
  - Configures access controls for the S3 origin, ensuring that only CloudFront can access the bucket.
  - Sets the signing behavior and protocol to `sigv4`.

- **S3 Bucket Data Source**: 
  - References an existing S3 bucket by its name, allowing CloudFront to pull content from it.

- **CloudFront Distribution**: 
  - Sets up the CloudFront distribution with various configurations:
    - **Origin**: Defines the S3 bucket as the origin.
    - **Default Root Object**: Specifies the default object to serve (e.g., `index.html`).
    - **Aliases**: Allows for custom CNAMEs (e.g., `*.example.com`).
    - **Cache Behavior**: Configures caching, forwarding of query strings, and cookies.
    - **Geo Restrictions**: Can be configured for content access based on geographic location.
    - **Viewer Certificate**: Associates an SSL certificate for secure connections.

### provider.tf

Defines the AWS provider and specifies the required version. Ensure to set the AWS region and provide credentials either through environment variables or a `.tfvars` file.

### variables.tf

Defines variables that can be customized:

- **aws_region**: Specifies the AWS region where resources will be created (e.g., `us-east-1`).
- **access_key**: Your AWS account access key (recommended to use a `.tfvars` file).
- **secret_key**: Your AWS account secret key (recommended to use a `.tfvars` file).

## Modifying Variables

To customize your setup, you can modify the following variables:

- **`aws_region`**: Set this to your desired AWS region for resource creation.
- **`access_key`** and **`secret_key`**: Input your AWS credentials securely.

### Impact of Modifications

- Changing the **S3 bucket name** in the `data "aws_s3_bucket"` block will affect where the CloudFront distribution pulls content from. Ensure the bucket is set up correctly in AWS.
- Modifying the **aliases** in the CloudFront distribution allows the use of custom domain names for your distribution. Ensure that DNS records point to CloudFront.
- Adjusting cache behavior settings impacts how frequently content is updated in the cache, which can affect performance and content freshness.
- Changing the **viewer certificate** ARN requires that the certificate exists in ACM and is valid for the domain used.

## Usage

1. Update the variables in a `terraform.tfvars` file or set them as environment variables.
2. Initialize Terraform: 
   ```bash
   terraform init
   ```
3. Apply the configuration:
   ```bash
   terraform apply
   ```

This will create the CloudFront distribution and configure it to serve content from your S3 bucket.

## Contributing

Feel free to submit issues or pull requests for enhancements or improvements to this Terraform configuration.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
