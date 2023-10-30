FROM node:latest

# define the current working directory
WORKDIR /client

COPY package*.json ./

# install project dependencies
RUN npm install

COPY . /client

EXPOSE 5173
