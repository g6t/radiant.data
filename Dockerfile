FROM openanalytics/r-base

MAINTAINER Marcin Kosinski ""

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl1.0.0

# basic shiny functionality
RUN R -e "install.packages(c('shiny', 'rmarkdown', 'devtools'), repos='https://cloud.r-project.org/')"

# install dependencies of the radiant.data app
RUN R -e "devtools::install_github('g6t/radiant.data', ref = 'septemberdata')"

# copy the app to the image
RUN mkdir /root/app
COPY inst/app /root/app

EXPOSE 3838

CMD ["R", "-e shiny::runApp('/root/app')"]
