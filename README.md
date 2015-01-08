# awdb

This is a database, stored in-browser, to support the distribution of a magazine. Still very preliminary.

## On dialects

There’s a haphazard mixture here of CoffeeScript and JavaScript, as well as Emblem and Handlebars. I’ve historically appreciated time-saving whitespace-aware formats, but I’m thinking about abandoning them for [various](http://www.samselikoff.com/blog/one-reason-to-stop-using-coffeescript/) [reasons](https://github.com/machty/emblem.js/issues/189). Once I’ve decided, I’ll update everything to use the same formats consistently.

## Prerequisites

You will need the following things properly installed on your computer.

* [Git](http://git-scm.com/)
* [Node.js](http://nodejs.org/) (with NPM) and [Bower](http://bower.io/)

## Installation

* `git clone https://github.com/backspace/awdb`
* `cd awdb`
* `npm install`
* `bower install`

## Running / Development

* `ember server`
* Visit your app at [http://localhost:4200](http://localhost:4200).

### Running Tests

* `ember test`
* `ember test --server`

### Building

* `ember build` (development)
* `ember build --environment production` (production)
