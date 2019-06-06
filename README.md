# Overview
I got a new Windows laptop, and had a terrible time trying to set up dual-booting Linux. I also have been
exploring the [Nerves project](https://nerves-project.org/). This repo keeps my notes for various ways to
build a Nerves project and burn it to an SD card.

I recommend [Rufus](https://rufus.ie/) to burn the final Nerves image SD cards. Feel free to use a different
program, but it has worked well for me.

# Option 1: Build with Docker
## Prep
### Basic Setup
You should copy the files from this repo (at least the dockerfile and deb packge) to the folder that holds your
Nerves code. Once that's done, install the required software (if you don't have it) and open up a command prompt
to the folder holding the code.

### Required Software
* [Docker](https://www.docker.com/) - when you set it up, configure it to build Linux containers, not Windows.
You can switch between the two if you need to

### Build Docker Image
Open up a command prompt to the directory that has the dockerfile in it and run this command:
`docker build -t build_nerves:latest .`

This will build the image and tag it as build_nerves:latest. Feel free to change the tag, but that will be the tag
used in later steps.

### Optional: Check Code Into a Git Repo
The steps to build are assuming that you around building from code that is checked into a git repo. Alternatively,
the code could just be on your local machine. For that to work, you'll need to set up the file mounts in Docker.
It is also possible that you run into issues with previous builds from your host machine: since those binaries
were built on Windows, they may be incompatible in the Linux container.

## Build Your Code
To build your code, open a command prompt and enter the following commands:
1. `docker run -it --rm -v C:\{path-to-output}:/var/image-output build_nerves:latest bash`
    * This will start a Docker image in interactive mode, delete it when you are done, and map a local path to /var/image-output in the container.
    * The image that you'll use is the build_nerves image that comes from the dockerfile in this repo.
    * I generally put my Nerves images in C:\code\nerves-images, so my command looks like this:
        * `docker run -it --rm -v C:\code\nerves-images:/var/image-output build_nerves:latest bash`
2. `mix archive.install hex nerves_bootstrap`
    * Inside the interactive Docker shell, this will install the nerves_bootstap hex package.
3. `git clone {repo}`
    * This will pull down the code via git. If you are getting code into the Docker image some other way, you can skip this.
    * This quick walkthrough doesn't cover setting up SSH keys, so you will need to use https to clone the repo (or, set up the SSH keys).
    * To use one of the example projects, you can do this: `git clone https://github.com/nerves-project/nerves_examples`.
4. `export MIX_TARGET=rpi3`
    * This sets your Nerves target. I mostly play around with Raspberry Pi 3s.
5. `cd {repo}`
    * Navigate to the code. For example, if you want to build nerves_examples/blinky, you can do: `cd nerves_examples/blinky`.
6. `mix deps.get`
    * Get the dependencies for the project.
7. `mix firmware`
    * Builds the project.
8. `mix firmware.burn -d /var/image-output/build.img`
    * Creates an image file that can be burned to an SD card. It will go to the directory you mapped on your local drive.

You now have a newly minted Nerves image to play with! You can open up Rufus to burn the image to an SD card.

You should now be good to go! Good luck!

# Option 2: Build with GitLab CI
## Setup GitLab project
TODO

## Build and Download Image
TODO

