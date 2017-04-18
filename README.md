### avidya: My effort while trying to unlearn and learn new ways of working. 
 
## Crux of Project:
   1. Try to understand and implement immutable infrastructure
   2. Use Terraform for Infrastructure Provisioning. Dockerize it.
   3. Use Ansible for Configuration management. Dockerize it.
   4. Use Docker for application containarisation and kubernetes for deployment. Dockerize it.

## Chapter 1:
   1. Dockerize terraform with Dockerfile. It uses official Terraform docker image as base image but gives us flexibility to add more custom stuff later.
   2. Built Docker image ``` docker build -t gssumesh/avidya .```
   3. Run image to see help option : ``` docker run --rm gssumesh/avidya ```
