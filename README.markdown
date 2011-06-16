# Orthrus

http://github.com/xijo/orthrus

In Greek mythology, Orthrus (Greek: Όρθρος) was a two-headed dog and son of Typhoeus.
He was charged with guarding Geryon's herd of red cattle in Erytheia.

## Typhoeus

Thanks to the guys who are developing Typhoeus (http://github.com/dbalatero/typhoeus)

Orthrus is a small extension inspired by the original remote method API from Paul Dix
which is deprecated in the current Typhoeus release.

It can be used to encapsulate remote method calls in a clean way and provide an
easy interface to work with.

## Installation

    gem install orthrus

## Usage

*Simple: OpenLibrary Example*

    require 'rubygems'
    require 'typhoeus'
    require 'orthrus'

    class OpenLibrary
      include Orthrus
      remote_defaults :base_uri => "http://openlibrary.org/api"

      define_remote_method :book, :path => '/books'
    end

    book = OpenLibrary.book(:params => {:bibkeys => "ISBN:0451526538", :format => "json"})
    puts book.inspect # Typhoeus::Response

*Advanced: Twitter Example with JSON handling and path interpolation*

    require 'rubygems'
    require 'typhoeus'
    require 'orthrus'
    require 'json'

    class Twitter
      include Orthrus
      remote_defaults :on_success => lambda { |response| JSON.parse(response.body) },
                      :on_failure => lambda { |response| puts "error code: #{response.code}"; {} },
                      :base_uri   => "http://api.twitter.com"

      define_remote_method :search, :path   => "/:version/search.json"
      define_remote_method :trends, :path   => "/:version/trends/:time_frame.json"
      define_remote_method :tweet,  :path   => "/:version/statuses/update.json",
                                    :method => :post
    end

    # Get all tweets mentioning pluto
    tweets = Twitter.search(:version => 1, :params => {:q => "pluto"})

    # Get all current trends
    trends = Twitter.trends(:version => 1, :time_frame => :current)

    # Submit a tweet. Authentication skipped in example.
    Twitter.tweet(:version => 1, :params => {:status => "I #love #planets! :)"})

## TODO

 - no cache handling yet.
 - make requests hydra-compatible
 - set default parameters

## Author

Johannes Opper <xijo@gmx.de>

## License

Published under the Ruby License. For detailed information see
http://www.ruby-lang.org/en/LICENSE.txt and http://www.ruby-lang.org/en/COPYING.txt