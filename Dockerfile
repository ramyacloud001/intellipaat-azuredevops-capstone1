# Use a base image with Apache or Nginx (whichever is suitable for your web app)
FROM hshar/webapp:latest

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy the source code to the container's web directory
COPY . /var/www/html

# Expose port 80 to the host machine
EXPOSE 80

# Start Apache or Nginx web server
CMD ["apachectl", "-D", "FOREGROUND"]
