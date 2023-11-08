# Get slim version of ruby.
# This is fine since I have only one project based on ruby - so the image
# will try to be minimal.
# If you have many images that you will base with ruby, the default 
# ruby will be better since it includes other programs that debian 
# usually has. This will cache that image once, and the layers of 
# images based on ruby will be smaller in memory since they don't 
# have to install the packages already in the ruby image.


# get bullseye version of debian;
FROM ruby:3.1.4-slim-bullseye

# install build-essential and git and clear chache;
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# install jekyll and bundler, as well as perform cleanup
RUN gem update --system && gem install jekyll bundler \
    && gem cleanup

EXPOSE 4000

WORKDIR /site

CMD ["bash"]
