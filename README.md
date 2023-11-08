# Purpose:
* This repo contains the files needed to host my personal website using Github pages.
* The current config uses the `/docs` directory from the `master` branch to build the website.
* Rebuilds get triggered by pushing/merging code to the `master` branch.

## Why Docker?
* Write the Dockerfile once, and guarantee the same container on each run. No need for remembering setups and difficulties when changing machines.
* No fiddling with the host machine, since everything runs inside the container.
* Pretty convenient for local testing of website; just start the container and follow the instructions in this README.
* I also pushed the image to dockerhub, so you should be able to directly `docker run -v $PWD/docs:/site -it -p 4000:4000 --name PICK_YOUR_CONTAINER_NAME mariovas/my-jekyll-image bash` which will check for the image on your host, pull from docker hub if not found locally, and create and start a new container.
    * This image was tested on Ubuntu:20.04 using only Docker Engine.
    * You should be able to build an image from the Dockerfile in the root of this repo following the instructions in this README with no issues on MacOS and Windows (having installed Docker Desktop). 
    * After building the image, you should use your respective version of `$PWD` which gives your current working directory and substitute that in the command above. This is the inconvenience of bind-mounting (depends on filesystem unlike docker volumes) as discussed in the docker docs.

## GH config peculiarities:
* Configure deployment dir from the GH GUI.
* GH will look for either `README.md`, `index.html` or `index.md` as an "entry file" to build your site using Jekyll. That file should be at the root level of the chosen directory to deploy from (e.g., `/docs` or `/` on the master branch).
* General configs should be in `_config.yml`, and the following cannot be changed (requried by GH):
    ```YAML
    lsi: false
    safe: true
    source: [your repo's top level directory]
    incremental: false
    highlighter: rouge
    gist:
    noscript: false
    kramdown:
    math_engine: mathjax
    syntax_highlighter: rouge
    ```
* By default Jekyll doesn't build files or directories:
    * starting with `_`, `.`, or `#`,
    * are located in a folder called `node_modules` or `/vendor`.
    * end with `~`.
    * are excluded using the `exclude` key word in the `_config.yml` file.
* The following Jekyll plugins cannot be disabled (required by GH):
    * jekyll-coffeescript
    * jekyll-default-layout
    * jekyll-gist
    * jekyll-github-metadata
    * jekyll-optional-front-matter
    * jekyll-paginate
    * jekyll-readme-index
    * jekyll-titles-from-headings
    * jekyll-relative-links
* If you want to add more plugins, do so under the `plugins:` keyword in the `_config.yml` file. The plugins must be supported by GH. Here is a [list of supported plugins](https://pages.github.com/versions/).

## This repo's usage:
* Navigate to the root of this repo.
* Build the docker image from the Dockerfile in the root of this repo:
    ```Bash
    docker build -t mariovas/my-jekyll-image -f Dockerfile .
    ```
* Open two terminals (or just start a `tmux` server).
* Run the container, bind-mounting the host's `/docs` directory to the `/site` directory of the container, in interactive mode with terminal emulators running `bash`, and publish port 4000 of host to the container's port 4000.:
    ```Bash
    docker run -v $PWD/docs:/site -it -p 4000:4000 --name jekyll-serve mariovas/my-jekyll-image bash
    ```
* If initial setup run:
    ```Bash
    jekyll new --skip-bundle .  # to create the static site files
    bundle add webrick  # since ruby version >= 3 - as per Jekyll docs
    ```
    And now edit the Gemfile with `sudo` privilege to remove the `gem "jekyll" line` and add `gem "github-pages", "~> GITHUB_PAGES_VERSION", group:jekyll_plugins`, substituting the `GITHYB_PAGES_VERSION` by the appropriate version from [dependencies](https://pages.github.com/versions/) for `github-pages`.
* Run
    ```Bash
    bundle install
    bundle exec jekyll serve --force-polling -H 0.0.0.0
    ```
The last command should start the webserver on `localhost:4000`, so you can check how it looks from your browser.

## Caveats:
* In the above config, I assume you have configured deployment from the `/docs` directory of this repo and not the root (check your github settings for this).