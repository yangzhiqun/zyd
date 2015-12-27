FROM index.tenxcloud.com/docker_library/ruby

RUN apt-get update 
RUN apt-get install -y mysql-client nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN gem sources --add https://ruby.taobao.org/ --remove https://rubygems.org/

RUN gem install bundler

RUN bundle config mirror.https://rubygems.org https://ruby.taobao.org

WORKDIR /webapp

COPY Gemfile /webapp/Gemfile
COPY Gemfile.lock /webapp/Gemfile.lock

RUN bundle install

EXPOSE 3000
