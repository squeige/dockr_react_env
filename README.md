# Docker React Native DEV environment with SSH capabilites for remote coding.

As a usecase I wanted to setup a docker dev env in my local machine that was reproducible and easily transfered between my desktop and my laptop. I was thinking if I was a large enterprise and wanted to exploresay I had a company with new hires all the tools they needed to get coding as soon as possible what would be the fastest approach. I have some open security vulnerabilities with SSH and not using secrets for passwords. But as a usecase I am happy with the results and the execution.
## Getting Started

### Dependencies

You will need to have docker desktop installed with support for linux. 

### Installing

Clone this repo locally:
git clone https://github.com/squeige/dockr_react_env/

### Executing program
Check your default settings (SSH PASSWORD and LOCAL IP) inside the .env file
build your image either from the dockerfile or using docker compose, from the root directory 
  docker compose build<br />
Run your docker environment,<br />
  docker run --rm -it react_img<br />
  docker compose up -d<br />
Log into the running container<br />

I have provided an initial default expo project inside /var/www/ you can just copy that or edit that. Note the data under this folder is persitant. You will have it available wether or not the container is running.
You can start the app with npm start and code away.

docker exec -it dev-react-1 /bin/sh<br />
to enable ssh you will need to run<br />
/opt/scripts/startup.sh<br />



## Authors

Luigi Castro

## Acknowledgments

References used for this project<br />
https://github.com/hexops/dockerfile -- Docker File best practices<br />
https://docs.docker.com/ -- Docker Documentation Repo<br />
Other online documentation... <br />


