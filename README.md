# generator-goodeggs-npm [![Build Status](https://secure.travis-ci.org/goodeggs/generator-goodeggs-npm.png?branch=master)](https://travis-ci.org/goodeggs/generator-goodeggs-npm)

[Yeoman](http://yeoman.io) generator for NPM packages following Good Eggs conventions.


## Getting Started

You need Yeoman:
```
$ npm install -g yo
```

generator-goodeggs-npm isn't published to NPM, since it's just for us.  Point at the URL instead:

```
$ npm install -g git+https://github.com/goodeggs/generator-goodeggs-npm
```

Or even better, checkout and link the repo so you can quickly fix things that don't work right:
```
$ git clone https://github.com/goodeggs/generator-goodeggs-npm.git
$ cd generator-goodeggs-git && npm link
```

Then you can start a new node module with:
```
$ yo goodeggs-npm
```
