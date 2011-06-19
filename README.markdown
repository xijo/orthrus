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

In general, Orthrus will accept all options that Typhoeus does. Here are some
examples how to use it:

### Simple Example: OpenLibrary

    require 'rubygems'
    require 'typhoeus'
    require 'orthrus'

    class OpenLibrary
      include Orthrus
      remote_defaults :base_uri => "http://openlibrary.org/api", :format => "json"

      define_remote_method :book, :path => '/books'
    end

    book = OpenLibrary.book(:params => {:bibkeys => "ISBN:0451526538"})
    puts book.inspect # Typhoeus::Response

### Advanced: Twitter Example with JSON handling and path interpolation

    require 'rubygems'
    require 'typhoeus'
    require 'orthrus'
    require 'json'

    class Twitter
      include Orthrus
      remote_defaults :on_success => lambda { |response| JSON.parse(response.body) },
                      :on_failure => lambda { |response| puts "error code: #{response.code}"; {} },
                      :base_uri   => "http://api.twitter.com",
                      :version    => 1

      define_remote_method :search, :path   => "/:version/search.json"
      define_remote_method :trends, :path   => "/:version/trends/:time_frame.json"
      define_remote_method :tweet,  :path   => "/:version/statuses/update.json",
                                    :method => :post
    end

    # Get all tweets mentioning pluto
    tweets = Twitter.search(:params => {:q => "pluto"})

    # Get all current trends
    trends = Twitter.trends(:time_frame => :current)

    # Submit a tweet. Authentication skipped in example.
    Twitter.tweet(:params => {:status => "I #love #planets! :)"})


### Hydra

To use Typhoeus' hydra to perform multiple request parallel, you can set the `return_request` option
in `remote_defaults`, `define_remote_method` or even on per request basis to `true`.
Orthrus will return the crafted Typhoeus::Request, including the success and error handling.

    require 'rubygems'
    require 'typhoeus'
    require 'orthrus'

    class WeatherInformation
      include Orthrus
      remote_defaults :base_uri       => "http://wackyweather.test",
                      :return_request => true

      define_remote_method :city, :path => "/city/:name"
    end

    hydra = Typhoeus::Hydra.new
    hydra.queue new_york = WeatherInformation.city(:name => "new_york")
    hydra.queue berlin   = WeatherInformation.city(:name => "berlin")
    hydra.run

    puts berlin.handled_response

For more information about the hydra feature, visit: http://github.com/dbalatero/typhoeus

## TODO

 - no cache handling yet.

## Author

Johannes Opper <xijo@gmx.de>

## License

Published under the Ruby License. For detailed information see
http://www.ruby-lang.org/en/LICENSE.txt and http://www.ruby-lang.org/en/COPYING.txt