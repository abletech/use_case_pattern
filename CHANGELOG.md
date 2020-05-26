# AddressFinder 1.0.3 (May 27, 2020)

* Ruby 2.7 deprecated the use of hashes in the last argument of a method call. We added a check to handle that deprecation. Read more here: https://www.ruby-lang.org/en/news/2019/12/12/separation-of-positional-and-keyword-arguments-in-ruby-3-0/

# AddressFinder 1.0.2 (November 22, 2016) #

* Raise a ValidationError when #perform! fails rather that call the Rails 5 
  specific #raise_validation_error method

# AddressFinder 1.0.1 (October 12, 2016) #

* Declare support for activemodel/activesupport version 4.0 or better

# AddressFinder 1.0.0 (September 25, 2016) #

* Initial release
