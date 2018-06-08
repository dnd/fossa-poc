FROM ruby:2.5.1

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qqy \
    && apt-get install -qqyy \
      libpq-dev \
      locales \
      nodejs \
      yarn \
    && apt-get clean \
    && rm -f /var/lib/apt/lists/*_*

RUN curl https://raw.githubusercontent.com/fossas/fossa-cli/master/install.sh | bash

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
 && locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle

ENV PATH="${BUNDLE_BIN}:${PATH}"

WORKDIR /app
#COPY Gemfile Gemfile.lock /app/
COPY . .

COPY ./docker/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
