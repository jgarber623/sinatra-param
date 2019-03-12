# sinatra-param

**Parameter Validation, Transformation, and Type Coercion for [Sinatra](http://sinatrarb.com) applications.**

[![Build](https://img.shields.io/travis/com/jgarber623/sinatra-param/master.svg?style=for-the-badge)](https://travis-ci.com/jgarber623/sinatra-param)
[![Dependencies](https://img.shields.io/depfu/jgarber623/sinatra-param.svg?style=for-the-badge)](https://depfu.com/github/jgarber623/sinatra-param)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/jgarber623/sinatra-param.svg?style=for-the-badge)](https://codeclimate.com/github/jgarber623/sinatra-param)
[![Coverage](https://img.shields.io/codeclimate/c/jgarber623/sinatra-param.svg?style=for-the-badge)](https://codeclimate.com/github/jgarber623/sinatra-param/code)

sinatra-param adds useful helpers to your Sinatra application, allowing you to declare, validate, and transform URL endpoint parameters. By default, Sinatra route parameters are exposed to your application as strings which may then be coerced to more useful classes as needed. sinatra-param smooths over the rough edges and takes care of type coercion and parameter validation on your behalf.

## Key Features

- Provides `param` helper for defining, transforming, and validating parameters.
- Provides `any_of` and `one_of` helpers for advanced parameter validations.
- Supports Ruby 2.4 and newer.

## Getting Started

Before installing and using sinatra-param, you'll want to have [Ruby](https://www.ruby-lang.org) 2.4 (or newer) installed. It's recommended that you use a Ruby version managment tool like [rbenv](https://github.com/rbenv/rbenv), [chruby](https://github.com/postmodern/chruby), or [rvm](https://github.com/rvm/rvm).

sinatra-param is developed using Ruby 2.4.5 and is additionally tested against Ruby 2.5.3 and 2.6.1 using [Travis CI](https://travis-ci.com/jgarber623/sinatra-param).

## Installation

If you're using [Bundler](https://bundler.io), add sinatra-param to your project's `Gemfile`:

```ruby
source 'https://rubygems.org'

gem 'sinatra-param', git: 'https://github.com/jgarber623/sinatra-param', tag: 'v2.0.0'
```

If you're using Bundler 2.0, you may simplify the `Gemfile` line to:

```ruby
gem 'sinatra-param', github: 'jgarber623/sinatra-param', tag: 'v2.0.0'
```

Hop over to your command prompt and run:

```sh
$ bundle install
```

## Usage

The `param` helper takes three arguments: `name` (a `Symbol`), `type` (a `Symbol`), and zero or more `options` (a Hash). The `options` hash may include a number of transformations, validations, or other configuration as mentioned in this documentation.

The `name` argument should match the values you expect your Sinatra application's endpoints to receive (Sinatra's `params` is an [IndifferentHash](https://github.com/sinatra/sinatra/blob/master/lib/sinatra/indifferent_hash.rb) whose keys may be referenced as either `Symbol`s or `String`s).

In your project's `app.rb` file:

```ruby
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/param'

class App < Sinatra::Base
  helpers Sinatra::Param

  before do
    content_type :json
  end

  # GET /search?user=@jgarber
  # GET /search?user=@jgarber&attributes=first_name,email_address,url
  get '/search' do
    param :user,       :string, format: %r{^@\w+}, required: true
    param :attributes, :array,  default: ['first_name', 'last_name']

    json { status: 'OK', … }
  end

  # GET /articles?page=5
  # GET /articles?page=5&order=desc
  get '/articles' do
    param :page,  :integer, default: 1
    param :order, :string,  default: 'ASC', in: ['ASC', 'DESC'], transform: :upcase

    json { status: 'OK', … }
  end

  # /photos?include_drafts=true
  # /photos?taken_in=2015
  get '/photos' do
    param :include_drafts, :boolean, default: false
    param :taken_in,       :integer, within: Range.new(2000, 2019)

    json { status: 'OK', … }
  end
end
```

### Parameter Types

sinatra-param supports the following parameter types:

| Type       | Class        | Matches            | Options/Defaults           |
|:-----------|:-------------|:-------------------|:---------------------------|
| `:string`  | `String`     | `foo`, `bar`       |                            |
| `:array`   | `Array`      | `foo,bar,biz,baz`  | `delimiter: ','`           |
| `:boolean` | `TrueClass`  | `true`, `yes`, `1` |                            |
|            | `FalseClass` | `false`, `no`, `0` |                            |
| `:integer` | `Integer`    | `1`, `500`, `1000` |                            |
| `:float`   | `Float`      | `38.89`, `-77.03`  |                            |

By default, `:array` parameters are comma-separated. This behavior may be customized using the `delimiter` option:

```ruby
# GET /search?categories=foo|bar|biz|baz
get '/search' do
  param :categories, :array, delimiter: '|'

  puts categories # => ['foo', 'bar', 'biz', 'baz']
end
```

### Validations

sinatra-param supports the following parameter validations:

| Name       | Value Class                 | Usage                    |
|:-----------|:----------------------------|:-------------------------|
| `required` | `TrueClass` or `FalseClass` | `required: true`         |
| `format`   | `RegExp`                    | `format: %r{^https?://}` |
| `in`       | `Array`                     | `in: ['ASC', 'DESC']`    |
| `within`   | `Range`                     | `within: (A..Z)`         |

### Defaults

Parmeter defaults may be set using the `default` option:

```ruby
param :taken_in, :integer, default: 2019
```

The `default` option's value can be anything (but should probably match the parameter type) and may also be declared using a `Proc`:

```ruby
param :taken_in, :integer, default: -> { Time.now.year }
```

### Transformations

Transformations may be either a `Symbol` (that maps to a method on the parameter type's underlying Class) or a `Proc`:

```ruby
param :order,  :string,  in: ['ASC', 'DESC'], transform: :upcase
param :offset, :integer, transform: lambda { |n| n - (n % 10) }
```

## Additional Helpers

### `any_of`

Using the `any_of` helper, you can specify that _at least one of_ a set of paramters are required and fail if none of those parameters are provided:

```ruby
param :x, :integer
param :y, :integer

any_of :x, :y
```

### `one_of`

Using the `one_of` helper, you can specify that _only one of_ a set of parameters is required and fail if more than one of those parameters is provided:

```ruby
param :a, :string
param :b, :string
param :c, :string

one_of :a, :b, :c
```

## Exception Handling

By default, when a parameter condition fails, sinatra-param will `halt` with a 400 HTTP error response code and an error message (as either `text/plain` or `application/json`):

```json
{
  "message": "Parameter value \"foo\" must match ^https?://"
}
```

The above would be returned to an end user in response to an HTTP request.

Under the covers, sinatra-param captures one of three types of user-level errors. Each is a subclass of `Sinatra::Param::Error` (which itself subclasses `StandardError`):

- `Sinatra::Param::InvalidParameterError`
- `Sinatra::Param::RequiredParameterError` (raised by the `any_of` helper)
- `Sinatra::Param::TooManyParametersError` (raise by the `one_of` helper)

Additionally, `Sinatra::Param::ArgumentError`s will be raised if implementation errors are encountered (e.g. mismatches between a parameter type and its default value).

If you'd prefer to handle these errors on your own, you can add the `raise: true` option to any `param`, `one_of`, or `any_of` declaration:

```ruby
param :order,      :string, in: ['ASC', 'DESC'], raise: true
param :query,      :string
param :categories, :array

one_of :query, :categories, raise: true
```

For this to work in development, you may need to add the following configuration to your Sinatra application:

```ruby
class App < Sinatra::Base
  configure do
    set :raise_errors, true
    set :show_exceptions, false
  end
end
```

## Acknowledgments

This project is a fork of [sinatra-param](https://github.com/mattt/sinatra-param) and wouldn't exist without [Mattt](https://mat.tt). This fork is written and maintained by [Jason Garber](https://sixtwothree.org).

The following projects work well in conjunction with sinatra-param:

- [sinatra-contrib](https://github.com/sinatra/sinatra/tree/master/sinatra-contrib) ([documentation](http://sinatrarb.com/contrib/))
- [rack-contrib](https://github.com/rack/rack-contrib) (`Rack::NestedParams` and `Rack::PostBodyContentTypeParser` in particular)

## License

sinatra-param is freely available under the [MIT License](https://opensource.org/licenses/MIT). Use it, learn from it, fork it, improve it, change it, tailor it to your needs.
