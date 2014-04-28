briskly [![Build Status](https://travis-ci.org/pedrocunha/briskly.svg?branch=master)](https://travis-ci.org/pedrocunha/briskly) [![Code Climate](https://codeclimate.com/github/pedrocunha/briskly.png)](https://codeclimate.com/github/pedrocunha/briskly)
=====

### Usage:

#### Storing:

You can store a collection within a specific key. The data must be an array of hashes with a keyword and an optional data argument. Keyword can
be an array.

```ruby
Briskly.store('cities').with([
  { keyword: ['London', 'Londres'], data: { id: 10, name: London } },
  { keyword: 'Berlin', data: { id: 15, name: Berlin } },
  { keyword: 'Barcelona', data: { id: 25, name: Barcelona } }
)]
```

- Elements are returned in the order they were inserted
- Re-using the same key **overrides** the existing collection



#### Searching:

Search on collections using `#on`. The result is composed by an hash with the key(s) requested 
and the values are instances of `Briskly::Element` class. This object responds to `#keyword` and `#data`.

```ruby
Briskly.store('cities').with([
  { keyword: ['London', 'Londres'], data: { id: 10, name: London } },
  { keyword: 'Berlin', data: { id: 15, name: Berlin } },
  { keyword: 'Barcelona', data: { id: 25, name: Barcelona } }
)]

result = Briskly.on('cities').search('lon')

result
=> { 'cities' => [ #Briskly::Element ... ]

result['cities'].first.keyword
=> 'London'

result = Briskly.on('cities').search('londres')
result['cities'].first.keyword
=> 'Londres'
```

Example with multiple collections

```ruby
Briskly.store('cities').with([
  { keyword: 'Foo' },
  ...
)]

Briskly.store('countries').with([
  { keyword: 'Foobear' },
  ...
)]

result = Briskly.on('countries', 'cities').search('foo')

result
=> { 'cities' => [ #Briskly::Element ], 'countries' => [ #Briskly::Element ] }
```

Notes:
- Search is not case sensitive
- Results are returned only if they match beginning of word



Note on Patches/Pull Requests
=============================

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

License
============
MIT licence. Copyright (c) 2013 HouseTrip Ltd.

